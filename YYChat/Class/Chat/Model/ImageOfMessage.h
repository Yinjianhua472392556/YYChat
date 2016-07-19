//
//  ImageOfMessage.h
//  YYChat
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface ImageOfMessage : NSObject<NSCopying,NSCoding,YYModel>

@property (nonatomic, copy) NSString *urllarge;
@property (nonatomic, copy) NSString *urlsmall;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;

@end
