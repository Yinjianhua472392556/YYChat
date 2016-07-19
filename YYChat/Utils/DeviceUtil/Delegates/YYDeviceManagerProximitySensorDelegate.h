//
//  YYDeviceManagerProximitySensorDelegate.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYDeviceManagerProximitySensorDelegate <NSObject>

/*!
 @method
 @brief 当手机靠近耳朵时或者离开耳朵时的回调方法
 @param isCloseToUser YES为靠近了用户, NO为远离了用户
 @discussion
 @result
 */
- (void)proximitySensorChanged:(BOOL)isCloseToUser;
@end
