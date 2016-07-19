//
//  UserOfMessage.h
//  YYChat
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface UserOfMessage : NSObject<NSCopying,NSCoding,YYModel>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *headUrl;

@end
