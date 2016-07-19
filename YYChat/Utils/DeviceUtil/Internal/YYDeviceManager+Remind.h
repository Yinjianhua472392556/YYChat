//
//  YYDeviceManager+Remind.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YYDeviceManager (Remind)

// 播放接收到新消息时的声音
- (SystemSoundID)playNewMessageSound;


// 震动
- (void)playVibration;

@end
