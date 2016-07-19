//
//  YYMessageReadManager.m
//  YYChat
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YYMessageReadManager.h"
#import "UIImageView+EMWebCache.h"
#import "YYDeviceManager.h"
#import "YYDeviceManager+Media.h"

#define IMAGE_MAX_SIZE_5k 5120*2880


static YYMessageReadManager *detailInstance = nil;


@interface YYMessageReadManager()

@property (nonatomic, strong) UIWindow *keyWindow;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UINavigationController *photoNavigationController;

@property (nonatomic, strong) UIAlertView *textAlertView;

@end

@implementation YYMessageReadManager

+ (id)defaultManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detailInstance = [[self alloc] init];
    });
    
    return detailInstance;
}


#pragma mark - getter

- (UIWindow *)keyWindow {

    if (_keyWindow == nil) {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}


- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}


- (MWPhotoBrowser *)photoBrowser {

    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
//        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
//        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController {

    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    
    return _photoNavigationController;
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {

    return self.photos.count;
}


- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {

    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - public
- (void)showBrowserWithImages:(NSArray *)imageArray {

    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                CGFloat imageSize = ((UIImage*)object).size.width * ((UIImage*)object).size.height;
                if (imageSize > IMAGE_MAX_SIZE_5k) {
                    photo = [MWPhoto photoWithImage:[self scaleImage:object toScale:(IMAGE_MAX_SIZE_5k)/imageSize]];
                }else {
                
                    photo = [MWPhoto photoWithImage:object];
                }

            }
            else if ([object isKindOfClass:[NSURL class]]) {
                
                photo = [MWPhoto photoWithURL:object];
            
            }else if ([object isKindOfClass:[NSString class]]) {
            
            }
            
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:self.photoNavigationController animated:YES completion:nil];

}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
