//
//  UerOperation.m
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UerOperation.h"
#import "AppDelegate.h"


@implementation UserOperation
SingletonM(user);


#pragma mark - setter

- (void)setUserName:(NSString *)userName {

    [UserDefaults setObject:userName forKey:@"username"];
    [UserDefaults synchronize];
}

- (void)setPassword:(NSString *)password {

    [UserDefaults setObject:password forKey:@"password"];
    [UserDefaults synchronize];
}

- (void)setLoginStatus:(BOOL)loginStatus {

    [UserDefaults setBool:loginStatus forKey:@"loginStatus"];
    [UserDefaults synchronize];
}

- (void)setTelephone:(NSString *)telephone {

    [UserDefaults setObject:telephone forKey:@"telephone"];
}

#pragma mark - getter

- (NSString *)userName {
    NSString *name = [UserDefaults objectForKey:@"username"];
    return name;
}

- (NSString *)password {
    NSString *password = [UserDefaults objectForKey:@"password"];
    return password;
}

- (BOOL)loginStatus {
    BOOL status = [UserDefaults boolForKey:@"loginStatus"];
    return status;
}

- (NSString *)telephone {

    return [UserDefaults objectForKey:@"telephone"];
}

#pragma mark - public

+ (void)loginByStatus {

    UserOperation *user = [UserOperation shareduser];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (user.loginStatus) {
        [appDelegate setupTabViewController];
    }else {
        [appDelegate setupLoginViewController];
    }
}


@end
