//
//  CustomNavgationController.m
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CustomNavgationController.h"

@interface CustomNavgationController ()

@end

@implementation CustomNavgationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];

}

@end
