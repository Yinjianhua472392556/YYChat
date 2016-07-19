//
//  YYDeviceManager+Media.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager.h"

#define YYErrorAudioRecordDurationTooShort -100
#define YYErrorFileTypeConvertionFailure -101
#define YYErrorAudioRecordStoping -102
#define YYErrorAudioRecordNotStarted -103

@interface YYDeviceManager (Media)

#pragma mark - AudioPlayer
// 播放音频
- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completion;

// 停止播放
- (void)stopPlaying;

- (void)stopPlayingWithChangeCategory:(BOOL)isChange;
// 当前是否正在播放
- (BOOL)isPlaying;

#pragma mark - AudioRecorder

// 开始录音
- (void)asyncStartRecordingWithFileName:(NSString *)fileName
                             completion:(void(^)(NSError *error))completion;
// 停止录音
- (void)asyncStopRecordingWithCompletion:(void (^)(NSString *recordPath, NSInteger aDuration, NSError *error))completion;

// 取消录音
- (void)cancelCurrentRecording;

// 当前是否正在录音
- (BOOL)isRecording;

// 返回存储数据的路径
+ (NSString *)dataPath;
@end
