//
//  XmppTools.m
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "XmppTools.h"
#import "UerOperation.h"

#import "YYMessageModel.h"
#import "FmdbTool.h"

@interface XmppTools()<XMPPStreamDelegate> {

    //定义这个block
    XMPPResultBlock _resultBlock;
    
    //自动连接对象
    XMPPReconnect *_reconnect;
    
//    //定义一个消息对象
//    XMPPMessageArchiving *_messageArching;
//    
//    //电子名片存贮
//    XMPPvCardCoreDataStorage *_vCardStorage;

}

@end

@implementation XmppTools
SingletonM(xmpp);

#pragma mark 初始化xmppstream

-(void)setupXmppStream {
    
    _xmppStream=[[XMPPStream alloc]init];
#warning 每一个模块添加都要激活
    //1.添加自动连接模块
    _reconnect=[[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    //    //2.添加电子名片模块
//    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
//    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
//    [_vCard activate:_xmppStream];  //激活
    
    //    //3.添加头像模块
//    _avatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
//    [_avatar activate:_xmppStream];
//    //    //4.添加花名册模块
//    _rosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
//    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
//    [_roster activate:_xmppStream];  //激活
//    //    //5.添加聊天模块    XMPPMessageArchivingCoreDataStorage
//    _messageStroage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
//    _messageArching=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_messageStroage];
//    [_messageArching activate:_xmppStream];
    
    
    //添加代理   把xmpp流放到子线程
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}



#pragma mark 连接到服务器

-(void)connectToHost {
    if(!_xmppStream){
        [self setupXmppStream];
    }
    //设置用户的jid
    UserOperation *user = [UserOperation shareduser];
    NSString *username = user.userName;
    XMPPJID *myJid = [XMPPJID jidWithUser:username domain:ServerName resource:nil];
    self.jid = myJid;  //参数赋值
    _xmppStream.myJID = myJid;
    
    //设置服务器域名或ip地址
    _xmppStream.hostName = ServerAddress;  //IP地址或域名都可以
    _xmppStream.hostPort = ServerPort;
    
    NSError *error=nil;
    //连接到服务器
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@",error);
    }
    
    
}


#pragma mark 连接成功调用这个方法

-(void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"连接主机成功");
    //向服务器端发送密码
    
    //判断是登录还是注册
    if(self.isRegisterOperation) {  //注册操作
        
        UserOperation *user = [UserOperation shareduser];
        NSString *password = user.password;//
        //调用注册方法  （这个方法会调用代理方法）
        [_xmppStream registerWithPassword:password error:nil];
    }else{  //登录操作
        [self sendPwdToHost];
    }
    
}


#pragma mark 连接失败的方法

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    if(error && _resultBlock){
        _resultBlock(XMPPResultNetworkErr);  //网路出现问题的时候
    }
    NSLog(@"连接断开");
}

#pragma mark 连接到服务器后 发送密码

-(void)sendPwdToHost {
    NSError *error=nil;
    UserOperation *user = [UserOperation shareduser];
    NSString *password = user.password;
    //验证密码
    [_xmppStream authenticateWithPassword:password error:&error];
    if(error){
        NSLog(@"授权失败%@",error);
    }
}



#pragma mark 验证成功 （就是密码正确）

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"验证成功");
    //发送在线消息
    [self sendOnlineMessage];
    if(_resultBlock){
        _resultBlock(XMPPResultSuccess);
    }
}

#pragma mark 验证失败 （就是密码错误）

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"验证失败");
    if(_resultBlock){
        _resultBlock(XMPPResultFaiture);
    }
}


#pragma mark 验证成功后 发送在线消息

-(void)sendOnlineMessage {
    XMPPPresence *presence=[XMPPPresence presence];
    NSLog(@"%@",presence);
    //把在线情况发送给服务器
    [_xmppStream sendElement:presence];
}


#pragma mark 退出登陆前发送离线消息

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:presence];
}

#pragma mark 登录的方法

-(void)login:(XMPPResultBlock)xmppBlock {
    //把block存起来
    
    _resultBlock = xmppBlock;
    //断开服务器重新连接
    [_xmppStream disconnect];
    //连接到主机
    [self connectToHost];
}

#pragma mark 退出登录的操作
-(void)xmppLoginOut {
    [self goOffline];
    [_xmppStream disconnect];
    
    UserOperation *user = [UserOperation shareduser];
//    user.userName = nil;  //不清零，以便退出登录后任然可以记录登录的用户名和用户密码。当重新登录后会自动变为新设置的账号
//    user.password = nil;
    user.loginStatus = NO; //退出登录状态
    
    
}


#pragma mark 调用注册的方法

-(void)regist:(XMPPResultBlock)xmppType {
    //把block保存起来
    _resultBlock=xmppType;
    
    //断开连接
    [_xmppStream disconnect];
    
    //连接主机
    [self connectToHost];
}

#pragma mark 注册成功

-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterSuccess);
    }
}

#pragma mark 注册失败

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    NSLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterFailture);
    }
}

#pragma mark 接收到消息的事件

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    
    NSDate *date = [self getDelayStampTime:message];
    
    //如果不是离线消息的话
    if(date == nil){
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    
    
    //获得body里面的内容
    NSString *body = [[message elementForName:@"body"] stringValue];
    
    //本地通知
//    UILocalNotification *local = [[UILocalNotification alloc]init];
//    local.alertBody = @"新消息";
//    local.alertAction = @"新消息";
//    local.soundName = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
//    local.timeZone = [NSTimeZone defaultTimeZone];
//    //开启通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
    //发送一个通知
//    if(body){
//        NSDictionary *dict=@{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid,@"user":@"other"};
//        NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
//        [Mynotification postNotification:note];
//    }
//
    YYMessageModel *model = [YYMessageModel yy_modelWithJSON:body];
    model.isSender = NO;
    
    //收到消息时根据userID将其存入数据库中的chatMessageTable表,当进入聊天页面时从数据库读取
    [[FmdbTool sharedfmdbTool] addMessage:model toUID:model.from.userID timeStamp:strDate isConversation:NO];
    
#pragma mark - 我的实验
    
    if(body){
        NSDictionary *dict = @{@"body" : body, @"time" : strDate, @"sender" : @"other"};
        NSNotification *note = [[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [Mynotification postNotification:note];
    }
    
    
}

#pragma mark 发送消息的函数



#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }else{
        return nil;
    }
    
}


- (void)teardownXmpp {
    //1.移除代理
    [_xmppStream removeDelegate:self];
    
    //2.停止模块
//    [_reconnect deactivate];
//    [_vCard deactivate];
//    [self.vCard deactivate];
//    [_avatar deactivate];
    [_reconnect deactivate];
//    [_roster deactivate];
    
    //3.断开连接
    [_xmppStream disconnect];
    
    //4 清空对象
    _reconnect=nil;
//    _vCard=nil;
//    _vCardStorage=nil;
//    _avatar=nil;
//    _rosterStorage=nil;
//    _roster=nil;
    _xmppStream=nil;

}

- (void)dealloc {

    [self teardownXmpp];
}

@end
