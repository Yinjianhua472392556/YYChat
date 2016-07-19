//
//  IModelChatCell.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IModelCell.h"

@protocol IModelChatCell <NSObject,IModelCell>

@required
@property (nonatomic, strong) id model;

@optional

/*!
 @method
 @brief 判断是否为自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (BOOL)isCustomBubbleView:(id)model;


/*!
 @method
 @brief 设置自定义Cell气泡
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomBubbleView:(id)model;


/*!
 @method
 @brief 设置自定义Cell
 @discussion
 @param model 消息
 @result
 */
- (void)setCustomModel:(id)model;


/*!
 @method
 @brief 修改自定义气泡位置
 @discussion
 @param bubbleMargin
 @param model 消息
 @result
 */
- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;


@end
