//
//  YYRecordView.m
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYRecordView.h"
#import "YYDeviceManager+Media.h"
#import "YYDeviceManager+Remind.h"
#import "YYDeviceManager+Microphone.h"
#import "YYDeviceManager+ProximitySensor.h"



@interface YYRecordView() {
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    
    // 提示文字
    UILabel *_textLabel;

}

@end

@implementation YYRecordView

+ (void)initialize {
    // UIAppearance Proxy Defaults
    YYRecordView *recordView = [self appearance];
    recordView.voiceMessageAnimationImages = @[@"EaseUIResource.bundle/VoiceSearchFeedback001",@"EaseUIResource.bundle/VoiceSearchFeedback002",@"EaseUIResource.bundle/VoiceSearchFeedback003",@"EaseUIResource.bundle/VoiceSearchFeedback004",@"EaseUIResource.bundle/VoiceSearchFeedback005",@"EaseUIResource.bundle/VoiceSearchFeedback006",@"EaseUIResource.bundle/VoiceSearchFeedback007",@"EaseUIResource.bundle/VoiceSearchFeedback008",@"EaseUIResource.bundle/VoiceSearchFeedback009",@"EaseUIResource.bundle/VoiceSearchFeedback010",@"EaseUIResource.bundle/VoiceSearchFeedback011",@"EaseUIResource.bundle/VoiceSearchFeedback012",@"EaseUIResource.bundle/VoiceSearchFeedback013",@"EaseUIResource.bundle/VoiceSearchFeedback014",@"EaseUIResource.bundle/VoiceSearchFeedback015",@"EaseUIResource.bundle/VoiceSearchFeedback016",@"EaseUIResource.bundle/VoiceSearchFeedback017",@"EaseUIResource.bundle/VoiceSearchFeedback018",@"EaseUIResource.bundle/VoiceSearchFeedback019",@"EaseUIResource.bundle/VoiceSearchFeedback020"];
    recordView.upCancelText = @"手指向上滑动,取消发送";
    recordView.loosenCancelText = @"松开手指,取消发送";
}


- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];

        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 30)];
        _recordAnimationView.image = [UIImage imageNamed:@"EaseUIResource.bundle/VoiceSearchFeedback001"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];

        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @"取消发送";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    
    return self;
}

#pragma mark - setter

- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages {
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText {

    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText {
    _loosenCancelText = loosenCancelText;
}

// 录音按钮按下
- (void)recordButtonTouchDown {
    // 需要根据声音大小切换recordView动画
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setVoiceImage) userInfo:nil repeats:YES];

}


// 手指在录音按钮内部时离开
- (void)recordButtonTouchUpInside {

    [_timer invalidate];
}


// 手指在录音按钮外部时离开
- (void)recordButtonTouchUpOutside {

    [_timer invalidate];
}

// 手指移动到录音按钮内部
-(void)recordButtonDragInside {
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside {
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = [UIColor redColor];
}

- (void)setVoiceImage {

    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    voiceSound = [[YYDeviceManager sharedInstance] yy_PeekRecorderVioceMeter];
    int index = voiceSound*[_voiceMessageAnimationImages count];
    if (index >= [_voiceMessageAnimationImages count]) {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    }else {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    }

}

@end
