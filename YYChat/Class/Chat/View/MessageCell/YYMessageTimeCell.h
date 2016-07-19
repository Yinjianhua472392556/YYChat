//
//  YYMessageTimeCell.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMessageTimeCell : UITableViewCell

@property (strong, nonatomic) NSString *title;

@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:12]

@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor]

+ (NSString *)cellIdentifier;
@end
