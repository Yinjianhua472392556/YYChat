//
//  YYConversationModel.h
//  YYChat
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYMessageModel.h"

@interface YYConversationModel : NSObject

//@property (nonatomic, copy) NSString *titleStr; //标题(即聊天对象)
@property (nonatomic, copy) NSString *timeStamp; //时间
@property (nonatomic, copy) NSString *badgeValue; //提醒数字
//@property (nonatomic, copy) NSString *avatarURLPath; //聊天对象的头像路径
//@property (nonatomic, assign) NSInteger type; //聊天内容类型 1.文字 2.图片 ...
@property (nonatomic, strong) YYMessageModel *messageModel;

@end
