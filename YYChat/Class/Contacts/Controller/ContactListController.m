//
//  ContactListController.m
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ContactListController.h"
#import "ContactGroup.h"
#import "ContactGroupList.h"
#import "ContactHeaderView.h"
#import "ContactGroupListCell.h"
#import "NetworkingHelper.h"
#import "UIButton+EMWebCache.h"
#import "ChatViewController.h"
#import "XmppTools.h"
#import "ContactDetailsController.h"

@interface ContactListController ()<UITableViewDelegate,UITableViewDataSource,ContactHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groupDataSource; //分组数组
@end

@implementation ContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[ContactGroupListCell class] forCellReuseIdentifier:@"ContactGroupListCell"];
    [self.tableView registerClass:[ContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"ContactHeaderView"];
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    
    [[XmppTools sharedxmpp] login:nil];
    
    [self loadGroupData];
}

- (void)loadGroupData {
    [[NetworkingHelper shareHelper] getContactsListWithPath:@"http://10.1.125.63:6080/weiyuan/user/api/getContactList1" params:nil completion:^(id data, NSError *error) {
        if (data) {
            NSArray *groupDictArray = [NSArray arrayWithArray:data];
            for (NSDictionary *groupDict in groupDictArray) {
                ContactGroup *group = [ContactGroup yy_modelWithJSON:groupDict];
                [self.groupDataSource addObject:group];
            }
            
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark - UITableView Datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ContactHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ContactHeaderView"];
    headerView.delegate = self;
    headerView.contactGroup = self.groupDataSource[section];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactGroupListCell"];
    ContactGroup *group = self.groupDataSource[indexPath.section];
    ContactGroupList *user = group.userList[indexPath.row];
    cell.nameLabel.text = user.nickname;
    cell.signLabel.text = user.sign;
    [cell.iconBtton sd_setImageWithURL:[NSURL URLWithString:user.headsmall] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
    cell.iconBlock = ^(UIButton *sender){        //点击头像，跳转到好友详细信息界面
    
    };
    
    return cell;
}

#pragma mark -- UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.groupDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ContactGroup *group = self.groupDataSource[section];
    
    if (group.isOpen) {
        return group.userList.count;
    }else {
    
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactGroup *group = self.groupDataSource[indexPath.section];
    ContactGroupList *groupList = group.userList[indexPath.row];

    UIStoryboard *contactsStoryboard = [UIStoryboard storyboardWithName:@"ContactList" bundle:nil];
    
    ContactDetailsController *detailsVC = [contactsStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([ContactDetailsController class])];
    detailsVC.groupList = groupList;
    
    [self.navigationController pushViewController:detailsVC animated:YES];

}



- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *messageAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"短信" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //1.取出对应的模型数据
        ContactGroup *group = self.groupDataSource[indexPath.section];
        ContactGroupList *groupList = group.userList[indexPath.row];

        
        //2.调用系统API
        NSString *messagePhoneNum = [NSString stringWithFormat:@"sms://%@",groupList.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:messagePhoneNum]];
        
    }];
    
    UITableViewRowAction *telephoneAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //1.取出对应的模型数据
        ContactGroup *group = self.groupDataSource[indexPath.section];
        ContactGroupList *groupList = group.userList[indexPath.row];

        
        //2.调用系统API
        NSString *telephoneNum = [NSString stringWithFormat:@"tel://%@",groupList.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephoneNum]];
        
    }];
    
    messageAction.backgroundColor = [UIColor lightGrayColor];
    telephoneAction.backgroundColor = [UIColor redColor];

    
    return @[messageAction,telephoneAction];
}

#pragma - getter

- (NSMutableArray *)groupDataSource {

    if (_groupDataSource == nil) {
        _groupDataSource = [NSMutableArray array];
    }
    return _groupDataSource;
}



//调用HeaderView代理方法，同时刷新tableview
- (void)didClickHeaderView:(ContactHeaderView *)headerView {
    [self.tableView reloadData];
}


@end
