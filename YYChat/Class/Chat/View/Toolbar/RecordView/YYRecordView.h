//
//  YYRecordView.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYRecordViewType) {
    YYRecordViewTypeTouchDown,
    YYRecordViewTypeTouchUpInside,
    YYRecordViewTypeTouchUpOutside,
    YYRecordViewTypeDragInside,
    YYRecordViewTypeDragOutside,
};

@interface YYRecordView : UIView

@property (nonatomic) NSArray *voiceMessageAnimationImages UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSString *upCancelText UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSString *loosenCancelText UI_APPEARANCE_SELECTOR;

// 录音按钮按下
-(void)recordButtonTouchDown;
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside;
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside;
// 手指移动到录音按钮内部
-(void)recordButtonDragInside;
// 手指移动到录音按钮外部
-(void)recordButtonDragOutside;

@end
