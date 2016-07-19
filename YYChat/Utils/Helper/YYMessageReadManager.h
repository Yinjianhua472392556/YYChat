//
//  YYMessageReadManager.h
//  YYChat
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWPhotoBrowser.h"
#import "YYMessageModel.h"


typedef void(^FinishBlock)(BOOL success);
typedef void(^PlayBlock)(BOOL playing, YYMessageModel *messageModel);

@interface YYMessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, copy) FinishBlock finishBlock;

@property (nonatomic, strong) YYMessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;



@end
