//
//  YYAudioPlayerUtil.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YYAudioPlayerUtilError) {
    YYAudioPlayerUtilErrorInitFailure = 2000,
    YYAudioPlayerUtilErrorAttachmentNotFound,
    YYAudioPlayerUtilErrorDecodeFailure,
};

@interface YYAudioPlayerUtil : NSObject
// 当前是否正在播放
+ (BOOL)isPlaying;

// 得到当前播放音频路径
+ (NSString *)playingFilePath;

// 播放指定路径下音频（wav）
+ (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void (^)(NSError *error))completion;

// 停止当前播放音频
+ (void)stopCurrentPlaying;

@end
