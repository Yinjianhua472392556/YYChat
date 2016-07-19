//
//  YYChatToolbarItem.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYChatToolbarItem : NSObject

/**
 *  按钮
 */
@property (strong, nonatomic, readonly) UIButton *button;


/**
 *  点击按钮之后在toolbar下方延伸出的页面
 */
@property (strong, nonatomic) UIView *button2View;


- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View;

@end
