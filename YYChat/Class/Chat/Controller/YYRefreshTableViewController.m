//
//  YYRefreshTableViewController.m
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYRefreshTableViewController.h"

#import <MJRefresh/MJRefresh.h>

@interface YYRefreshTableViewController ()
@property (nonatomic, readonly) UITableViewStyle style;
@end

@implementation YYRefreshTableViewController

@synthesize rightItems = _rightItems;

- (instancetype)initWithStyle:(UITableViewStyle)style {

    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:self.style];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.defaultFooterView;
    [self.view addSubview:_tableView];
    
    _page = 0;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    _showTableBlankView = NO;

}


#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak YYRefreshTableViewController *weakSelf = self;
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
        }
    }
}


- (void)setShowRefreshFooter:(BOOL)showRefreshFooter {

    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak YYRefreshTableViewController *weakSelf = self;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
                [weakSelf.tableView.mj_footer beginRefreshing];
             }];
        }
    }
}


- (void)setShowTableBlankView:(BOOL)showTableBlankView {

    if (_showTableBlankView != showTableBlankView) {
        _showTableBlankView = showTableBlankView;
    }
}

#pragma mark - getter (懒加载)

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


- (NSMutableDictionary *)dataDictionary {
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    
    return _dataDictionary;
}


- (UIView *)defaultFooterView {
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc] init];
    }
    
    return _defaultFooterView;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
//
//
//#pragma mark - Table view delegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return KCELLDEFAULTHEIGHT;
//}




#pragma mark - public refresh
- (void)tableViewDidTriggerHeaderRefresh {

}


- (void)tableViewDidTriggerFooterRefresh {

}


- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload {

    __weak YYRefreshTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else {
        
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    });
}

@end
