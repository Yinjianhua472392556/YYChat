//
//  NetworkingHelper.h
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "UserInfo.h"
//#import "UserOfMessage.h"
#import "ContactGroupList.h"

@interface NetworkingHelper : NSObject

+ (instancetype)shareHelper;

#pragma mark - login 


- (void)loginWithPath:(NSString *)path
               params:(NSDictionary *)params
           completion:(void (^)(id data, NSError *error))completion;


#pragma mark - 获取联系人列表

- (void)getContactsListWithPath:(NSString *)path
                         params:(NSDictionary *)params
                     completion:(void (^)(id data, NSError *error))completion;


#pragma mark - 下载语音

- (void)getVoiceWithPath:(NSString *)path completion:(void (^)(id data, NSError *error))completion;

#pragma mark - send message

/**
 *  @author 尹建华, 16-06-21 12:06:05
 *
 *  发送聊天消息接口    每发送一条消息，内容和fileType是一一对应,fileType==1时，须同时填写content参数,地理信息lat,lng,address不用提供，语音信息不用模拟voicetime不用提供，图片信息不用模拟,fileType==2时，模拟提交一张图片,文本信息content，地理信息三个参数lat,lng,address不用提供，typefile==3时，模拟提交一个语音文件,同时提供voicetime参数,typefile==4时，lat,lng,address三个参数必须提供,文本信息，语音信息，图片信息不用提供
 *
 *  @param path     路径
 *  @param params   对应fileType选择相应的参数
 *  @param chatType 100-单聊 300-群聊 400-公司通知500-会议，默认为100
 *  @param fileType 1-文字 2-图片 3-声音 4-位置
 */

- (void)sendMessageWithPath:(NSString *)path
                     toUser:(ContactGroupList *)toUser
                   sendData:(NSData *)data
                  voiceTime:(NSInteger)voiceTime
                    context:(NSString *)context
                   chatType:(int)chatType
                   fileType:(int)fileType
                 completion:(void (^)(id data, NSError *error))completion;
@end
