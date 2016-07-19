//
//  IModelCell.h
//  YYChat
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IModelCell <NSObject>

@required
@property (nonatomic, strong) id model;

+ (NSString *)cellIdentifierWithModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id)model;

@optional
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;
@end
