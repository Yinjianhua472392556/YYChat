//
//  FmdbTool.h
//  YYChat
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageModel.h"

//#import "YYConversationModel.h"

/*
 toUID text,timeStamp text,badge text,message blob
 */

@interface FmdbTool : NSObject
SingletonH(fmdbTool);

#pragma mark - 聊天消息的数据库方法
//添加数据
- (BOOL)addMessage:(YYMessageModel *)messageModel
             toUID:(NSString *)toUID
         timeStamp:(NSString *)timeStamp
    isConversation:(BOOL)isConversation;

//判断用户是否已经存在
- (BOOL)judgeIfToUIDExist:(NSString *)toUID isConversation:(BOOL)isConversation;

//根据toUID删除指定聊天对象的聊天数据
- (void)deleteMessageDataWithToUID:(NSString *)toUID isConversation:(BOOL)isConversation;

//查询所有的数据
- (NSArray *)selectAllMessageDataIsConversation:(BOOL)isConversation;

//根据toUID查询单个聊天对象的聊天数据
- (NSMutableArray *)selectMessageDataWithToUID:(NSString *)toUID isConversation:(BOOL)isConversation;

//更新数据库里面的东西
- (BOOL)updateWithToUID:(NSString *)toUID
              timeStamp:(NSString *)timeStamp
           messageModel:(YYMessageModel *)messageModel
         isConversation:(BOOL)isConversation;

#pragma mark - 聊天对象的数据库方法


////添加数据
//- (BOOL)addConversationMessage:(YYMessageModel *)messageModel
//             toUID:(NSString *)toUID
//         timeStamp:(NSString *)timeStamp
//             badge:(NSString *)badge;
//
//
////判断用户是否已经存在
//- (BOOL)judgeConversationIfToUIDExist:(NSString *)toUID;
//
//
////查询所有的数据
//- (NSArray *)selectAllConversationMessageData;
//
//
////根据toUID查询单个聊天对象的聊天数据
//- (NSMutableArray *)selectConversationMessageDataWithToUID:(NSString *)toUID;


@end
