//
//  YYAudioRecorderUtil.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface YYAudioRecorderUtil : NSObject


// 当前是否正在录音
+ (BOOL)isRecording;

// 开始录音
+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void (^)(NSError *error))completion;

// 停止录音
+ (void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 取消录音
+ (void)cancelCurrentRecording;


// current recorder
+ (AVAudioRecorder *)recorder;

@end
