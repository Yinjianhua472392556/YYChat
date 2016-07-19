//
//  PersonalViewController.m
//  YYChat
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalViewController.h"
#import "UserInfo.h"
#import "UIImageView+EMWebCache.h"
#import "XmppTools.h"
#import "UerOperation.h"
#import "UIViewController+HUD.h"

@interface PersonalViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDepartmentLabel;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.tabBarItem.title = @"个人中心";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [self.headerView addGestureRecognizer:tap];
    
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucuments = [array objectAtIndex:0];
    NSString *path = [doucuments stringByAppendingString:@"/user.archive"];
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"user: %@  path: %@",user, path);

    self.userNameLabel.text = user.nickname;
    self.userDepartmentLabel.text = user.groupName;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.headsmall] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSLog(@"didSelectRowAtIndexPath %ld -- %ld", (long)indexPath.section, (long)indexPath.row);
    
    if (indexPath.section == 3 && indexPath.row == 0) { //设置
        
        [[XmppTools sharedxmpp] xmppLoginOut];
        [UserOperation loginByStatus];
        
    }else {
    
        [self showHint:@"功能开发中"];
    }
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 20;
}


#pragma mark - action 

- (void)tapHeader:(UIGestureRecognizer *)recognizer {

    NSLog(@"tapHeader");
}

@end
