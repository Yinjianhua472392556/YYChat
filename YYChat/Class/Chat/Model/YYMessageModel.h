//
//  YYMessageModel.h
//  YYChat
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  @author 尹建华, 16-06-20 16:06:38
 *
 *  消息模型，发送和接收解析之后可得到这个模型. 根据这个模型进行相应的Cell布局和显示
 *
 *  @param nonatomic
 *
 *  @return
 */

#import <Foundation/Foundation.h>
#import "IMessageModel.h"





@interface YYMessageModel : NSObject<NSCopying,NSCoding,YYModel>


#pragma mark - 自己定义的

//缓存数据模型对应的cell的高度，只需要计算一次并赋值，以后就无需计算了
@property (nonatomic) CGFloat cellHeight;

/**
 *  @author 尹建华, 16-06-20 16:06:17
 *
 *  发送者详细信息
 */
@property (nonatomic, strong) UserOfMessage *from;

/**
 *  @author 尹建华, 16-06-20 16:06:27
 *
 *  接收者详细信息
 */
@property (nonatomic, strong) UserOfMessage *to;

/**
 *  @author 尹建华, 16-06-20 16:06:52
 *
 *  图片
 */
@property (nonatomic, strong) ImageOfMessage *image;

/**
 *  @author 尹建华, 16-06-20 16:06:48
 *
 *  语音片段
 */
@property (nonatomic, strong) VoiceOfMessage *voice;

/**
 *  @author 尹建华, 16-06-20 16:06:03
 *
 *  地理位置
 */
@property (nonatomic, strong) LocationOfMesage *location;

/**
 *  @author 尹建华, 16-06-20 16:06:27
 *
 *  消息的文字内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  @author 尹建华, 16-06-20 16:06:56
 *
 *  100-单聊 300-群聊 400-公司通知500-会议，默认为100
 */
@property (nonatomic, assign) YYChatType typechat;

/**
 *  @author 尹建华, 16-06-20 16:06:24
 *
 *  1-文字 2-图片 3-声音 4-位置
 */
@property (nonatomic, assign) YYMessageBodyType typefile;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *time;


/**
 *  @author 尹建华, 16-06-20 16:06:30
 *
 *  是否是当前登录者发送的消息
 */
@property (nonatomic) BOOL isSender;

/**
 *  @author 尹建华, 16-06-30 19:06:43
 *
 *  对话列表中显示的时间
 */
@property (nonatomic, copy) NSString *timeStamp;

/**
 *  @author 尹建华, 16-06-30 19:06:58
 *
 *  对话列表中显示的消息数
 */

@property (nonatomic, copy) NSString *badgeValue;
//获取图片失败后显示的图片
@property (strong, nonatomic) NSString *failImageName;


#pragma mark - 环信相关的

/**
SDK中的消息
@property (strong, nonatomic, readonly) YYMessage *message;

//消息类型
@property (nonatomic, readonly) YYMessageBodyType bodyType;
//消息发送状态
@property (nonatomic, readonly) YYMessageStatus messageStatus;
// 消息类型（单聊，群里，聊天室）
@property (nonatomic, readonly) YYChatType messageType;

//是否是当前登录者发送的消息
@property (nonatomic) BOOL isSender;
//消息显示的昵称
@property (strong, nonatomic) NSString *nickname;
//消息显示的头像的网络地址
@property (strong, nonatomic) NSString *avatarURLPath;
//消息显示的头像
@property (strong, nonatomic) UIImage *avatarImage;

//文本消息：文本
@property (strong, nonatomic) NSString *text;

//文本消息：文本
@property (strong, nonatomic) NSAttributedString *attrBody;


//地址消息：地址描述
@property (strong, nonatomic) NSString *address;
//地址消息：地址经度
@property (nonatomic) double latitude;
//地址消息：地址纬度
@property (nonatomic) double longitude;


//获取图片失败后显示的图片
@property (strong, nonatomic) NSString *failImageName;
//图片消息：图片原图的宽高
@property (nonatomic) CGSize imageSize;
//图片消息：图片缩略图的宽高
@property (nonatomic) CGSize thumbnailImageSize;
//图片消息：图片原图
@property (strong, nonatomic) UIImage *image;
//图片消息：图片缩略图
@property (strong, nonatomic) UIImage *thumbnailImage;


//多媒体消息：是否正在播放
@property (nonatomic) BOOL isMediaPlaying;
//多媒体消息：是否播放过
@property (nonatomic) BOOL isMediaPlayed;
//多媒体消息：长度
@property (nonatomic) CGFloat mediaDuration;

- (instancetype)initWithMessage:(YYMessage *)message;
*/
@end
