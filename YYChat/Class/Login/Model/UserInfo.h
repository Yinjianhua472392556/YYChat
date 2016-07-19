//
//  UserInfo.h
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface UserInfo : NSObject<NSCoding,NSCopying>


@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headsmall;
@property (nonatomic, copy) NSString *headlarge;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *qq;


@end
