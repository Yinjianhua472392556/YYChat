//
//  ContactGroupListCell.m
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ContactGroupListCell.h"

CGFloat const CellPadding = 10;
CGFloat const IconButtonWidth = 60;


@implementation ContactGroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _iconBtton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        [_iconBtton addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconBtton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconBtton.frame) + 5, 5, self.contentView.frame.size.width - 45, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];

        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconBtton.frame) + 5, CGRectGetMaxY(_iconBtton.frame) - 20, self.contentView.frame.size.width - 45, 20)];
        _signLabel.font = [UIFont systemFontOfSize:12];
        _signLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_signLabel];

//        [self configureLayoutConstraints];
        
    }
    
    return self;
}

- (void)configureLayoutConstraints {
    
//    _iconBtton
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconBtton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconBtton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconBtton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconBtton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:IconButtonWidth]];
    
    
//_nameLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.iconBtton attribute:NSLayoutAttributeRight multiplier:1.0 constant:CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:110]];
//_signLabel
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.signLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.iconBtton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:CellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.signLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iconBtton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

}


- (void)iconClick:(UIButton *)btn {
    if (self.iconBlock) {
        self.iconBlock(btn);
    }
}

@end
