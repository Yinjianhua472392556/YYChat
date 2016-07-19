//
//  RootTabViewController.m
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootTabViewController.h"
#import "CustomNavgationController.h"
#import "ContactListController.h"
#import "PersonalViewController.h"
#import "YYConversationListViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    
    NSArray *imageArray = @[@{@"image":@"messageList",@"selectedImage":@"messageList_selected", @"title" : @"消息列表"},
                            @{@"image":@"contactsList",@"selectedImage":@"contactsList_selected",@"title" : @"通讯录"},
                            @{@"image":@"personalCenter",@"selectedImage":@"personalCenter_selected", @"title" : @"个人中心"},
                            ];
    
    
    [imageArray enumerateObjectsUsingBlock:^(NSDictionary *imageDict, NSUInteger idx, BOOL *stop) {
        UITabBarItem *item = self.tabBar.items[idx];
        item.image = [[UIImage imageNamed:imageDict[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imageDict[@"selectedImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.title = [NSString stringWithFormat:@"%@",imageDict[@"title"]];
    }];
    
    
    self.selectedIndex = 0;

}


- (void)setupSubviews {

    ContactListController *contactList = [[ContactListController alloc] init];
    CustomNavgationController *contackListNav = [self viewControllerWithNav:contactList];
    UIStoryboard *personalStory = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PersonalViewController *personalVC = [personalStory instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalViewController class])];
    CustomNavgationController *personalNav = [self viewControllerWithNav:personalVC];
    YYConversationListViewController *conversationList = [[YYConversationListViewController alloc] init];
    CustomNavgationController *conversationListNav = [self viewControllerWithNav:conversationList];
    self.viewControllers = @[conversationListNav,contackListNav,personalNav];
    
}




- (CustomNavgationController *)viewControllerWithNav:(UIViewController *)viewController {

    CustomNavgationController *nav = [[CustomNavgationController alloc] initWithRootViewController:viewController];
    
    return nav;

}

@end
