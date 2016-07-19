//
//  AppDelegate.m
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabViewController.h"
#import "LoginController.h"
#import "UerOperation.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma lifeCycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //注册通知
    
    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    if (sysVersion>=8.0) {
        UIUserNotificationType type=UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
    }
    
    //通过这个方法决定跳转到那个视图
    [UserOperation loginByStatus];
    
    //设置导航条样式
    [self customizeInterface];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private
- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundColor:[UIColor whiteColor]];
    [navigationBarAppearance setTintColor:[UIColor blackColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];

}



#pragma mark - public

- (void)setupTabViewController {

    RootTabViewController *rootVC = [[RootTabViewController alloc] init];
    [self.window setRootViewController:rootVC];

}

- (void)setupLoginViewController {

    LoginController *loginVC = [[LoginController alloc] init];
    [self.window setRootViewController:loginVC];

}

@end
