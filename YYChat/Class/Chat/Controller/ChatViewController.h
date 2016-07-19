//
//  ChatViewController.h
//  YYChat
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 apple. All rights reserved.
//


#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"


#import "YYMessageViewController.h"

@interface ChatViewController : YYMessageViewController<YYMessageViewControllerDataSource,YYMessageViewControllerDelegate>

@end
