//
//  YYConversationListViewController.m
//  YYChat
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYConversationListViewController.h"

#import "YYConversationCell.h"
#import "ChatViewController.h"
#import "EaseEmotionEscape.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

#import "FmdbTool.h"
#import "ContactGroupList.h"

@interface YYConversationListViewController ()

@property (nonatomic, assign) int messageCount; //未读消息总数
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *defaultFooterView;


@end

@implementation YYConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息列表";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.defaultFooterView;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //监听消息来得通知
    [Mynotification addObserver:self selector:@selector(messageCome:) name:SendMsgName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self readChatData];
}

- (void)readChatData {

    //取出数据库里面的数据，刷新表格
    self.dataArray = [[[FmdbTool sharedfmdbTool] selectAllMessageDataIsConversation:YES] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Action

- (void)messageCome:(NSNotification *)notification {

        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dict = [notification object];
            
            NSString *body = [dict objectForKey:@"body"];
            YYMessageModel *model = [YYMessageModel yy_modelWithJSON:body];
            
            NSString *timeStamp = [dict objectForKey:@"time"];
            NSString *whoSender = [dict objectForKey:@"sender"];
            
            model.timeStamp = timeStamp;
            model.badgeValue = [NSString stringWithFormat:@"%ld",[model.badgeValue integerValue] + 1];
            
            NSString *toUID = nil;
            if ([whoSender isEqualToString:@"other"]) { //通过代理收到的消息
                toUID = model.from.userID;
                model.isSender = NO;
            }else { //聊天页面自己发送的消息
                toUID = model.to.userID;
                model.isSender = YES;
            }
            
            //如果用户在本地数据库中已存在 就直接更新聊天数据
            if ([[FmdbTool sharedfmdbTool] judgeIfToUIDExist:toUID isConversation:YES]) {
                
                //取出对应UID的旧模型数据
                YYMessageModel *oldModel = [[[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:toUID isConversation:YES] lastObject];
                
                //根据取出的模型修改当前model的badgeValue值
                if ([whoSender isEqualToString:@"other"]) { //收到的消息，需要修改badgeValue的值，使其加一
                    model.badgeValue = [NSString stringWithFormat:@"%ld",[oldModel.badgeValue integerValue] + 1];
                }else { //为自己发送的消息时，则表明用户已经进入聊天页面，此时应该将badgeValue清空
                    model.badgeValue = @"";
                }
                
                //用最新的模型替换数据库中旧的模型
                [[FmdbTool sharedfmdbTool] updateWithToUID:toUID timeStamp:timeStamp messageModel:model isConversation:YES];
                
                //取出数据库里面的数据，刷新表格
                self.dataArray = [[[FmdbTool sharedfmdbTool] selectAllMessageDataIsConversation:YES] mutableCopy];
                [self.tableView reloadData];
            }
            else { //没有的话 添加数据
                
                if ([whoSender isEqualToString:@"myself"]) { //为自己发送的消息时，则表明用户已经进入聊天页面，此时应该将badgeValue清空
                    model.badgeValue = @"";
                }else {
                
                }
                
                //将数据模型添加到数据库
                [[FmdbTool sharedfmdbTool] addMessage:model toUID:toUID timeStamp:timeStamp isConversation:YES];
                
                //取出数据库里面的数据,刷新表格
                self.dataArray = [[[FmdbTool sharedfmdbTool] selectAllMessageDataIsConversation:YES] mutableCopy];
                [self.tableView reloadData];
            }
            
        });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *CellIdentifier = [YYConversationCell cellIdentifierWithModel:nil];
    YYConversationCell *cell = (YYConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[YYConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    YYMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    cell.timeLabel.text = model.timeStamp;

    return cell;

}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [YYConversationCell cellHeightWithModel:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YYMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ContactGroupList *toUser = [[ContactGroupList alloc] init];
    if (model.isSender) { //模型如果为发送者，则应该取聊天对象的uid(即model.to.userID)
        //组装ContactGroupList模型
        toUser.uid = model.to.userID;
        toUser.nickname = model.to.userName;
        toUser.headsmall = model.to.headUrl;

    }else {
        //组装ContactGroupList模型
        toUser.uid = model.from.userID;
        toUser.nickname = model.from.userName;
        toUser.headsmall = model.from.headUrl;
    }
    
#pragma mark - 进入聊天页面前清空对应badgeValue的值
    
    //取出对应UID的旧模型数据
    YYMessageModel *oldModel = [[[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:toUser.uid isConversation:YES] lastObject];
    
    //修改badgeValue的值
    oldModel.badgeValue = @"";
    //用修改后的模型替换数据库中旧的模型
    [[FmdbTool sharedfmdbTool] updateWithToUID:toUser.uid timeStamp:oldModel.timeStamp messageModel:oldModel isConversation:YES];

    ChatViewController *viewController = [[ChatViewController alloc] initWithConversationChatter:toUser conversationType:0];
    viewController.title = toUser.nickname;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除数据库里面的数据，更新数据源然后刷新
        
        YYMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
        NSString *toUID = nil;
        
        if (model.isSender) { //模型如果为发送者，则应该取聊天对象的uid(即model.to.userID)
            toUID = model.to.userID;
            
        }else {
            toUID = model.from.userID;
        }
        
        
        //更新数据库
        [[FmdbTool sharedfmdbTool] deleteMessageDataWithToUID:toUID isConversation:YES];
        [[FmdbTool sharedfmdbTool] deleteMessageDataWithToUID:toUID isConversation:NO]; //删除对应的聊天信息
        
        //取出数据库里面的数据，刷新表格
        self.dataArray = [[[FmdbTool sharedfmdbTool] selectAllMessageDataIsConversation:YES] mutableCopy];
        [self.tableView reloadData];

    }
}

#pragma mark - private

- (NSString *)_latestMessageTitleForConversationModel:(YYMessageModel *)conversationModel {


    NSString *latestMessageTitle = @"";

    switch (conversationModel.typefile) {
        case YYMessageBodyTypeText: {
            NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:conversationModel.content];
            latestMessageTitle = didReceiveText;

            break;
        }
        case YYMessageBodyTypeImage: {
            latestMessageTitle = @"[图片]";
            break;
        }
        case YYMessageBodyTypeVoice: {
            latestMessageTitle = @"[语音]";
            break;
        }
        case YYMessageBodyTypeLocation: {
            
            break;
        }
        case YYMessageBodyTypeVideo: {
            
            break;
        }
        case YYMessageBodyTypeFile: {
            
            break;
        }
        case YYMessageBodyTypeCmd: {
            
            break;
        }
    }
    
    return latestMessageTitle;
}


#pragma mark - lanjiazai
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (UIView *)defaultFooterView {
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    
    return _defaultFooterView;
}

@end
