//
//  YYBubbleView+Video.m
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYBubbleView+Video.h"

@implementation YYBubbleView (Video)

#pragma mark - private

- (void)_setupVideoBubbleMarginConstraints {

    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];

    [self.marginConstraints removeAllObjects];
    [self.marginConstraints addObject:marginTopConstraint];
    [self.marginConstraints addObject:marginBottomConstraint];
    [self.marginConstraints addObject:marginLeftConstraint];
    [self.marginConstraints addObject:marginRightConstraint];

    [self addConstraints:self.marginConstraints];
}

- (void)_setupVideoBubbleConstraints {
    
    [self _setupVideoBubbleMarginConstraints];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.videoTagView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.videoImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.videoTagView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.videoImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.videoTagView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.videoImageView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.videoTagView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.videoTagView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

}

#pragma mark - public

- (void)setupVideoBubbleView {

    self.videoImageView = [[UIImageView alloc] init];
    self.videoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoImageView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.videoImageView];
    
    
    self.videoTagView = [[UIImageView alloc] init];
    self.videoTagView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoTagView.backgroundColor = [UIColor clearColor];
    [self.videoImageView addSubview:self.videoTagView];
    
    [self _setupVideoBubbleConstraints];
}

- (void)updateVideoMargin:(UIEdgeInsets)margin {

    if (UIEdgeInsetsEqualToEdgeInsets(_margin, margin)) {
        return;
    }
    
    [self removeConstraints:self.marginConstraints];
    [self _setupVideoBubbleMarginConstraints];
}

@end
