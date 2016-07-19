//
//  YYConversationCell.m
//  YYChat
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYConversationCell.h"

#import "UIImageView+EMWebCache.h"


CGFloat const EaseConversationCellPadding = 10;

@interface YYConversationCell()

@property (nonatomic, strong) NSLayoutConstraint *titleWithAvatarLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *titleWithoutAvatarLeftConstraint;

@property (nonatomic) NSLayoutConstraint *detailWithAvatarLeftConstraint;
@property (nonatomic) NSLayoutConstraint *detailWithoutAvatarLeftConstraint;

@end

@implementation YYConversationCell

+ (void)initialize {

    // UIAppearance Proxy Defaults
    YYConversationCell *cell = [self appearance];
    cell.titleLabelColor = [UIColor blackColor];
    cell.titleLabelFont = [UIFont systemFontOfSize:17];
    cell.detailLabelColor = [UIColor lightGrayColor];
    cell.detailLabelFont = [UIFont systemFontOfSize:15];
    cell.timeLabelColor = [UIColor blackColor];
    cell.timeLabelFont = [UIFont systemFontOfSize:13];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _showAvatar = YES;
        
        [self _setupSubview];
    }
    
    return self;
}


#pragma mark - private layout subviews

- (void)_setupSubview {

    _avatarView = [[YYConversationImageView alloc] init];
    _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatarView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = _timeLabelFont;
    _timeLabel.textColor = _titleLabelColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_timeLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = _titleLabelFont;
    _titleLabel.textColor = _titleLabelColor;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = _detailLabelFont;
    _detailLabel.textColor = _detailLabelColor;
    [self.contentView addSubview:_detailLabel];

    [self _setupAvatarViewConstraints];
    [self _setupTimeLabelConstraints];
    [self _setupTitleLabelConstraints];
    [self _setupDetailLabelConstraints];
}



#pragma mark - Setup Constraints

- (void)_setupAvatarViewConstraints {
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];

}

- (void)_setupTimeLabelConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
}


- (void)_setupTitleLabelConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.timeLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseConversationCellPadding]];

    self.titleWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
    self.titleWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.titleWithAvatarLeftConstraint];
}

- (void)_setupDetailLabelConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-EaseConversationCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseConversationCellPadding]];

    self.detailWithAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseConversationCellPadding];
    self.detailWithoutAvatarLeftConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseConversationCellPadding];
    [self addConstraint:self.detailWithAvatarLeftConstraint];
}

#pragma mark - setter
- (void)setShowAvatar:(BOOL)showAvatar {

    if (_showAvatar != showAvatar) {
        _showAvatar = showAvatar;
        self.avatarView.hidden = !showAvatar;
        if (_showAvatar) {
            [self removeConstraint:self.titleWithoutAvatarLeftConstraint];
            [self removeConstraint:self.detailWithoutAvatarLeftConstraint];
            [self addConstraint:self.titleWithAvatarLeftConstraint];
            [self addConstraint:self.detailWithAvatarLeftConstraint];
        }
        else {
        
            [self removeConstraint:self.titleWithAvatarLeftConstraint];
            [self removeConstraint:self.detailWithAvatarLeftConstraint];
            [self addConstraint:self.titleWithoutAvatarLeftConstraint];
            [self addConstraint:self.detailWithoutAvatarLeftConstraint];
        }
    }
}


- (void)setModel:(YYMessageModel *)model {

    _model = model;
    
    if (model.isSender) {//模型为发送者时，_model.to才是需要显示的对方信息
        
        if ([_model.to.userName length] > 0) {
            self.titleLabel.text = _model.to.userName;
        }else {
        
            self.titleLabel.text = @"";
        }
        
        if (self.showAvatar) {
            
            if ([_model.to.headUrl length] > 0) {
                [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.to.headUrl] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
            }
            else {
            
                self.avatarView.image = [UIImage imageNamed:@"placeHoldHeader"];
            }
        }
        
    }else {
        
        if ([_model.from.userName length] > 0) {
            self.titleLabel.text = _model.from.userName;
        }
        else {
            
            self.titleLabel.text = @"";
        }
        
        if (self.showAvatar) {
            if ([_model.from.headUrl length] > 0) {
                [self.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:_model.from.headUrl] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
            }
            else {
                
                self.avatarView.image = [UIImage imageNamed:@"placeHoldHeader"];
            }
        }
    }
    
    if ([_model.badgeValue integerValue] == 0 || [_model.badgeValue isEqualToString:@""]) {
        _avatarView.showBadge = NO;
    }
    else {
    
        _avatarView.showBadge = YES;
        _avatarView.badge = [_model.badgeValue integerValue];
    }
    
}


- (void)setTitleLabelFont:(UIFont *)titleLabelFont {

    _titleLabelFont = titleLabelFont;
    _titleLabel.font = _titleLabelFont;
}


- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    _titleLabel.textColor = _titleLabelColor;
}


- (void)setDetailLabelFont:(UIFont *)detailLabelFont {
    _detailLabelFont = detailLabelFont;
    _detailLabel.font = _detailLabelFont;
}

- (void)setDetailLabelColor:(UIColor *)detailLabelColor {
    _detailLabelColor = detailLabelColor;
    _detailLabel.textColor = _detailLabelColor;
}

- (void)setTimeLabelFont:(UIFont *)timeLabelFont {
    _timeLabelFont = timeLabelFont;
    _timeLabel.font = _timeLabelFont;
}

- (void)setTimeLabelColor:(UIColor *)timeLabelColor {
    _timeLabelColor = timeLabelColor;
    _timeLabel.textColor = _timeLabelColor;
}

#pragma mark - class method

+ (NSString *)cellIdentifierWithModel:(id)model {

    return @"YYConversationCell";
}

+ (CGFloat)cellHeightWithModel:(id)model {

    return YYConversationCellMinHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (_avatarView.badge) {
        _avatarView.badgeBackgroudColor = [UIColor redColor];
    }
}

@end
