//
//  YYMessageCell.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//遵循的协议
#import "IModelChatCell.h"
#import "IMessageModel.h"
//遵循的协议

#import "YYBubbleView.h"


#define kEMMessageImageSizeWidth 120
#define kEMMessageImageSizeHeight 120
#define kEMMessageLocationHeight 95
#define kEMMessageVoiceHeight 23


extern CGFloat const EaseMessageCellPadding;

typedef NS_ENUM(NSUInteger, YYMessageCellTapEventType) {
    YYMessageCellEvenVideoBubbleTap,
    YYMessageCellEventLocationBubbleTap,
    YYMessageCellEventImageBubbleTap,
    YYMessageCellEventAudioBubbleTap,
    YYMessageCellEventFileBubbleTap,
    YYMessageCellEventCustomBubbleTap,
};

@protocol YYMessageCellDelegate;

@interface YYMessageCell : UITableViewCell {

    UIButton *_statusButton;
    UILabel *_hasRead;
    YYBubbleView *_bubbleView;
    UIActivityIndicatorView *_activity;
    
    NSLayoutConstraint *_statusWidthConstraint;
}

@property (nonatomic, weak) id<YYMessageCellDelegate> delegate;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *statusButton;

@property (nonatomic, strong) UILabel *hasRead;

@property (nonatomic, strong) YYBubbleView *bubbleView;

@property (nonatomic, strong) id<IMessageModel> model;


/*!
 @property
 @brief 状态尺寸
 */
@property (nonatomic) CGFloat statusSize UI_APPEARANCE_SELECTOR; //default 20;

/*!
 @property
 @brief 状态尺寸
 */
@property (nonatomic) CGFloat activitySize UI_APPEARANCE_SELECTOR; //default 20;

/*!
 @property
 @brief 气泡最大宽度
 */
@property (nonatomic) CGFloat bubbleMaxWidth UI_APPEARANCE_SELECTOR; //default 200;


/*!
 @property
 @brief 气泡偏移
 */
@property (nonatomic) UIEdgeInsets bubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 0, 8, 0);

/*!
 @property
 @brief 接收消息气泡偏移
 */
@property (nonatomic) UIEdgeInsets leftBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 15, 8, 10);

/*!
 @property
 @brief 发送消息气泡偏移
 */
@property (nonatomic) UIEdgeInsets rightBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 10, 8, 15);

/*!
 @property
 @brief 接收消息气泡图片
 */
@property (strong, nonatomic) UIImage *sendBubbleBackgroundImage UI_APPEARANCE_SELECTOR;


/*!
 @property
 @brief 发送消息气泡图片
 */
@property (strong, nonatomic) UIImage *recvBubbleBackgroundImage UI_APPEARANCE_SELECTOR;


/*!
 @property
 @brief 消息字体
 */
@property (nonatomic) UIFont *messageTextFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:15];

/*!
 @property
 @brief 消息字体颜色
 */
@property (nonatomic) UIColor *messageTextColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];


/*!
 @property
 @brief 位置消息字体
 */
@property (nonatomic) UIFont *messageLocationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];

/*!
 @property
 @brief 位置消息字体颜色
 */
@property (nonatomic) UIColor *messageLocationColor UI_APPEARANCE_SELECTOR; //default [UIColor whiteColor];

/*!
 @property
 @brief 发送语音消息播放图片数组
 */
@property (nonatomic) NSArray *sendMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;


/*!
 @property
 @brief 接收语音消息播放图片数组
 */
@property (nonatomic) NSArray *recvMessageVoiceAnimationImages UI_APPEARANCE_SELECTOR;

/*!
 @property
 @brief 语音消息字体颜色
 */
@property (nonatomic) UIColor *messageVoiceDurationColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];


/*!
 @property
 @brief 语音消息字体
 */
@property (nonatomic) UIFont *messageVoiceDurationFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12];


/*!
 @property
 @brief 文件消息字体
 */
@property (nonatomic) UIFont *messageFileNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:13];


/*!
 @property
 @brief 文件消息字体颜色
 */
@property (nonatomic) UIColor *messageFileNameColor UI_APPEARANCE_SELECTOR; //default [UIColor blackColor];


/*!
 @property
 @brief 文件消息字体
 */
@property (nonatomic) UIFont *messageFileSizeFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:11];

/*!
 @property
 @brief 文件消息字体颜色
 */
@property (nonatomic) UIColor *messageFileSizeColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end


@protocol YYMessageCellDelegate <NSObject>

@optional

- (void)messageCellSelected:(id<IMessageModel>)model;

- (void)statusButtonSelected:(id<IMessageModel>)model withMessageCell:(YYMessageCell *)messageCell;

- (void)avatarViewSelected:(id<IMessageModel>)model;

@end