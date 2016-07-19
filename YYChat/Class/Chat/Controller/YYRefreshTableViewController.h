//
//  YYRefreshTableViewController.h
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KCELLDEFAULTHEIGHT 50

@interface YYRefreshTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    NSArray *_rightItems;
}

@property (strong, nonatomic) NSArray *rightItems;
@property (strong, nonatomic) UIView *defaultFooterView;
@property (strong, nonatomic) UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;
@property (nonatomic) int page;


@property (nonatomic) BOOL showRefreshHeader;//是否支持下拉刷新
@property (nonatomic) BOOL showRefreshFooter;//是否支持上拉加载
@property (nonatomic) BOOL showTableBlankView;//是否显示无数据时默认背景

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;//下拉刷新事件
- (void)tableViewDidTriggerFooterRefresh;//上拉加载事件

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;
@end
