//
//  NetworkingHelper.m
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NetworkingHelper.h"
#import <AFNetworking/AFNetworking.h>


#import "YYMessageModel.h"
#import "FmdbTool.h"

static NetworkingHelper *helper = nil;

@implementation NetworkingHelper

- (instancetype)init {

    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

+ (instancetype)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NetworkingHelper alloc] init];
    });
    
    return helper;
}


#pragma mark - private

- (void)commonInit {

}


- (AFHTTPRequestOperationManager *)_managerInstance {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    return manager;
    
}

#pragma mark - login

- (void)loginWithPath:(NSString *)path params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [self _managerInstance];

    [manager GET:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completion(nil,error);
    }];
    
}


#pragma mark - 获取联系人列表

- (void)getContactsListWithPath:(NSString *)path params:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {

    AFHTTPRequestOperationManager *manager = [self _managerInstance];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            id result = responseObject[@"data"];
            completion(result,nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(nil,error);
    }];
    
}

#pragma mark - 下载语音

- (void)getVoiceWithPath:(NSString *)path completion:(void (^)(id data, NSError *error))completion {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

#pragma mark - send message



- (void)sendMessageWithPath:(NSString *)path toUser:(ContactGroupList *)toUser sendData:(NSData *)data voiceTime:(NSInteger)voiceTime context:(NSString *)context chatType:(int)chatType fileType:(int)fileType completion:(void (^)(id data, NSError *error))completion{

    
    UserInfo *userInfo = [self getCurrentLoginInfo];
    
    AFHTTPRequestOperationManager *manager = [self _managerInstance];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userInfo.uid forKey:@"uid"];
    [params setObject:userInfo.nickname forKey: @"fromname"];
    [params setObject:userInfo.headsmall forKey:@"fromurl"];
    [params setObject:toUser.uid forKey:@"toid"];
    [params setObject:toUser.nickname forKey:@"toname"];
    [params setObject:toUser.headsmall forKey:@"tourl"];
    [params setObject:@(chatType) forKey:@"typechat"];
    [params setObject:@(fileType) forKey:@"typefile"];
    
    
    if (fileType == 1) { //文字
        [params setObject:context forKey:@"content"];
    }
    
    if (fileType == 3) { //语音
        [params setObject:@(voiceTime) forKey:@"voicetime"];
    }
    
    
    [manager POST:@"http://58.248.159.6:6080/weiyuan/user/api/sendMessage?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data && fileType == 3) { //语音
            [formData appendPartWithFileData:data name:@"file" fileName:@"123.amr" mimeType:@"audio/amr-wb"];
        }
        
        if (data && fileType == 2) { //图片
            [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        id result = responseObject[@"data"];
        
        //发送消息成功后，将其保存到数据库，进入聊天页面时从数据库拿取
        YYMessageModel *model = [YYMessageModel yy_modelWithJSON:result];
        model.isSender = YES;
        
        //创建时间戳
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStamp = [formatter stringFromDate:date];
        
        //创建并发送通知，用于在YYConversationListViewController中监听并处理
        
        NSDictionary *dict = @{@"body" : result, @"time" : timeStamp, @"sender" : @"myself"};
        NSNotification *note = [[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [Mynotification postNotification:note];
        
        //保存到数据库
        [[FmdbTool sharedfmdbTool] addMessage:model toUID:toUser.uid timeStamp:timeStamp isConversation:NO];

        
        completion(result,nil);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        completion(nil,error);
        
    }];

}


#pragma mark - private Helper

- (UserInfo *)getCurrentLoginInfo {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucuments = [array objectAtIndex:0];
    NSString *path = [doucuments stringByAppendingString:@"/user.archive"];
    UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return user;
}

@end
