//
//  XBCameraHandler.m
//  Fieldworks
//
//  Created by Ethan on 15/11/23.
//  Copyright © 2015年 小步创想. All rights reserved.
//

#import "XBWaterMarkCameraHandler.h"



#import "UIImage+FWAddition.h"


#import "ZTImagePickerController.h"
#import "UIImage+XIMAddition.h"
#import "UIImage+FWAddition.h"

@interface XBWaterMarkCameraHandler() <UINavigationControllerDelegate,ZTImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *viewcontroller;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, copy) CameraFinishBlock finishBlock;
@property (nonatomic, copy) void(^cancelBlock)(void);


@property (nonatomic, copy) ZTLocationModel *locationModel;
@property (nonatomic, assign) BOOL cameraShowed;

@end

@implementation XBWaterMarkCameraHandler



+ (instancetype)sharedHandler {
    static dispatch_once_t once;
    static XBWaterMarkCameraHandler *handler;
    dispatch_once(&once, ^{
        handler = [[XBWaterMarkCameraHandler alloc] init];
    });
    handler.cameraShowed = NO;
    return handler;
}


- (NSString *)placemark {
    return _locationModel.placemark.length ? _locationModel.placemark : @"地理位置获取失败";
}

- (void)showCameraPickerInController:(UIViewController*)viewcontroller finishBlock:(CameraFinishBlock)block {
    [self showCameraPickerInController:viewcontroller finishBlock:block cancelBlock:nil];
}

- (void)showCameraPickerInController:(UIViewController*)viewcontroller finishBlock:(CameraFinishBlock)block cancelBlock:(void (^)(void))cancelBlock {
    
    self.cameraShowed = YES;
    
    self.viewcontroller = viewcontroller;
    self.index = 0;
    self.finishBlock = block;
    self.cancelBlock = cancelBlock;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该设备不支持相机功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if (![self cameraAuthorized]) return;
    
    //UIImagePickerController
    XBImagePickerController *picker = [[XBImagePickerController alloc] init];
    picker.waterMarkType = XBWaterMarkDefault;
    picker.delegate = self;
    //picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    
    [self.viewcontroller presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
    
}

- (BOOL)cameraAuthorized
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            NSArray *items;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"需要访问您的相机。\n请启用设置-隐私-相机" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"asd");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    view.tag = 1209;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
//    [UIHelper showHUDAddedTo:view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[[info objectForKey:UIImagePickerControllerOriginalImage] orientationFixedImage] thumbnailForMaxWidth:1024/[UIScreen mainScreen].scale maxHeight:1024/[UIScreen mainScreen].scale];
        if (self.finishBlock) {
            if([picker isKindOfClass:[XBImagePickerController class]])
                self.finishBlock(image, self.locationModel, self.index, ((XBImagePickerController *)picker).waterMarkType,((XBImagePickerController *)picker).scrollView.xmReportType);
            else
                self.finishBlock(image, self.locationModel, self.index, XBWaterMarkDefault , nil);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:NO completion:^{
                [self performSelector:@selector(showCameraWithView:) withObject:view afterDelay:0.2f];
            }];
        });
        
    });
}

#pragma mark ZTImagePickerDelegate

- (void)imagePickerControllerUseImage:(ZTImagePickerController *)picker image:(UIImage *)image{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    view.tag = 1209;
    [[UIApplication sharedApplication].delegate.window addSubview:view];
    //[UIHelper showHUDAddedTo:view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image2 = [[image orientationFixedImage] thumbnailForMaxWidth:1024/[UIScreen mainScreen].scale maxHeight:1024/[UIScreen mainScreen].scale];
        if (self.finishBlock) {
            if([picker isKindOfClass:[XBImagePickerController class]])
                self.finishBlock(image2, self.locationModel, self.index, ((XBImagePickerController *)picker).waterMarkType,((XBImagePickerController *)picker).scrollView.xmReportType);
            else
                self.finishBlock(image2, self.locationModel, self.index, XBWaterMarkDefault , nil);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:NO completion:^{
                [self performSelector:@selector(showCameraWithView:) withObject:view afterDelay:0.2f];
            }];
        });
        
    });

}

- (void)imagePickerControllerDidCancel:(ZTImagePickerController *)picker{
   
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCameraWithView:(UIView*)view {
    self.index++;
    XBImagePickerController *newPicker = [[XBImagePickerController alloc] init];
    newPicker.delegate = self;
    //newPicker.allowsEditing = NO;
    newPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.viewcontroller presentViewController:[[UINavigationController alloc] initWithRootViewController:newPicker] animated:NO completion:^{
        //[UIHelper hideAllHUDsForView:view animated:YES];
        [view removeFromSuperview];
    }];
}




@end
