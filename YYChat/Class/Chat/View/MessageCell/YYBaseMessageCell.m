//
//  YYBaseMessageCell.m
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYBaseMessageCell.h"
#import "UIImageView+EMWebCache.h"

@interface YYBaseMessageCell()

@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic) NSLayoutConstraint *avatarWidthConstraint;
@property (nonatomic) NSLayoutConstraint *nameHeightConstraint;


@property (nonatomic) NSLayoutConstraint *bubbleWithAvatarRightConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithoutAvatarRightConstraint;

@property (nonatomic) NSLayoutConstraint *bubbleWithNameTopConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithoutNameTopConstraint;
@property (nonatomic) NSLayoutConstraint *bubbleWithImageConstraint;

@end

@implementation YYBaseMessageCell

@synthesize nameLabel = _nameLabel;

+ (void)initialize {

    // UIAppearance Proxy Defaults

    YYBaseMessageCell *cell = [self appearance];
    cell.avatarSize = 30;
    cell.avatarCornerRadius = 0;
    
    cell.messageNameColor = [UIColor grayColor];
    cell.messageNameFont = [UIFont systemFontOfSize:10];
    cell.messageNameHeight = 15;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        cell.messageNameIsHidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = _messageNameFont;
        _nameLabel.textColor = _messageNameColor;
        [self.contentView addSubview:_nameLabel];
        
        [self configureLayoutConstraintsWithModel:model];
        
        if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
            self.messageNameHeight = 15;
        }

    }
    return self;
}


- (void)layoutSubviews {

    [super layoutSubviews];
    
    _bubbleView.backgroundImageView.image = self.model.isSender ? self.sendBubbleBackgroundImage : self.recvBubbleBackgroundImage;

    switch (self.model.typefile) {
        case YYMessageBodyTypeText: {
            
            break;
        }
        case YYMessageBodyTypeImage: {
            CGFloat width = [self.model.image.width floatValue];
            CGFloat height = [self.model.image.height floatValue];
            
            CGSize retSize = CGSizeMake(width, height);
            if (retSize.width == 0 || retSize.height == 0) {
                retSize.width = kEMMessageImageSizeWidth;
                retSize.height = kEMMessageImageSizeHeight;

            }
            else if (retSize.width > retSize.height) {
                CGFloat height =  kEMMessageImageSizeWidth / retSize.width * retSize.height;
                retSize.height = height;
                retSize.width = kEMMessageImageSizeWidth;
            }
            else {
                CGFloat width = kEMMessageImageSizeHeight / retSize.height * retSize.width;
                retSize.width = width;
                retSize.height = kEMMessageImageSizeHeight;
            }
            
            [self removeConstraint:self.bubbleWithImageConstraint];
            
            CGFloat margin = [YYMessageCell appearance].leftBubbleMargin.left + [YYMessageCell appearance].leftBubbleMargin.right;
            self.bubbleWithImageConstraint = [NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:retSize.width + margin];
            [self addConstraint:self.bubbleWithImageConstraint];
            break;
        }
        case YYMessageBodyTypeVideo: {
            
            break;
        }
        case YYMessageBodyTypeLocation: {
            
            break;
        }
        case YYMessageBodyTypeVoice: {
            
            break;
        }
        case YYMessageBodyTypeFile: {
            
            break;
        }
        case YYMessageBodyTypeCmd: {
            
            break;
        }
    }
}


- (void)configureLayoutConstraintsWithModel:(id<IMessageModel>)model {

    if (model.isSender) {
        [self configureSendLayoutConstraints];
    }else {
    
        [self configureRecvLayoutConstraints];
    }
}


- (void)configureSendLayoutConstraints {
    
    //avatar view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseMessageCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.avatarSize];
    [self addConstraint:self.avatarWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    //name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
    [self addConstraint:self.nameHeightConstraint];
    
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //status button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    //activity
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activity attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    
    //hasRead
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hasRead attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
}


- (void)configureRecvLayoutConstraints {

    //avatar view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:EaseMessageCellPadding]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:EaseMessageCellPadding]];
    
    self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.avatarSize];
    [self addConstraint:self.avatarWidthConstraint];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    //name label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    
    self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
    [self addConstraint:self.nameHeightConstraint];
    
    //bubble view
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}


#pragma mark - Update Constraint

- (void)_updateNameHeightConstraint {

    if (_nameLabel) {
        [self removeConstraint:self.nameHeightConstraint];
        
        self.nameHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.messageNameHeight];
        [self addConstraint:self.nameHeightConstraint];
    }
}


- (void)_updateAvatarViewWidthConstraint
{
    if (self.avatarView) {
        [self removeConstraint:self.avatarWidthConstraint];
        
        self.avatarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.avatarSize];
        [self addConstraint:self.avatarWidthConstraint];
    }
}

#pragma mark - setter

- (void)setModel:(id<IMessageModel>)model {

    [super setModel:model];
    
//    if (model.avatarURLPath) {
//        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
//    }else {
//    
//        self.avatarView.image = model.avatarImage;
//    }
    
//    _nameLabel.text = model.nickname;
    _hasRead.hidden = YES;  //暂时都隐藏

    if (self.model.isSender) { //发送者
//        _hasRead.hidden = YES;
        
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.from.headUrl] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];
//        switch (self.model.messageStatus) {
//           
//            case YYMessageStatusDelivering: {
//                _statusButton.hidden = YES;
//                [_activity setHidden:NO];
//                [_activity startAnimating];
//                break;
//            }
//            case YYMessageStatusSuccessed: {
//                _statusButton.hidden = YES;
//                [_activity stopAnimating];
//                if (self.model.isMessageRead) {
//                    _hasRead.hidden = NO;
//                }
//                break;
//            }
//            case YYMessageStatusPending:
//            case YYMessageStatusFailed: {
//                
//                [_activity stopAnimating];
//                [_activity setHidden:YES];
//                _statusButton.hidden = NO;
//                break;
//            }
//        }
    }
    else { //接收者
    
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.to.headUrl] placeholderImage:[UIImage imageNamed:@"placeHoldHeader"]];

    }
}


- (void)setMessageNameFont:(UIFont *)messageNameFont {

    _messageNameFont = messageNameFont;
    if (_nameLabel) {
        _nameLabel.font = _messageNameFont;
    }
}

- (void)setMessageNameColor:(UIColor *)messageNameColor {

    _messageNameColor = messageNameColor;
    if (_nameLabel) {
        _nameLabel.textColor = _messageNameColor;
    }
}


- (void)setMessageNameHeight:(CGFloat)messageNameHeight {

    _messageNameHeight = messageNameHeight;
    if (_nameLabel) {
        [self _updateNameHeightConstraint];
    }
}

- (void)setAvatarSize:(CGFloat)avatarSize {

    _avatarSize = avatarSize;
    if (self.avatarSize) {
        [self _updateAvatarViewWidthConstraint];
    }
}

- (void)setAvatarCornerRadius:(CGFloat)avatarCornerRadius {

    _avatarCornerRadius = avatarCornerRadius;
    if (self.avatarView) {
        self.avatarView.layer.cornerRadius = avatarCornerRadius;
    }
}


- (void)setMessageNameIsHidden:(BOOL)messageNameIsHidden {

    _messageNameIsHidden = messageNameIsHidden;
    if (_nameLabel) {
        _nameLabel.hidden = messageNameIsHidden;
    }
}


#pragma mark - public

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model {

    YYBaseMessageCell *cell = [self appearance];
    
    CGFloat minHeight = cell.avatarSize + EaseMessageCellPadding * 2;
    CGFloat height = cell.messageNameHeight;
    if ([UIDevice currentDevice].systemVersion.floatValue == 7.0) {
        height = 15;
    }
    
    height += - EaseMessageCellPadding + [YYMessageCell cellHeightWithModel:model];
    height = height > minHeight? height : minHeight;
    
    return height;
}

@end
