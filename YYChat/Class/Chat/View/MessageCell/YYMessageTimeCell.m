//
//  YYMessageTimeCell.m
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYMessageTimeCell.h"

CGFloat const EaseMessageTimeCellPadding = 5;

@interface YYMessageTimeCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YYMessageTimeCell

+ (void)initialize {

    // UIAppearance Proxy Defaults
    YYMessageTimeCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor grayColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:12];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self _setupSubview];
    }
    return self;
}


#pragma mark - setup subviews

- (void)_setupSubview {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = _titleLabelColor;
    _titleLabel.font = _titleLabelFont;
    [self.contentView addSubview:_titleLabel];
    
    [self _setupTitleLabelConstraints];
}

#pragma mark - Setup Constraints

- (void)_setupTitleLabelConstraints {
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseMessageTimeCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseMessageTimeCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseMessageTimeCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseMessageTimeCellPadding]];

}


#pragma mark - setter
- (void)setTitle:(NSString *)title {

    _title = title;
    _titleLabel.text = _title;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {

    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}
#pragma mark - public

+ (NSString *)cellIdentifier {

    return @"MessageTimeCell";
}

@end
