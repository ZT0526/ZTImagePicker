//
//  ZTImagePickerController.m
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/5/13.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTImagePickerController.h"
#import "ZTImagePickerOverLayView.h"
#import "ZTImagePickerPreImageView.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface ZTImagePickerController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZTImagePickerOverLayView  *overlayView;

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureSession* session;

@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;

@property (nonatomic, strong) AVCaptureDevice             *device;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;

@property (nonatomic, strong) NSData                      *imageData;


@property(nonatomic,assign)CGFloat beginGestureScale;

@property(nonatomic,assign)CGFloat effectiveScale;

@end

@implementation ZTImagePickerController{
    BOOL isUsingFrontFacingCamera;
    
}

#pragma mark life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_config];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark private method

- (void)p_config{
    [self p_initAVCaptureSession];
    
    [self p_configGesture];
    
    [self p_configActions];
    
    
    
    isUsingFrontFacingCamera = NO;
    
    self.effectiveScale = self.beginGestureScale = 1.0f;
    
}

- (void)p_initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error;
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
   
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    NSLog(@"%f",ScreenWidth);
    self.previewLayer.frame = CGRectMake(0, 0,ScreenWidth, ScreenHeight);
    self.preview = [[ZTImagePickerOverLayView alloc] init];
    self.preview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.preview layoutSubviews];
    [self.preview.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.preview];
    
    //添加顶部以及底部的自定义工具条
    [self.view addSubview:self.preview.topbar];
    [self.view addSubview:self.preview.buttomBar];
    self.preview.topbar.frame = CGRectMake(0, 0, self.view.width, 64 * ScreenWidth/320.0);
    self.preview.buttomBar.frame = CGRectMake(0, self.view.height - 70 * ScreenWidth/320.0 , self.view.width, 70* ScreenWidth/320.0);
    [self.preview layoutSubviews];
    //设置闪关灯模式
    if(self.device.isFlashAvailable)
        [self.preview setFlashModel:self.device.flashMode];
    else{
        self.preview.flashButton.hidden = YES;
        self.preview.cameraSwitchButton.hidden = YES;
    }
    
    //设置拍照后预览图层
    self.preImageView = [[ZTImagePickerPreImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.preImageView layoutSubviews];
    self.preImageView.hidden = YES;
    [self.view addSubview:self.preImageView];
    
}

- (void)p_configGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.preview addGestureRecognizer:pinch];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(focusAction:)];
    [self.preview addGestureRecognizer:tap];
}

- (void)p_configActions{
    
    [self.preview.cameraSwitchButton addTarget:self action:@selector(switchCameraSegmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashAutoButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashOpeanButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashCloseButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.takePictureButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preImageView.reTakeButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preImageView.useImageButton addTarget:self action:@selector(useImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Actions

- (void)focusAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.preview];
    CGPoint pointInsect = CGPointMake(location.x / self.view.width, location.y / self.view.height);
    
    [self.preview.focusView setCenter:location];
    self.preview.focusView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.preview.focusView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.preview.focusView.alpha = 0.0;
        }completion:^(BOOL finished) {
            self.preview.focusView.hidden = YES;
        }];
    }];
    
    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.device lockForConfiguration:&error])
        {
            if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.device setFocusPointOfInterest:pointInsect];
            }
            
            if([self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.device setExposurePointOfInterest:pointInsect];
                [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            
            [self.device unlockForConfiguration];
        }
    }

}

//切换镜头
- (void)switchCameraSegmentedControlClick:(id)sender {
    
    //NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (isUsingFrontFacingCamera){
        
        if(device.isFlashAvailable) self.preview.flashButton.hidden = NO;
        desiredPosition = AVCaptureDevicePositionBack;
        
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
        [self.preview reSetTopbar];
        self.preview.flashButton.hidden = YES;
        
        
    }
    
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)flashButtonClick:(UIButton *)sender {
    //[self.preview reSetTopbar];
    [self.preview chosedFlashButton:sender];
    
    NSLog(@"flashButtonClick");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        if([sender.titleLabel.text isEqualToString:@"打开"]){
            if([device isFlashModeSupported:AVCaptureFlashModeOn])
                [device setFlashMode:AVCaptureFlashModeOn];
        }else if ([sender.titleLabel.text isEqualToString:@"自动"]){
            if([device isFlashModeSupported:AVCaptureFlashModeAuto])
                [device setFlashMode:AVCaptureFlashModeAuto];
            
        }else if ([sender.titleLabel.text isEqualToString:@"关闭"]){
            if([device isFlashModeSupported:AVCaptureFlashModeOff])
                [device setFlashMode:AVCaptureFlashModeOff];
        }
    } else {
        
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}

- (void)waterMarkFixed{
    
}
- (void)takePhotoButtonClick:(id )sender{
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.imageData = jpegData;
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        UIImage *image = [UIImage imageWithData:jpegData];
        [self waterMarkFixed];
        self.preImageView.imageView.image = image;
        [self.preview hiddenSelfAndBars:YES];
        self.preImageView.hidden = NO;
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                    //无权限
                    return ;
                }
        //保存到相册
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//            [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//        
//            }];
        
    }];
    
    if([self.delegate respondsToSelector:@selector(imagePickerControllerTakePhoto:)])
        [self.delegate imagePickerControllerTakePhoto:self];
    
}

- (void)cancelButtonClick:(id )sender{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        [self.delegate imagePickerControllerDidCancel:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)retakeButtonClick:(id )sender{
    
    [self.preview hiddenSelfAndBars:NO];
    self.preImageView.hidden = YES;
    
    if([self.delegate respondsToSelector:@selector(imagePickerControllerRetakePhoto:)])
        [self.delegate imagePickerControllerRetakePhoto:self];
}

- (void)useImageButtonClick:(id )sender{
    [self waterMarkFixed];
    [self.preview hiddenSelfAndBars:NO];
    self.preImageView.hidden = YES;
    
    if([self.delegate respondsToSelector:@selector(imagePickerControllerUseImage:image:)])
        [self.delegate imagePickerControllerUseImage:self image:[UIImage imageWithData:self.imageData]];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.preview];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

#pragma mark gestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}


@end
