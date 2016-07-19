//
//  UerOperation.h
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOperation : NSObject
SingletonH(user);

//把用户名和密码保存到沙河
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *telephone;
//登录的状态
@property (nonatomic, assign) BOOL loginStatus;

+ (void)loginByStatus;

@end
