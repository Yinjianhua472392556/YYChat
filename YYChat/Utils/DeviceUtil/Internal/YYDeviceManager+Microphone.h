//
//  YYDeviceManager+Microphone.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager.h"

@interface YYDeviceManager (Microphone)

// 判断麦克风是否可用
- (BOOL)yy_CheckMicrophoneAvailability;

// 获取录制音频时的音量(0~1)
- (double)yy_PeekRecorderVioceMeter;
@end
