//
//  YYDeviceManager.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYDeviceManagerDelegate.h"

@interface YYDeviceManager : NSObject {
    // recorder
    NSDate *_recorderStartDate;
    NSDate *_recorderEndDate;
    NSString *_currCategory;
    BOOL _currActive;
    
    // proximitySensor
    BOOL _isSupportProximitySensor;
    BOOL _isCloseToUser;
}

@property (nonatomic, weak) id<YYDeviceManagerDelegate> delegate;

+ (YYDeviceManager *)sharedInstance;

@end
