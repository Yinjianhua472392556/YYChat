//
//  ChatViewController.m
//  YYChat
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatViewController.h"
#import "YYMessageModel.h"


#import "CacheFileHelper.h"
#import "FmdbTool.h"

@interface ChatViewController ()<UIAlertViewDelegate> {

    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) NSMutableDictionary *emotionDic;

@end

@implementation ChatViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.dataSource = self;
    self.delegate = self;
    
    [self _setupBarButtonItem];
    
}


- (void)dealloc {

    NSLog(@"ChatViewController   dealloc");
}


#pragma mark - setup subviews

- (void)_setupBarButtonItem {
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
}




#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        
    }
}


#pragma mark - EaseMessageViewControllerDelegate

//- (BOOL)messageViewController:(YYMessageViewController *)viewController canLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return YES;
//}
//
//- (BOOL)messageViewController:(YYMessageViewController *)viewController didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    id object = [self.dataArray objectAtIndex:indexPath.row];
//    
//    if (![object isKindOfClass:[NSString class]]) {
//        
//        self.menuIndexPath = indexPath;
//        [self showMenuViewController:nil andIndexPath:indexPath messageType:0];
//    }
//    
//    return YES;
//}
//
//- (void)messageViewController:(YYMessageViewController *)viewController didSelectAvatarMessageModel:(id)messageModel {
//
//}

#pragma mark - EaseMessageViewControllerDataSource

//- (id<IMessageModel>)messageViewController:(YYMessageViewController *)viewController
//                           modelForMessage:(YYMessage *)message {
//
//    id<IMessageModel> model = nil;
//    model = [[YYMessageModel alloc] initWithMessage:message];
//    
//    return model;
//}


- (NSArray *)emotionFormessageViewController:(YYMessageViewController *)viewController {
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];

    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    return @[managerDefault,managerGif];
}

//- (BOOL)isEmotionMessageFormessageViewController:(YYMessageViewController *)viewController messageModel:(id<IMessageModel>)messageModel {
//    BOOL flag = NO;
////    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
////        return YES;
////    }
//    return flag;
//}

//- (EaseEmotion *)emotionURLFormessageViewController:(YYMessageViewController *)viewController messageModel:(id<IMessageModel>)messageModel {
//    NSString *emotionId;
//    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
//    return emotion;
//}

//- (NSDictionary*)emotionExtFormessageViewController:(YYMessageViewController *)viewController
//                                        easeEmotion:(EaseEmotion*)easeEmotion
//{
//    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
//}

#pragma mark - private

//- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(YYMessageBodyType)messageType {
//
//    if (self.menuController == nil) {
//        self.menuController = [UIMenuController sharedMenuController];
//    }
//    
//    if (_deleteMenuItem == nil) {
//        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
//    }
//    
//    if (_copyMenuItem == nil) {
//        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
//    }
//    
//    if (_transpondMenuItem == nil) {
//        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
//    }
//    
//    if (messageType == YYMessageBodyTypeText) {
//        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
//    } else if (messageType == YYMessageBodyTypeImage){
//        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
//    } else {
//        [self.menuController setMenuItems:@[_deleteMenuItem]];
//    }
//    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
//    [self.menuController setMenuVisible:YES animated:YES];
//
//}


#pragma mark - action
- (void)deleteAllMessages:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    [alertView show];


}
//
//
//- (void)deleteMenuAction:(id)sender {
//
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        
//    }
//    
//    self.menuIndexPath = nil;
//
//}
//
//- (void)copyMenuAction:(id)sender {
//
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        
//    }
//    
//    self.menuIndexPath = nil;
//}
//
//
//- (void)transpondMenuAction:(id)sender {
//
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        
//    }
//    
//    self.menuIndexPath = nil;
//}

@end
