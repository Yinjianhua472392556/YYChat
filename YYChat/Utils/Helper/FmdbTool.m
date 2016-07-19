//
//  FmdbTool.m
//  YYChat
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FmdbTool.h"
#import <FMDB/FMDB.h>
#import "UserInfo.h"

static FMDatabaseQueue *_queue;

/**
 *  @author 尹建华, 16-07-01 11:07:10
 *
 *  数据库结构：使用登录用户创建的数据库，每个数据库中包含chatMessageTable和ConversationMessageTable俩个表。其中表结构都为（toUID,timeStamp,message）。toUID为聊天对象的openfire账号（用于查找）timeStamp为聊天消息的时间戳，用于查找聊天消息是排序。message为保存的二进制YYMessageModel对象,用于表示一条聊天消息和badgeValue等。
 */

@implementation FmdbTool

SingletonM(fmdbTool);


#pragma mark - private 

- (void)_privateMessageInit {

        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *doucuments = [array objectAtIndex:0];
        NSString *path = [doucuments stringByAppendingString:@"/user.archive"];
        UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        NSString *dbPath = [[array objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",user.phone]];
//        NSLog(@"dbPath : %@", dbPath);
    
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        
        //创建表
        
        [_queue inDatabase:^(FMDatabase *db) {
            
            BOOL tableBool = [db executeUpdate:@"create table if not exists chatMessageTable(ID integer primary key autoincrement,toUID text,timeStamp text,message blob)"];
            if (!tableBool) {
                NSLog(@"创建表失败");
            }
        }];
}


#pragma mark - 聊天对象的数据库方法

- (void)_privateConversationInit {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucuments = [array objectAtIndex:0];
    NSString *path = [doucuments stringByAppendingString:@"/user.archive"];
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSString *dbPath = [[array objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",user.phone]];
//    NSLog(@"dbPath : %@", dbPath);
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //创建表
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        BOOL tableBool = [db executeUpdate:@"create table if not exists ConversationMessageTable(ID integer primary key autoincrement,toUID text,timeStamp text,message blob)"];
        if (!tableBool) {
            NSLog(@"创建表失败");
        }
    }];
    
}


#pragma mark - public

- (BOOL)addMessage:(YYMessageModel *)messageModel toUID:(NSString *)toUID timeStamp:(NSString *)timeStamp isConversation:(BOOL)isConversation{

    if (isConversation) {
        [self _privateConversationInit];
    }
    else {
        [self _privateMessageInit];
    }
    
    
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
        //将对象转为二进制
        NSData *message = [NSKeyedArchiver archivedDataWithRootObject:messageModel];
        if (isConversation) {
            success = [db executeUpdate:@"insert into ConversationMessageTable(toUID,timeStamp,message) values(?,?,?)",toUID,timeStamp,message];

        }
        else {
            success = [db executeUpdate:@"insert into chatMessageTable(toUID,timeStamp,message) values(?,?,?)",toUID,timeStamp,message];
        }
    }];
    
    return success;
}

- (BOOL)judgeIfToUIDExist:(NSString *)toUID isConversation:(BOOL)isConversation{

    if (isConversation) {
        [self _privateConversationInit];
    }
    else {
        [self _privateMessageInit];
    }

    
    __block BOOL success = NO;
    [_queue inDatabase:^(FMDatabase *db) {
       
        if (isConversation) {
            
            FMResultSet *resultSet = [db executeQuery:@"select * from ConversationMessageTable where toUID = ?",toUID];
            while ([resultSet next]) {
                success = YES;
            }
        }
        else {
            
            FMResultSet *resultSet = [db executeQuery:@"select * from chatMessageTable where toUID = ?",toUID];
            while ([resultSet next]) {
                success = YES;
            }
        }
     }];
    
    return success;
}

#pragma mark 删除聊天数据的方法

- (void)deleteMessageDataWithToUID:(NSString *)toUID isConversation:(BOOL)isConversation{

    if (isConversation) {
        [self _privateConversationInit];
    }
    else {
        [self _privateMessageInit];
    }

    
    [_queue inDatabase:^(FMDatabase *db) {
        if (isConversation) {
            
            BOOL success = [db executeUpdate:@"delete from ConversationMessageTable where toUID = ?",toUID];
            if (!success) {
                NSLog(@"删除失败");
            }
        }
        else {
            BOOL success = [db executeUpdate:@"delete from chatMessageTable where toUID = ?",toUID];
            if (!success) {
                NSLog(@"删除失败");
            }
        }
 
    }];
}


//查询所有的数据
- (NSArray *)selectAllMessageDataIsConversation:(BOOL)isConversation {

    if (isConversation) {
        [self _privateConversationInit];
    }
    else {
        [self _privateMessageInit];
    }

    __block NSMutableArray *array = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        if (isConversation) {
            
            FMResultSet *resultSet = [db executeQuery:@"select * from ConversationMessageTable order by timeStamp desc"];
            if (resultSet) {
                //创建数组
                array = [NSMutableArray array];
                while ([resultSet next]) {
                    //将取出的每行数据转化为模型添加到数组中 这里暂时先用YYMessageModel替代显示聊天数据
                    NSData *message = [resultSet dataForColumn:@"message"];
                    YYMessageModel *messageModel = [NSKeyedUnarchiver unarchiveObjectWithData:message];
                    [array addObject:messageModel];
                }
            }

        }
        else {
            FMResultSet *resultSet = [db executeQuery:@"select * from chatMessageTable order by timeStamp desc"];
            if (resultSet) {
                //创建数组
                array = [NSMutableArray array];
                while ([resultSet next]) {
                    //将取出的每行数据转化为模型添加到数组中 这里暂时先用YYMessageModel替代显示聊天数据
                    NSData *message = [resultSet dataForColumn:@"message"];
                    YYMessageModel *messageModel = [NSKeyedUnarchiver unarchiveObjectWithData:message];
                    [array addObject:messageModel];
                }
            }
        }
        
     }];
    
    return array;
}

//查询单个聊天对象的聊天数据
- (NSMutableArray *)selectMessageDataWithToUID:(NSString *)toUID isConversation:(BOOL)isConversation{
    
    if (isConversation) {
        [self _privateConversationInit];
    }
    else {
        [self _privateMessageInit];
    }

    __block NSMutableArray *array = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        if (isConversation) {
            
            FMResultSet *resultSet = [db executeQuery:@"select * from ConversationMessageTable where toUID = ? order by timeStamp asc",toUID];
            if (resultSet) {
                array = [NSMutableArray array];
                while ([resultSet next]) {
                    //将取出的每行数据转化为模型添加到数组中 这里暂时先用YYMessageModel替代显示聊天数据
                    NSData *message = [resultSet dataForColumn:@"message"];
                    YYMessageModel *messageModel = [NSKeyedUnarchiver unarchiveObjectWithData:message];
                    [array addObject:messageModel];
                }
            }

        }
        else {
            FMResultSet *resultSet = [db executeQuery:@"select * from chatMessageTable where toUID = ? order by timeStamp asc",toUID];
            if (resultSet) {
                array = [NSMutableArray array];
                while ([resultSet next]) {
                    //将取出的每行数据转化为模型添加到数组中 这里暂时先用YYMessageModel替代显示聊天数据
                    NSData *message = [resultSet dataForColumn:@"message"];
                    YYMessageModel *messageModel = [NSKeyedUnarchiver unarchiveObjectWithData:message];
                    [array addObject:messageModel];
                }
            }
        }
        
      }];
    
    return array;
}


- (BOOL)updateWithToUID:(NSString *)toUID timeStamp:(NSString *)timeStamp  messageModel:(YYMessageModel *)messageModel  isConversation:(BOOL)isConversation {
    
    __block BOOL success;
    
    if (isConversation) {
        
        NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:messageModel];
        [_queue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:@"update ConversationMessageTable set timeStamp = ? , message = ? where toUID=?",timeStamp,messageData,toUID];
        }];
    }
    else {
    
        NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:messageModel];
        [_queue inDatabase:^(FMDatabase *db) {
            success = [db executeUpdate:@"update chatMessageTable set timeStamp = ? , message = ? where toUID=?",timeStamp,messageData,toUID];
        }];
    }
    
    return success;
}




@end
