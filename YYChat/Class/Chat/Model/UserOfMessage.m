//
//  UserOfMessage.m
//  YYChat
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserOfMessage.h"

#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

@implementation UserOfMessage
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {

    return @{@"userID" : @"id",
             @"userName" : @"name",
             @"headUrl" : @"url"};
}


- (NSString *)yy_modelDescription {
    
    return  [self yy_modelDescription];
}

YYModelSynthCoderAndHash
@end
