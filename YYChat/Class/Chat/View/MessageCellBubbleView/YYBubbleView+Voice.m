//
//  YYBubbleView+Voice.m
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYBubbleView+Voice.h"

#define ISREAD_VIEW_SIZE 10.f


@implementation YYBubbleView (Voice)

#pragma mark - private

- (void)_setupVoiceBubbleMarginConstraints {
    

    [self.marginConstraints removeAllObjects];
    
    //image view
    NSLayoutConstraint *imageWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *imageWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:imageWithMarginTopConstraint];
    [self.marginConstraints addObject:imageWithMarginBottomConstraint];
    
    //duration label
    NSLayoutConstraint *durationWithMarginTopConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *durationWithMarginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
    [self.marginConstraints addObject:durationWithMarginTopConstraint];
    [self.marginConstraints addObject:durationWithMarginBottomConstraint];
    
    if(self.isSender){
        NSLayoutConstraint *imageWithMarginRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
        [self.marginConstraints addObject:imageWithMarginRightConstraint];
        
        NSLayoutConstraint *durationRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.voiceImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding];
        [self.marginConstraints addObject:durationRightConstraint];
        
        NSLayoutConstraint *durationLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
        [self.marginConstraints addObject:durationLeftConstraint];
    }
    else{
        NSLayoutConstraint *imageWithMarginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
        [self.marginConstraints addObject:imageWithMarginLeftConstraint];
        
        NSLayoutConstraint *durationLeftConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voiceImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding];
        [self.marginConstraints addObject:durationLeftConstraint];
        
        NSLayoutConstraint *durationRightConstraint = [NSLayoutConstraint constraintWithItem:self.voiceDurationLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
        [self.marginConstraints addObject:durationRightConstraint];
        
        [self.marginConstraints addObject:[NSLayoutConstraint constraintWithItem:self.isReadView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:ISREAD_VIEW_SIZE/2]];
        [self.marginConstraints addObject:[NSLayoutConstraint constraintWithItem:self.isReadView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-ISREAD_VIEW_SIZE/2]];
        [self.marginConstraints addObject:[NSLayoutConstraint constraintWithItem:self.isReadView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.marginConstraints addObject:[NSLayoutConstraint constraintWithItem:self.isReadView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:ISREAD_VIEW_SIZE]];
    }
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupVoiceBubbleConstraints {

//    if (self.isSender) {
//        self.isReadView.hidden = YES;
//    }
    self.isReadView.hidden = YES;  //不管是发送者还是接受者暂时先隐藏已读UI图片
    
    [self _setupVoiceBubbleMarginConstraints];
}

#pragma mark - public

- (void)setupVoiceBubbleView {
    
    self.voiceImageView = [[UIImageView alloc] init];
    self.voiceImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceImageView.backgroundColor = [UIColor clearColor];
    self.voiceImageView.animationDuration = 1;
    [self.backgroundImageView addSubview:self.voiceImageView];
    
    self.voiceDurationLabel = [[UILabel alloc] init];
    self.voiceDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.voiceDurationLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.voiceDurationLabel];
    
    self.isReadView = [[UIImageView alloc] init];
    self.isReadView.translatesAutoresizingMaskIntoConstraints = NO;
    self.isReadView.layer.cornerRadius = ISREAD_VIEW_SIZE/2;
    self.isReadView.clipsToBounds = YES;
    self.isReadView.backgroundColor = [UIColor redColor];
    [self.backgroundImageView addSubview:self.isReadView];
    
    [self _setupVoiceBubbleConstraints];

}

- (void)updateVoiceMargin:(UIEdgeInsets)margin {

    if (UIEdgeInsetsEqualToEdgeInsets(_margin, margin)) {
        return;
    }
    
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupVoiceBubbleMarginConstraints];
}

@end
