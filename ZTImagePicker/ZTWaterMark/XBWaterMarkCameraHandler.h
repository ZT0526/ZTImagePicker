//
//  XBCameraHandler.h
//  Fieldworks
//
//  Created by Ethan on 15/11/23.
//  Copyright © 2015年 小步创想. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBWatermarkScrollView.h"
#import "ZTLocationModel.h"
#import "UIView+Category.h"
#import "XBImagePickerController.h"
typedef void(^CameraFinishBlock)(UIImage *originImage, ZTLocationModel *placemark, NSUInteger index,XBWaterMark markType, NSString *xmType);

@interface XBWaterMarkCameraHandler : NSObject

+ (instancetype)sharedHandler;

- (void)stopUploadingLocation;

// this block is run in global queue, not the main queue
- (void)showCameraPickerInController:(UIViewController*)viewcontroller finishBlock:(CameraFinishBlock)block;

- (void)showCameraPickerInController:(UIViewController*)viewcontroller finishBlock:(CameraFinishBlock)block cancelBlock:(void (^)(void))cancelBlock;

@end
