//
//  CacheFileHelper.m
//  YYChat
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CacheFileHelper.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CacheFileHelper

#pragma mark --  保存音频文件的相关方法

#pragma mark -- public


- (NSString*)saveVoiceDataWithFilename:(NSString *)filename Data:(NSData *)voiceData{
    
    NSString *directoryCachePath = [self downloadCachePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:directoryCachePath]){
        [fm createDirectoryAtPath:directoryCachePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    NSString *voicePath = [self voiceCachePathForFilename:filename];
    [fm createFileAtPath:voicePath contents:voiceData attributes:nil];
    
    return voicePath;
}


- (NSString *)achievePathWithLoginUid:(NSString *)loginUid chatUid:(NSString *)chatUid {

    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = [array objectAtIndex:0];
    NSString *path = [caches stringByAppendingString:[NSString stringWithFormat:@"/%@%@.archive",loginUid,chatUid]];
    return path;
}


#pragma mark -- private

- (NSString *)downloadCachePath { //保存声音文件的目录
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:@"YYChat"];
}


- (NSString *)voiceCachePathForFilename:(NSString *)filename {
    
    return [self cachePathForFilename:filename inPath:[self downloadCachePath]]; //根据文件名和文件目录生成声音文件的路径
}

- (NSString *)cachePathForFilename:(NSString *)key inPath:(NSString *)path {
    
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)cachedFileNameForKey:(NSString *)key { //对文件名进行MD5散列，生成固定长度的文件名
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}


@end
