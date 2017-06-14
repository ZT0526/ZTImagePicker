//
//  ZTImagePickerOverLayView.h
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/5/13.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Category.h"
#import <AVFoundation/AVFoundation.h>

#define RGB(r,g,b,a) [UIColor \
colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 alpha:a]

@interface ZTImagePickerOverLayView : UIView

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *takePictureButton;
@property (nonatomic, strong) UIImageView *imageLibraryView;
@property (nonatomic, strong) UIView   *buttomBar;

@property (nonatomic, strong) UIImageView   *focusView;

@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *flashAutoButton;
@property (nonatomic, strong) UIButton *flashOpeanButton;
@property (nonatomic, strong) UIButton *flashCloseButton;

@property (nonatomic, strong) UIButton *cameraSwitchButton;
@property (nonatomic, strong) UIView   *topbar;

@property (nonatomic, assign) BOOL      isHiddenFlashButtons;

- (void)reSetTopbar;

- (void)hiddenSelfAndBars:(BOOL )hidden;

- (void)chosedFlashButton:(UIButton *)btn;

- (void)setFlashModel:(AVCaptureFlashMode )mode;

@end
