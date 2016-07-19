//
//  ContactGroupListCell.h
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IconBlock)(UIButton *sender);

@interface ContactGroupListCell : UITableViewCell

@property (nonatomic, strong) UIButton *iconBtton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;

@property (copy, nonatomic) IconBlock iconBlock;


@end
