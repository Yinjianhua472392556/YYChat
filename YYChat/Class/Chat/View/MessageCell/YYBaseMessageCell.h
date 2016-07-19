//
//  YYBaseMessageCell.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYMessageCell.h"

@interface YYBaseMessageCell : YYMessageCell {

    UILabel *_nameLabel;
}


/*!
 @property
 @brief 头像尺寸
 */
@property (nonatomic) CGFloat avatarSize UI_APPEARANCE_SELECTOR; //default 30;

/*!
 @property
 @brief 头像圆角
 */
@property (nonatomic) CGFloat avatarCornerRadius UI_APPEARANCE_SELECTOR; //default 0;

/*!
 @property
 @brief 发送者昵称字体
 */
@property (nonatomic) UIFont *messageNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:10];

/*!
 @property
 @brief 发送者昵称颜色
 */
@property (nonatomic) UIColor *messageNameColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

/*!
 @property
 @brief 发送者昵称高度
 */
@property (nonatomic) CGFloat messageNameHeight UI_APPEARANCE_SELECTOR; //default 15;

/*!
 @property
 @brief 是否显示发送者昵称
 */
@property (nonatomic) BOOL messageNameIsHidden UI_APPEARANCE_SELECTOR; //default NO;

@end
