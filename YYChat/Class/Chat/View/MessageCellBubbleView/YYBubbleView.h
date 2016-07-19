//
//  YYBubbleView.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const EaseMessageCellPadding;

extern NSString *const EaseMessageCellIdentifierSendText;
extern NSString *const EaseMessageCellIdentifierSendLocation;
extern NSString *const EaseMessageCellIdentifierSendVoice;
extern NSString *const EaseMessageCellIdentifierSendVideo;
extern NSString *const EaseMessageCellIdentifierSendImage;
extern NSString *const EaseMessageCellIdentifierSendFile;

extern NSString *const EaseMessageCellIdentifierRecvText;
extern NSString *const EaseMessageCellIdentifierRecvLocation;
extern NSString *const EaseMessageCellIdentifierRecvVoice;
extern NSString *const EaseMessageCellIdentifierRecvVideo;
extern NSString *const EaseMessageCellIdentifierRecvImage;
extern NSString *const EaseMessageCellIdentifierRecvFile;

@interface YYBubbleView : UIView {

    UIEdgeInsets _margin;
    CGFloat _fileIconSize;
}

@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, assign, readonly) UIEdgeInsets margin;
@property (nonatomic, strong) NSMutableArray *marginConstraints;
@property (nonatomic, strong) UIImageView *backgroundImageView;

//text views
@property (nonatomic, strong) UILabel *textLabel;


//image views
@property (nonatomic, strong) UIImageView *imageView;


//location views
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *locationLabel;


//voice views
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UILabel *voiceDurationLabel;
@property (nonatomic, strong) UIImageView *isReadView;


//video views
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *videoTagView;



//file views
@property (nonatomic, strong) UIImageView *fileIconView;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;


- (instancetype)initWithMargin:(UIEdgeInsets)margin isSender:(BOOL)isSender;

@end
