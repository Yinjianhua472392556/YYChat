//
//  ContactHeaderView.h
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactHeaderView, ContactGroup;

@protocol ContactHeaderViewDelegate <NSObject>

- (void)didClickHeaderView:(ContactHeaderView *)headerView;

@end

@interface ContactHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<ContactHeaderViewDelegate> delegate;
@property (nonatomic, strong) ContactGroup *contactGroup; /*<联系人组别模型*/

@end
