//
//  YYChatToolbarItem.m
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYChatToolbarItem.h"

@implementation YYChatToolbarItem

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View {
    self = [super init];
    if (self) {
        _button = button;
        _button2View = button2View;
    }
    
    return self;
}

@end
