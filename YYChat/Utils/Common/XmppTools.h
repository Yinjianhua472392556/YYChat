//
//  XmppTools.h
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSUInteger, XMPPResultType) {
    XMPPResultSuccess,   //登陆成功
    XMPPResultFaiture,     //登陆失败
    XMPPResultNetworkErr,  //网络出错
    XMPPResultRegisterSuccess,  //注册成功
    XMPPResultRegisterFailture,  //注册失败
};

typedef  void (^XMPPResultBlock)(XMPPResultType xmppType);

@interface XmppTools : NSObject
SingletonH(xmpp);

@property (nonatomic, strong) XMPPStream *xmppStream;

@property (nonatomic, strong) XMPPJID *jid;

@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;  //如果是YES就是注册的方法

//添加花名册模块
//@property (nonatomic,strong,readonly) XMPPRoster *roster;
//@property (nonatomic,strong,readonly) XMPPRosterCoreDataStorage *rosterStorage;


//聊天模块
//@property (nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *messageStroage;


//电子名片
//@property (nonatomic,strong,readonly) XMPPvCardTempModule *vCard;


//头像模块
//@property (nonatomic,strong,readonly) XMPPvCardAvatarModule  *avatar;

//登陆的方法
- (void)login:(XMPPResultBlock)xmppBlock;

//退出登录的操作
- (void)xmppLoginOut;

//注册的方法
-(void)regist:(XMPPResultBlock)xmppType;

@end
