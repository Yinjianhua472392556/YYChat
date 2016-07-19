//
//  YYFacialView.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EaseEmotionManager;
@class EaseEmotion;

@protocol YYFacialViewDelegate <NSObject>

@optional
- (void)selectedFacialView:(NSString *)str;
- (void)deleteSelected:(NSString *)str;
- (void)sendFace;
- (void)sendFace:(EaseEmotion *)emotion;

@end


@interface YYFacialView : UIView {
    NSMutableArray *_faces;
}

@property(nonatomic, weak) id<YYFacialViewDelegate> delegate;
@property(strong, nonatomic, readonly) NSArray *faces;

-(void)loadFacialView:(NSArray*)emotionManagers size:(CGSize)size;

-(void)loadFacialViewWithPage:(NSInteger)page;

@end
