//
//  YYConversationImageView.h
//  YYChat
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYConversationImageView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) NSInteger badge;

@property (nonatomic, assign) BOOL showBadge;

@property (nonatomic, assign) CGFloat imageCornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat badgeSize UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *badgeFont UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *badgeTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *badgeBackgroudColor UI_APPEARANCE_SELECTOR;

@end
