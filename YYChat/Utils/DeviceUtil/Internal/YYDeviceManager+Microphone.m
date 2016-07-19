//
//  YYDeviceManager+Microphone.m
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager+Microphone.h"
#import "YYAudioRecorderUtil.h"

@implementation YYDeviceManager (Microphone)

// 判断麦克风是否可用
- (BOOL)yy_CheckMicrophoneAvailability {

    __block BOOL ret = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session requestRecordPermission:^(BOOL granted) {
            ret = granted;
        }];
    }else {
    
        ret = YES;
    }
    
    return ret;
}

// 获取录制音频时的音量(0~1)
- (double)yy_PeekRecorderVioceMeter {
    double ret = 0.0;
    if ([YYAudioRecorderUtil recorder].isRecording) {
        [[YYAudioRecorderUtil recorder] updateMeters];
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        double lowPassResults = pow(10, (0.05 * [[YYAudioRecorderUtil recorder] peakPowerForChannel:0]));
        ret = lowPassResults;

    }
    
    return ret;
}

@end
