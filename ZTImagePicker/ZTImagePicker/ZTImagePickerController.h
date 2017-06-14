//
//  ZTImagePickerController.h
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/5/13.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTImagePickerOverLayView.h"
#import "ZTImagePickerPreImageView.h"

@class ZTImagePickerController;
@protocol ZTImagePickerControllerDelegate <NSObject>

- (void)imagePickerControllerTakePhoto:(ZTImagePickerController *)picker;
- (void)imagePickerControllerDidCancel:(ZTImagePickerController *)picker;

- (void)imagePickerControllerRetakePhoto:(ZTImagePickerController *)picker;
- (void)imagePickerControllerUseImage:(ZTImagePickerController *)picker image:(UIImage *)image;

@end

@interface ZTImagePickerController : UIViewController

@property (nonatomic , weak) id<ZTImagePickerControllerDelegate>  delegate;

@property (nonatomic , assign) UIImagePickerControllerSourceType sourceType;


@property (nonatomic, strong) ZTImagePickerOverLayView    *preview;
@property (nonatomic, strong) ZTImagePickerPreImageView   *preImageView;

- (void)p_config;


- (void)flashButtonClick:(UIButton *)sender;
- (void)takePhotoButtonClick:(id )sender;
- (void)cancelButtonClick:(id )sender;
- (void)retakeButtonClick:(id )sender;
- (void)useImageButtonClick:(id )sender;

@end
