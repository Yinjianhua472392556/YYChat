//
//  YYVoiceConverter.h
//  DeviceUtil
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYVoiceConverter : NSObject

+ (int)isMP3File:(NSString *)filePath;

+ (int)isAMRFile:(NSString *)filePath;

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath;

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath;

@end
