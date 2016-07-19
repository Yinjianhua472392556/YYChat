//
//  YYAudioRecorderUtil.m
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYAudioRecorderUtil.h"

static YYAudioRecorderUtil *audioRecorderUtil = nil;


@interface YYAudioRecorderUtil()<AVAudioRecorderDelegate> {

    NSDate *_startDate;
    NSDate *_endDate;
    
    void (^recordFinish)(NSString *recordPath);
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSDictionary *recordSetting;

@end


@implementation YYAudioRecorderUtil

#pragma mark - Public

+ (BOOL)isRecording {
    return [[YYAudioRecorderUtil sharedInstance] isRecording];
}

+ (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath completion:(void (^)(NSError *))completion {
    [[YYAudioRecorderUtil sharedInstance] asyncStartRecordingWithPreparePath:aFilePath completion:completion];
}

+ (void)asyncStopRecordingWithCompletion:(void (^)(NSString *))completion {

    [[YYAudioRecorderUtil sharedInstance] asyncStopRecordingWithCompletion:completion];
}

+ (void)cancelCurrentRecording {

    [[YYAudioRecorderUtil sharedInstance] cancelCurrentRecording];
}

+ (AVAudioRecorder *)recorder {

    return [YYAudioRecorderUtil sharedInstance].recorder;
}

#pragma mark - getter

- (NSDictionary *)recordSetting {

    if (!_recordSetting) {
        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                          [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                          nil];
    }
    
    return _recordSetting;
}

#pragma mark - Private

+ (YYAudioRecorderUtil *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioRecorderUtil = [[self alloc] init];
    });
    
    return audioRecorderUtil;
}


- (void)dealloc {
    if (_recorder) {
        _recorder.delegate = nil;
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
    
    recordFinish = nil;
}

-(BOOL)isRecording{
    return !!_recorder;
}


// 开始录音，文件放到aFilePath下
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath completion:(void(^)(NSError *error))completion {

    NSError *error = nil;
    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
    NSURL *wavURL = [[NSURL alloc] initFileURLWithPath:wavFilePath];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:wavURL settings:self.recordSetting error:&error];
    if (!_recorder || error) {
        _recorder = nil;
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"Failed to initialize AVAudioRecorder")
                                        code:-1
                                    userInfo:nil];
            completion(error);
        }
        return;
    }
    
    _startDate = [NSDate date];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder record];
    if (completion) {
        completion(error);
    }
}


// 停止录音
-(void)asyncStopRecordingWithCompletion:(void(^)(NSString *recordPath))completion {

    recordFinish = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.recorder stop];
    });
}

// 取消录音
- (void)cancelCurrentRecording
{
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    recordFinish = nil;
}


#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {

    NSString *recordPath = [[_recorder url] path];
    if (recordFinish) {
        if (!flag) {
            recordPath = nil;
        }
        
        recordFinish(recordPath);
    }
    
    _recorder = nil;
    recordFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder
                                   error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}

@end
