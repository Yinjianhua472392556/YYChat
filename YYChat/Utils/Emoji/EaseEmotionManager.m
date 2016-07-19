//
//  EaseEmotionManager.m
//  YYChat
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EaseEmotionManager.h"

@implementation EaseEmotionManager

- (id)initWithType:(EMEmotionType)Type emotionRow:(NSInteger)emotionRow emotionCol:(NSInteger)emotionCol emotions:(NSArray *)emotions {
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        NSMutableArray *tempEmotions = [NSMutableArray array];
        for (id name in emotions) {
            if ([name isKindOfClass:[NSString class]]) {
                EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
                [tempEmotions addObject:emotion];
            }
        }
        
        _emotions = tempEmotions;
        _tagImage = nil;
    }
    
    return self;
}


- (id)initWithType:(EMEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage
{
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        _emotions = emotions;
        _tagImage = tagImage;
    }
    return self;
}

@end



@implementation EaseEmotion

- (id)initWithName:(NSString *)emotionTitle emotionId:(NSString *)emotionId emotionThumbnail:(NSString *)emotionThumbnail emotionOriginal:(NSString *)emotionOriginal emotionOriginalURL:(NSString *)emotionOriginalURL emotionType:(EMEmotionType)emotionType {
    self = [super init];
    if (self) {
        _emotionTitle = emotionTitle;
        _emotionId = emotionId;
        _emotionThumbnail = emotionThumbnail;
        _emotionOriginal = emotionOriginal;
        _emotionOriginalURL = emotionOriginalURL;
        _emotionType = emotionType;
    }
    
    return self;
}

@end