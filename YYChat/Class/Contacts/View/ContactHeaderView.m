//
//  ContactHeaderView.m
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ContactHeaderView.h"
#import "ContactGroup.h"

@interface ContactHeaderView()
@property (nonatomic, strong) UIButton *button;
@end

@implementation ContactHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"headerBg"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"contactListHeadImage"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.imageView.clipsToBounds = NO;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
    }
    
    return self;
}


//点击按钮触发代理方法，改变open的状态

- (void)headBtnClick:(UIButton *)button {

    self.contactGroup.open = !self.contactGroup.open;

    if ([self.delegate respondsToSelector:@selector(didClickHeaderView:)]) {
        [self.delegate didClickHeaderView:self];
    }
    
}

//设置组名和图片

- (void)setContactGroup:(ContactGroup *)contactGroup {

    _contactGroup = contactGroup;
    [self.button setTitle:contactGroup.groupname forState:UIControlStateNormal];
    
    if (_contactGroup.isOpen) {
        self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);

    }else {
        
        self.button.imageView.transform = CGAffineTransformMakeRotation(0);

    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
}

@end
