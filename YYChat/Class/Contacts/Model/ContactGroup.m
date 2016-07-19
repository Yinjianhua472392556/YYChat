//
//  ContactGroup.m
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ContactGroup.h"
#import "ContactGroupList.h"

@implementation ContactGroup

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {

    return @{@"userList" : [ContactGroupList class]};
}

- (NSString *)description { return [self yy_modelDescription]; }
@end
