//
//  YYDeviceManager+Media.m
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYDeviceManager+Media.h"
#import "YYAudioRecorderUtil.h"
#import "YYAudioPlayerUtil.h"
#import "YYVoiceConverter.h"

typedef NS_ENUM(NSUInteger, YYAudioSession) {
    YYAudioSessionDefault = 0,
    YYAudioSessionAudioPlayer,
    YYAudioSessionAudioRecorder,
};

@implementation YYDeviceManager (Media)

#pragma mark - AudioPlayer

+ (NSString *)dataPath {
    
    NSString *dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dataPath]){
        [fm createDirectoryAtPath:dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    return dataPath;
}

// 播放音频
- (void)asyncPlayingWithPath:(NSString *)aFilePath completion:(void (^)(NSError *))completion {

    BOOL isNeedSetActive = YES;
    
    // 如果正在播放音频，停止当前播放。
    if ([YYAudioPlayerUtil isPlaying]) {
        [YYAudioPlayerUtil stopCurrentPlaying];
        isNeedSetActive = NO;
    }
    
    if (isNeedSetActive) {
        // 设置播放时需要的category
        [self setupAudioSessionCategory:YYAudioSessionAudioPlayer isActive:YES];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
    //如果转换后的wav文件不存在, 则去转换一下
    if (![fileManager fileExistsAtPath:wavFilePath]) {
        BOOL convertRet = [self convertAMR:aFilePath toWAV:wavFilePath];
        if (!convertRet) {
            if (completion) {
                completion([NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"File format conversion failed")
                                               code:YYErrorFileTypeConvertionFailure
                                           userInfo:nil]);
            }
            return;
        }
    }
    
    [YYAudioPlayerUtil asyncPlayingWithPath:wavFilePath completion:^(NSError *error) {
        [self setupAudioSessionCategory:YYAudioSessionDefault isActive:NO];
        if (completion) {
            completion(error);
        }
    }];
}


// 停止播放
- (void)stopPlaying {

    [YYAudioPlayerUtil stopCurrentPlaying];
    [self setupAudioSessionCategory:YYAudioSessionDefault isActive:NO];
}

- (void)stopPlayingWithChangeCategory:(BOOL)isChange{
    [YYAudioPlayerUtil stopCurrentPlaying];
    if (isChange) {
        [self setupAudioSessionCategory:YYAudioSessionDefault
                               isActive:NO];
    }
}

// 获取播放状态
- (BOOL)isPlaying {

    return [YYAudioPlayerUtil isPlaying];
}

#pragma mark - Recorder

+ (NSTimeInterval)recordMinDuration {
    return 1.0;
}

// 开始录音
- (void)asyncStartRecordingWithFileName:(NSString *)fileName completion:(void (^)(NSError *))completion {
    NSError *error = nil;
    
    // 判断当前是否是录音状态
    if ([self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.recordStoping", @"Record voice is not over yet")
                                        code:YYErrorAudioRecordStoping
                                    userInfo:nil];
            completion(error);
        }
        return;
    }
    
    // 文件名不存在
    if (!fileName || [fileName length] == 0) {
        error = [NSError errorWithDomain:NSLocalizedString(@"error.notFound", @"File path not exist")
                                    code:-1
                                userInfo:nil];
        completion(error);
        return;
    }
    
    BOOL isNeedSetActive = YES;
    if ([self isRecording]) {
        [YYAudioRecorderUtil cancelCurrentRecording];
        isNeedSetActive = NO;
    }
    
    [self setupAudioSessionCategory:YYAudioSessionAudioRecorder isActive:YES];
    
    _recorderStartDate = [NSDate date];
    NSString *recordPath = NSHomeDirectory();
    recordPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer/%@",recordPath,fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]) {
        [fileManager createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [YYAudioRecorderUtil asyncStartRecordingWithPreparePath:recordPath completion:completion];

}


// 停止录音
- (void)asyncStopRecordingWithCompletion:(void (^)(NSString *recordPath, NSInteger aDuration, NSError *error))completion {
    NSError *error = nil;
    // 当前是否在录音
    if (![self isRecording]) {
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.recordNotBegin", @"Recording has not yet begun")
                                        code:YYErrorAudioRecordNotStarted
                                    userInfo:nil];
            completion(nil,0,error);
            return;
        }
    }
    
    
    __weak typeof(self) weakSelf = self;
    _recorderEndDate = [NSDate date];
    if ([_recorderEndDate timeIntervalSinceDate:_recorderStartDate] < [YYDeviceManager recordMinDuration]) {
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.recordTooShort", @"Recording time is too short")
                                        code:YYErrorAudioRecordDurationTooShort
                                    userInfo:nil];
            completion(nil,0,error);
        }
        
        // 如果录音时间较短，延迟1秒停止录音（iOS中，如果快速开始，停止录音，UI上会出现红条,为了防止用户又迅速按下，UI上需要也加一个延迟，长度大于此处的延迟时间，不允许用户循序重新录音。PS:研究了QQ和微信，就这么玩的,聪明）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([YYDeviceManager recordMinDuration] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [YYAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
                [weakSelf setupAudioSessionCategory:YYAudioSessionDefault isActive:NO];
            }];
            
        });
        return;
    }
    
    [YYAudioRecorderUtil asyncStopRecordingWithCompletion:^(NSString *recordPath) {
        if (completion) {
            //录音格式转换，从wav转为amr
            NSString *amrFilePath = [[recordPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
            BOOL convertResult = [self convertWAV:recordPath toAMR:amrFilePath];
            if (convertResult) {
                // 删除录的wav
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:recordPath error:nil];
            }
            
            completion(amrFilePath,(int)[_recorderEndDate timeIntervalSinceDate:_recorderStartDate],nil);

            [weakSelf setupAudioSessionCategory:YYAudioSessionDefault isActive:NO];
        }
    }];
    
}

// 取消录音
- (void)cancelCurrentRecording {

    [YYAudioRecorderUtil cancelCurrentRecording];
}

// 获取录音状态
- (BOOL)isRecording {

    return [YYAudioRecorderUtil isRecording];
}

#pragma mark - Private

- (NSError *)setupAudioSessionCategory:(YYAudioSession)session isActive:(BOOL)isActive {
    BOOL isNeedActive = NO;
    if (isActive != _currActive) {
        isNeedActive = YES;
        _currActive = isActive;
    }
    
    NSError *error = nil;
    NSString *audioSessionCategory = nil;
    switch (session) {
        case YYAudioSessionDefault: {
            // 还原category
            audioSessionCategory = AVAudioSessionCategoryAmbient;
            break;
        }
        case YYAudioSessionAudioPlayer: {
            // 设置播放category
            audioSessionCategory = AVAudioSessionCategoryPlayback;
            break;
        }
        case YYAudioSessionAudioRecorder: {
            // 设置录音category
            audioSessionCategory = AVAudioSessionCategoryRecord;

            break;
        }
    }
    
    
    AVAudioSession *audioSessin = [AVAudioSession sharedInstance];
    // 如果当前category等于要设置的，不需要再设置
    if (![_currCategory isEqualToString:audioSessionCategory]) {
        [audioSessin setCategory:audioSessionCategory error:nil];
    }
    
    if (isNeedActive) {
        BOOL success = [audioSessin setActive:isActive withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (!success || error) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer")
                                        code:-1
                                    userInfo:nil];
            return error;
        }
    }
    
    _currCategory = audioSessionCategory;
    
    return error;
    
}


#pragma mark - Convert

- (BOOL)convertAMR:(NSString *)amrFilePath toWAV:(NSString *)wavFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
    if (isFileExists) {
        [YYVoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}


- (BOOL)convertWAV:(NSString *)wavFilePath
             toAMR:(NSString *)amrFilePath {
    BOOL ret = NO;
    BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:wavFilePath];
    if (isFileExists) {
        [YYVoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath];
        isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:amrFilePath];
        if (isFileExists) {
            ret = YES;
        }
    }
    
    return ret;
}



@end
