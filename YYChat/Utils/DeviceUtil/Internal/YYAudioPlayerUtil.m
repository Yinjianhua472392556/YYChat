//
//  YYAudioPlayerUtil.m
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYAudioPlayerUtil.h"
#import <AVFoundation/AVFoundation.h>

static YYAudioPlayerUtil *audioPlayerUtil = nil;

@interface YYAudioPlayerUtil()<AVAudioPlayerDelegate> {
    AVAudioPlayer *_player;
    void (^playFinish)(NSError *error);
}

@end

@implementation YYAudioPlayerUtil


#pragma mark - public

+ (BOOL)isPlaying {

    return [[YYAudioPlayerUtil sharedInstance] isPlaying];
}

+ (NSString *)playingFilePath {

    return [[YYAudioPlayerUtil sharedInstance] playingFilePath];
}


+ (void)asyncPlayingWithPath:(NSString *)aFilePath completion:(void (^)(NSError *))completion {

    [[YYAudioPlayerUtil sharedInstance] asyncPlayingWithPath:aFilePath completion:completion];
}

+ (void)stopCurrentPlaying {

    [[YYAudioPlayerUtil sharedInstance] stopCurrentPlaying];
}

#pragma mark - private


+ (YYAudioPlayerUtil *)sharedInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayerUtil = [[self alloc] init];
    });
    
    return audioPlayerUtil;
}


// 当前是否正在播放

- (BOOL)isPlaying {

    return !!_player;
}

// 得到当前播放音频路径
- (NSString *)playingFilePath {

    NSString *path = nil;
    if (_player && _player.isPlaying) {
        path = _player.url.path;
    }
    
    return path;
}

- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completion {
    playFinish = completion;
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:aFilePath]) {
        error = [NSError errorWithDomain:NSLocalizedString(@"error.notFound", @"File path not exist") code:YYAudioPlayerUtilErrorAttachmentNotFound userInfo:nil];
        if (playFinish) {
            playFinish(error);
        }
        
        playFinish = nil;
        
        return;
    }
    
    
    NSURL *wavURL = [[NSURL alloc] initFileURLWithPath:aFilePath];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:wavURL error:&error];
    if (error || !_player) {
        _player = nil;
        error = [NSError errorWithDomain:NSLocalizedString(@"error.initPlayerFail", @"Failed to initialize AVAudioPlayer") code:YYAudioPlayerUtilErrorInitFailure userInfo:nil];
        
        if (playFinish) {
            playFinish(error);
        }
        
        playFinish = nil;
        return;
    }
    
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
    
}

// 停止当前播放

- (void)stopCurrentPlaying {

    if (_player) {
        _player.delegate = nil;
        [_player stop];
        _player = nil;
    }
    
    if (playFinish) {
        playFinish = nil;
    }
}


- (void)dealloc {

    if (_player) {
        _player.delegate = nil;
        [_player stop];
        _player = nil;
    }
    
    playFinish = nil;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    if (playFinish) {
        playFinish(nil);
    }
    
    
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
    
    playFinish = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {

    if (playFinish) {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"error.palyFail", @"Play failure") code:YYAudioPlayerUtilErrorDecodeFailure userInfo:nil];
        playFinish(error);
    }
    
    if (_player) {
        _player.delegate = nil;
        _player = nil;
    }
}

@end
