//
//  ContactDetailsController.m
//  YYChat
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ContactDetailsController.h"
#import "ContactGroupList.h"
#import "UIButton+EMWebCache.h"
#import "UIImageView+EMWebCache.h"
#import "ChatViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+HUD.h"

@interface ContactDetailsController ()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *homePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation ContactDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.groupList.headsmall] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];

    
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.groupList.headsmall] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
    self.nameLabel.text = self.groupList.nickname;
    self.departmentLabel.text = [NSString stringWithFormat:@"广东中实国润  %@",self.groupList.groupname];
    self.signLabel.text = self.groupList.sign;
    self.homePhoneLabel.text = self.groupList.phone;
    self.telephoneLabel.text = self.groupList.telephone;
    self.emailLabel.text = self.groupList.email;
    self.QQLabel.text = self.groupList.qq;
    
}


- (IBAction)iconButtonAction:(UIButton *)sender {
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:HUD];
     [HUD show:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.color = [UIColor whiteColor];
    
    HUD.customView = self.iconImageView;
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}


- (void)hideHUD:(UIGestureRecognizer *)recognizer {
    [(MBProgressHUD *)recognizer.view hide:YES];
}

- (IBAction)sendMessageAction:(UIButton *)sender {
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:self.groupList conversationType:YYChatTypeChat];
    chatVC.title = self.groupList.nickname;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (IBAction)sendVideoAction:(UIButton *)sender {

    [self showHint:@"功能开发中"];
}


@end
