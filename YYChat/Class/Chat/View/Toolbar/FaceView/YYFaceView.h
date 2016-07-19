//
//  YYFaceView.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYFacialView.h"

@protocol YYFaceViewDelegate <NSObject>

@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;
- (void)sendFaceWithEmotion:(EaseEmotion *)emotion;

@end

@interface YYFaceView : UIView<YYFacialViewDelegate>

@property (nonatomic, weak) id<YYFaceViewDelegate>delegate;

- (BOOL)stringIsFace:(NSString *)string;

/*!
 @method
 @brief 通过数据源获取表情分组数,
 @discussion
 @param number 分组数
 @param emotionManagers 表情分组列表
 @result
 */
- (void)setEmotionManagers:(NSArray*)emotionManagers;

@end
