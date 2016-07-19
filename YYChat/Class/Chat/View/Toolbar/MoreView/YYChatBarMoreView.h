//
//  YYChatBarMoreView.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YYChatToolbarType) {
    YYChatToolbarTypeChat ,
    YYChatToolbarTypeGroup,
};

@protocol YYChatBarMoreViewDelegate;

@interface YYChatBarMoreView : UIView

@property (nonatomic,weak) id<YYChatBarMoreViewDelegate> delegate;

@property (nonatomic) UIColor *moreViewBackgroundColor UI_APPEARANCE_SELECTOR;  //moreview背景颜色,default whiteColor

- (instancetype)initWithFrame:(CGRect)frame type:(YYChatToolbarType)type;


/*!
 @method
 @brief 新增一个新的功能按钮
 @discussion
 @param image 按钮图片
 @param highLightedImage 高亮图片
 @param title 按钮标题
 @result
 */
- (void)insertItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title;

/*!
 @method
 @brief 修改功能按钮图片
 @discussion
 @param image 按钮图片
 @param highLightedImage 高亮图片
 @param title 按钮标题
 @param index 按钮索引
 @result
 */
- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;


/*!
 @method
 @brief 根据索引删除功能按钮
 @discussion
 @param index 按钮索引
 @result
 */
- (void)removeItematIndex:(NSInteger)index;

@end


@protocol YYChatBarMoreViewDelegate <NSObject>

@optional

/*!
 @method
 @brief 默认功能
 @discussion
 @param moreView 功能view
 @result
 */
- (void)moreViewTakePicAction:(YYChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(YYChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(YYChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(YYChatBarMoreView *)moreView;
- (void)moreViewVideoCallAction:(YYChatBarMoreView *)moreView;

/*!
 @method
 @brief 发送消息后的回调
 @discussion
 @param moreView 功能view
 @param index    按钮索引
 @result
 */
- (void)moreView:(YYChatBarMoreView *)moreView didSelectItemInMoreViewAtIndex:(NSInteger)index;

@end