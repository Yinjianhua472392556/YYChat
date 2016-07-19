//
//  YYDeviceManager+ProximitySensor.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager.h"

@interface YYDeviceManager (ProximitySensor)

#pragma mark - proximity sensor
@property (nonatomic, readonly) BOOL isSupportProximitySensor;
@property (nonatomic, readonly) BOOL isCloseToUser;
@property (nonatomic, readonly) BOOL isProximitySensorEnabled;

- (BOOL)enableProximitySensor;
- (BOOL)disableProximitySensor;
- (void)sensorStateChanged:(NSNotification *)notification;
@end
