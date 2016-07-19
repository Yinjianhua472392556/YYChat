//
//  VoiceOfMessage.h
//  YYChat
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface VoiceOfMessage : NSObject<NSCopying,NSCoding,YYModel>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *time;

@end
