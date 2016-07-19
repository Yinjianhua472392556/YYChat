//
//  YYMessageViewController.m
//  YYChat
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYMessageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Availability.h>
#import <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIViewController+HUD.h"
#import "YYMessageTimeCell.h"
#import "YYMessageCell.h"
#import "YYBaseMessageCell.h"


#import "YYMessageReadManager.h"
#import "CacheFileHelper.h"
#import "FmdbTool.h"

@interface YYMessageViewController ()<YYMessageCellDelegate> {

    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UILongPressGestureRecognizer *_lpgr;
    
//    dispatch_queue_t _messageQueue;
}

@property (nonatomic, strong) id<IMessageModel>playingVoiceModel;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic, strong) ContactGroupList *toUser;

@end

@implementation YYMessageViewController

- (instancetype)initWithConversationChatter:(ContactGroupList *)toUser conversationType:(YYChatType)conversationType {
   
    _toUser = toUser;
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        _messageCountOfPage = 10;
        _timeCellHeight= 30;
        _scrollToBottomWhenAppear = YES;
        _messsagesSource = [NSMutableArray array];
        
    }
    
    return self;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化页面
    CGFloat chatbarHeight = [YYChatToolbar defaultHeight];
    YYChatToolbarType barType = YYChatToolbarTypeChat;  //先写死为单人聊天,之后可根据会话类型进行配置
    
    self.chatToolbar = [[YYChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
    
    self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    //初始化手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:tap];
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:_lpgr];
    
    
    //注册代理
    [YYDeviceManager sharedInstance].delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(didBecomeActive)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
    
    
    [[YYBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[YYBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];

    
    
    [self tableViewDidTriggerHeaderRefresh];
    
#pragma mark - 从其他页面进入聊天页面时需将badgeValue置为空
    
    YYMessageModel *oldModel = [[[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:YES] lastObject];

    oldModel.badgeValue = @"";
    
    //用修改后的模型替换数据库中旧的模型
    [[FmdbTool sharedfmdbTool] updateWithToUID:_toUser.uid timeStamp:oldModel.timeStamp messageModel:oldModel isConversation:YES];

    //初始化数据（通过数据库拿取数据）
    self.dataArray = [[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:NO];
    [self.tableView reloadData];
    [self _scrollViewToBottom:NO];
    
    //注册监听，当收到对方的聊天数据时从数据库拿取数据，刷新tableView
    [Mynotification addObserver:self selector:@selector(receiveNotificationMessage:) name:SendMsgName object:nil];

    
    [self _scrollViewToBottom:NO];

}



- (void)setupEmotion {
    
    if ([self.dataSource respondsToSelector:@selector(emotionFormessageViewController:)]) {
        NSArray *emotionManagers = [self.dataSource emotionFormessageViewController:self];
        [self.faceView setEmotionManagers:emotionManagers];
    }
    else {
        
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSString *name in [EaseEmoji allEmoji]) {
            EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
            [emotions addObject:emotion];
        }
        
        EaseEmotion *emotion = [emotions objectAtIndex:0];
        EaseEmotionManager *manager = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
        [self.faceView setEmotionManagers:@[manager]];
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.isViewDidAppear = YES;
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    
    self.scrollToBottomWhenAppear = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.isViewDidAppear = NO;
    
    [[YYDeviceManager sharedInstance] disableProximitySensor];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[YYDeviceManager sharedInstance] stopPlaying];
    [YYDeviceManager sharedInstance].delegate = nil;
    if (_imagePicker) {
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
}


#pragma mark - notification

- (void)receiveNotificationMessage:(NSNotification *)notification {

    
    self.dataArray = [[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
    
    
#pragma mark - 当用户在聊天页面时，对应聊天用户在消息列表中的badgeValue需要置为空 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YYMessageModel *oldModel = [[[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:YES] lastObject];
        oldModel.badgeValue = @"";
        //用修改后的模型替换数据库中旧的模型
        [[FmdbTool sharedfmdbTool] updateWithToUID:_toUser.uid timeStamp:oldModel.timeStamp messageModel:oldModel isConversation:YES];
    });
}




#pragma mark - getter

- (UIImagePickerController *)imagePicker {

    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


#pragma mark - setter
- (void)setIsViewDidAppear:(BOOL)isViewDidAppear {
    _isViewDidAppear = isViewDidAppear;
    if (_isViewDidAppear) {
//        NSMutableArray *unreadMessages = [NSMutableArray array];
//        for (YYMessage *message in self.messsagesSource) {
//            
//        }
    }
}


- (void)setChatToolbar:(UIView *)chatToolbar {
    [_chatToolbar removeFromSuperview];
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self.view addSubview:_chatToolbar];
    }
    
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height;
    self.tableView.frame = tableFrame;
    
    if ([chatToolbar isKindOfClass:[YYChatToolbar class]]) {
        [(YYChatToolbar *)self.chatToolbar setDelegate:self];
        self.chatBarMoreView = (YYChatBarMoreView *)[(YYChatToolbar *)self.chatToolbar moreView];
        self.faceView = (YYFaceView *)[(YYChatToolbar *)self.chatToolbar faceView];
        self.recordView = (YYRecordView *)[(YYChatToolbar *)self.chatToolbar recordView];
   }
}


- (void)setDataSource:(id<YYMessageViewControllerDataSource>)dataSource {

    _dataSource = dataSource;
    [self setupEmotion];
}

- (void)setDelegate:(id<YYMessageViewControllerDelegate>)delegate {

    _delegate = delegate;
}

#pragma mark - private helper

- (void)_scrollViewToBottom:(BOOL)animated {

    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (NSURL *)_convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [YYDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}


- (BOOL)_canRecord {
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}


- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(YYMessageBodyType)messageType {
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyMenuAction:)];
    }

    if (messageType == YYMessageBodyTypeText) {
        [_menuController setMenuItems:@[_copyMenuItem,_deleteMenuItem]];
    }else {
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
    
}


- (void)_imageMessageCellSelected:(id<IMessageModel>)model {

    NSMutableArray *photoArray = [NSMutableArray array];
    for (YYMessageModel *messageModel in self.dataArray) {
        if (messageModel.image.urllarge) {
            [photoArray addObject:[NSURL URLWithString:messageModel.image.urllarge]];
        }
    }
    
    [[YYMessageReadManager defaultManager] showBrowserWithImages:photoArray];
    NSUInteger index = [self.dataArray indexOfObject:model];
    [[[YYMessageReadManager defaultManager] photoBrowser] setCurrentPhotoIndex:index];
}

- (void)_audioMessageCellSelected:(id<IMessageModel>)model {
    
    _scrollToBottomWhenAppear = NO;
    NSLog(@"getVoiceWithPath %@",model.voice.url);

    [[NetworkingHelper shareHelper] getVoiceWithPath:model.voice.url completion:^(id data, NSError *error) {
        
        NSData *voiceData = (NSData *)data;

        NSString *savedVoiceDataPath = [[[CacheFileHelper alloc] init] saveVoiceDataWithFilename:model.voice.url Data:voiceData];
        
        NSLog(@"downloadVoiceDataPath %@",savedVoiceDataPath);
        
        [[YYDeviceManager sharedInstance] enableProximitySensor];
        [[YYDeviceManager sharedInstance] asyncPlayingWithPath:savedVoiceDataPath completion:^(NSError *error) {
            
        }];
    }];
    
}


#pragma mark - GestureRecognizer
// 点击背景隐藏
- (void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer {

    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataArray count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        BOOL canLongPress = NO;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:canLongPressRowAtIndexPath:)]) {
            canLongPress = [_dataSource messageViewController:self canLongPressRowAtIndexPath:indexPath];
        }
        
        if (!canLongPress) {
            return;
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:didLongPressRowAtIndexPath:)]) {
            [_dataSource messageViewController:self didLongPressRowAtIndexPath:indexPath];
        }
        else {
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSString class]]) {
#warning 长按菜单
                _menuIndexPath = indexPath;
                [self showMenuViewController:nil andIndexPath:indexPath messageType:0];
            }
        
        }
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //时间cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [YYMessageTimeCell cellIdentifier];
        YYMessageTimeCell *timeCell = (YYMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        if (timeCell == nil) {
            timeCell = [[YYMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;

    }
    else {
        id<IMessageModel> model = object;

//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
//            UITableViewCell *cell = [_delegate messageViewController:tableView cellForMessageModel:model];
//            if (cell) {
//                if ([cell isKindOfClass:[YYMessageCell class]]) {
//                    YYMessageCell *yycell = (YYMessageCell *)cell;
//                    if (yycell.delegate == nil) {
//                        yycell.delegate = self;
//                    }
//                }
//                return cell;
//            }
//        }
//        
//        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
//            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
//
//            if (flag) {
//                
//            }
//        }
        
        
        NSString *CellIdentifier = [YYMessageCell cellIdentifierWithModel:model];
        
        YYBaseMessageCell *sendCell = (YYBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[YYBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        return sendCell;

    }
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<IMessageModel> model = object;
//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
//            CGFloat height = [_delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
//            if (height) {
//                return height;
//            }
//        }
//        
//        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
//            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
//            if (flag) {
//                return [EaseCustomMessageCell cellHeightWithModel:model];
//            }
//        }
        
        return [YYBaseMessageCell cellHeightWithModel:model];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileManager removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        
        [self sendVideoMessageWithURL:mp4];
    }
    else {
    
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        if (url == nil) {
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
            [self sendImageMessage:orgImage];

        }else {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                    if (asset) {
                        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){
                            if (data.length > 10 * 1000 * 10000) {
                                [self showHint:@"图片太大了，换个小点的"];
                                return;
                            }
                            if (data != nil) {
                                [self sendImageMessageWithData:data];
                            } else {
                                [self showHint:@"图片太大了，换个小点的"];
                            }
                        }];
                    }
                }];
            }else {
                ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
                [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                        Byte* buffer = (Byte*)malloc([assetRepresentation size]);
                        NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:[assetRepresentation size] error:nil];
                        NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                        if (fileData.length > 10 * 1000 * 1000) {
                            [self showHint:@"图片太大了，换个小点的"];
                            return;
                        }
                        [self sendImageMessageWithData:fileData];
                    }
                } failureBlock:NULL];
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.isViewDidAppear = YES;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    self.isViewDidAppear = YES;
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model {

    switch (model.typefile) {
        case YYMessageBodyTypeText: {
                 break;
        }
        case YYMessageBodyTypeImage: {
            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
                        break;
        }
        case YYMessageBodyTypeVoice: {
            [self _audioMessageCellSelected:model];
            break;
        }
        case YYMessageBodyTypeLocation: {
            
            break;
        }
        case YYMessageBodyTypeVideo: {
            
            break;
        }
        case YYMessageBodyTypeFile: {
            
            break;
        }
        case YYMessageBodyTypeCmd: {
            
            break;
        }
    }
}

#pragma mark - YYChatToolbarDelegate


- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight {

    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(YYTextView *)inputTextView {

    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    [_menuController setMenuItems:nil];
}


- (void)didSendText:(NSString *)text {

    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary *)ext {

    if ([ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT]) {
        EaseEmotion *emotion = [ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionExtFormessageViewController:easeEmotion:)]) {
            NSDictionary *ext = [self.dataSource emotionExtFormessageViewController:self easeEmotion:emotion];
            [self sendTextMessage:emotion.emotionTitle withExt:ext];
        }else {
        
            [self sendTextMessage:emotion.emotionTitle withExt:@{MESSAGE_ATTR_EXPRESSION_ID:emotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)}];
        }
        
        return;
    }
    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView {
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:YYRecordViewTypeTouchDown];
    }else {
        if ([self.recordView isKindOfClass:[YYRecordView class]]) {
            [(YYRecordView *) self.recordView recordButtonTouchDown];
        }
    }
    
    
    if ([self _canRecord]) {
        YYRecordView *tempView = (YYRecordView *)recordView;
        tempView.center = self.view.center;
        [self.view addSubview:tempView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        [[YYDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
            if (error) {
                NSLog(@"didStartRecordingVoiceAction failure to start recording");
            }
        }];
    }
}

/**
 *  手指向上滑动取消录音
 */

- (void)didCancelRecordingVoiceAction:(UIView *)recordView {

    [[YYDeviceManager sharedInstance] cancelCurrentRecording];
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:YYRecordViewTypeTouchUpOutside];
    }else {
    
        if ([self.recordView isKindOfClass:[YYRecordView class]]) {
            [(YYRecordView *)self.recordView recordButtonTouchUpOutside];
        }
        
        [self.recordView removeFromSuperview];
    }
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecodingVoiceAction:(UIView *)recordView {

    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:YYRecordViewTypeTouchUpInside];
    }else {
        if ([self.recordView isKindOfClass:[YYRecordView class]]) {
            [(YYRecordView *)self.recordView recordButtonTouchUpInside];
        }
        [self.recordView removeFromSuperview];
    }
    
    __weak typeof(self) weakSelf = self;
    [[YYDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
        }
        else {
            [weakSelf showHudInView:self.view hint:@"The recording time is too short"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
            });
        }
    }];
}

- (void)didDragInsideAction:(UIView *)recordView {

    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:YYRecordViewTypeDragInside];
    }else {
        if ([self.recordView isKindOfClass:[YYRecordView class]]) {
            [(YYRecordView *)self.recordView recordButtonDragInside];
        }
    }
}

- (void)didDragOutsideAction:(UIView *)recordView {

    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:YYRecordViewTypeDragOutside];
    }else {
    
        if ([self.recordView isKindOfClass:[YYRecordView class]]) {
            [(YYRecordView *)self.recordView recordButtonDragOutside];
        }
    }
}

#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreView:(YYChatBarMoreView *)moreView didSelectItemInMoreViewAtIndex:(NSInteger)index {

    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectMoreView:AtIndex:)]) {
        [self.delegate messageViewController:self didSelectMoreView:moreView AtIndex:index];
        return;
    }
}


- (void)moreViewPhotoAction:(YYChatBarMoreView *)moreView {

    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    self.isViewDidAppear = NO;
}

- (void)moreViewTakePicAction:(YYChatBarMoreView *)moreView {

    // 隐藏键盘
    [self.chatToolbar endEditing:YES];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:@"simulator does not support taking picture"];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    self.isViewDidAppear = NO;
#endif
}


- (void)moreViewLocationAction:(YYChatBarMoreView *)moreView {
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];

}

- (void)moreViewAudioCallAction:(YYChatBarMoreView *)moreView {
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];

}

- (void)moreViewVideoCallAction:(YYChatBarMoreView *)moreView {
    // 隐藏键盘
    [self.chatToolbar endEditing:YES];

}

#pragma mark - EMCDDeviceManagerProximitySensorDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser {

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    }else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (self.playingVoiceModel == nil) {
            [[YYDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    
    [audioSession setActive:YES error:nil];
}



#pragma mark - action

- (void)deleteMenuAction:(id)sender {
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        
    }
    
    
    self.menuIndexPath = nil;

}


- (void)copyMenuAction:(id)sender {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        
    }
    self.menuIndexPath = nil;
}

#pragma mark - public
- (void)tableViewDidTriggerHeaderRefresh {

    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}


#pragma mark - send message

- (void)sendVideoMessageWithURL:(NSURL *)url {

    //这里需要把视频包装起来发送  可类似于环信的EaseSDKHelper单例来包装为统一的消息然后发送
}

- (void)sendImageMessage:(UIImage *)image {

    //类似sendVideoMessageWithURL
    
}

- (void)sendImageMessageWithData:(NSData *)imageData {

    [[NetworkingHelper shareHelper] sendMessageWithPath:@"http://58.248.159.6:6080/weiyuan/user/api/sendMessage?" toUser:_toUser sendData:imageData voiceTime:0 context:nil chatType:100 fileType:2 completion:^(id data, NSError *error) {
        if (data) {
            self.dataArray = [[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:NO];
            [self.tableView reloadData];
            [self _scrollViewToBottom:NO];
        }
    }];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath duration:(NSInteger)duration {

    NSData *voiceData = [NSData dataWithContentsOfFile:localPath];
    
    [[NetworkingHelper shareHelper] sendMessageWithPath:@"http://58.248.159.6:6080/weiyuan/user/api/sendMessage?" toUser:_toUser sendData:voiceData voiceTime:duration context:nil chatType:100 fileType:3 completion:^(id data, NSError *error) {
        if (data) {
            self.dataArray = [[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:NO];
            [self.tableView reloadData];
            [self _scrollViewToBottom:NO];
        }
    }];
}

- (void)sendTextMessage:(NSString *)text {

    [[NetworkingHelper shareHelper] sendMessageWithPath:@"http://58.248.159.6:6080/weiyuan/user/api/sendMessage?" toUser:_toUser sendData:nil voiceTime:0 context:text chatType:100 fileType:1 completion:^(id data, NSError *error) {
        if (data) {
            self.dataArray = [[FmdbTool sharedfmdbTool] selectMessageDataWithToUID:_toUser.uid isConversation:NO];
            [self.tableView reloadData];
            [self _scrollViewToBottom:NO];
        }

    }];
}



- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary *)ext {


}



#pragma mark - notifycation



#pragma mark - private


@end
