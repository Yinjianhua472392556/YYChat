//
//  Common.h
//  微信
//
//  Created by Think_lion on 15-6-14.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//
/*
 self=[super initWithFrame:frame];
 if(self){
 
 }
 return self;
 */

#ifndef ___Common_h
#define ___Common_h



#define MyFont(s)  [UIFont systemFontOfSize:(s)]
#define WColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define WColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]
//屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UserDefaults [NSUserDefaults standardUserDefaults]
#define Mynotification [NSNotificationCenter defaultCenter]
//发送消息的通知名
#define SendMsgName @"sendMessage"
//删除好友时发出的通知名
#define DeleteFriend @"deleteFriend"
//发送表情的按钮
#define FaceSendButton @"faceSendButton"


//服务器的ip地址
//#define ServerAddress @"10.1.125.63" //内网

#define ServerAddress @"58.248.159.6" //外网

//服务器的端口号
#define ServerPort 5222
//服务器的域名
#define ServerName @"im-server"


/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"


#endif
