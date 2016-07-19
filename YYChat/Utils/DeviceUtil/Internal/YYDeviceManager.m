//
//  YYDeviceManager.m
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager.h"
#import <UIKit/UIKit.h>

static YYDeviceManager *yy_DeviceManager;

@implementation YYDeviceManager

+ (YYDeviceManager *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yy_DeviceManager = [[self alloc] init];
    });
    
    return yy_DeviceManager;
}


- (instancetype)init {

    if (self = [super init]) {
        [self _setupProximitySensor];
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications {

    [self unregisterNotifications];
    if (_isSupportProximitySensor) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

- (void)unregisterNotifications {
    if (_isSupportProximitySensor) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

- (void)_setupProximitySensor {

    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled:YES];
    _isSupportProximitySensor = device.proximityMonitoringEnabled;
    if (_isSupportProximitySensor) {
        [device setProximityMonitoringEnabled:NO];
    }else {
    
    
    }
}

@end
