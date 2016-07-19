//
//  CacheFileHelper.h
//  YYChat
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFileHelper : NSObject
/**
 *  @author 尹建华, 16-06-22 15:06:53
 *
 *  根据文件名将二进制数据保存在文件中
 *
 *  @param filename  文件名
 *  @param voiceData 二进制数据
 *
 *  @return 保存的全文件路径
 */
- (NSString *)saveVoiceDataWithFilename:(NSString *)filename Data:(NSData *)voiceData;

- (NSString *)achievePathWithLoginUid:(NSString *)loginUid chatUid:(NSString *)chatUid;

@end
