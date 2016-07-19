//
//  YYConversationCell.h
//  YYChat
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IModelCell.h"
//#import "YYConversationModel.h"

#import "YYConversationImageView.h"
#import "YYMessageModel.h"

static CGFloat YYConversationCellMinHeight = 60;

@interface YYConversationCell : UITableViewCell<IModelCell>

@property (nonatomic, strong) YYConversationImageView *avatarView;

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) YYMessageModel *model;

@property (nonatomic, assign) BOOL showAvatar; //default is "YES"


@property (nonatomic) UIFont *titleLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *titleLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *detailLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *detailLabelColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIFont *timeLabelFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *timeLabelColor UI_APPEARANCE_SELECTOR;

@end
