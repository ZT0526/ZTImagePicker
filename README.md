# ZTImagePicker

在项目中当我们遇到拍照的功能模块的时候，如果仅仅是用来拍照，系统提供的UIImagePickerController足够用来完成我们的任务。但是当我们的应用场景稍稍复杂点的时候，如要实现类似水印相机、美颜相机的时候，UIImagePickerController就有点力不从心了，需要自己去diy一个自定义相机。

UIImagePickerController使用起来比较简单易用，拍照，录制视频、控制闪光灯，前后摄像头的切换一应俱全。但是相机支持ui界面的自定义并不好(虽然可以支持自定义)，在不同的系统下相机的功能界面还有所差别。

以水印相机为例，在水印相机中我们需要能够让水印模式实时的显示在相机的取景框中，而且水印模式还要可以左右滑动切换，在横屏的时候水印也要跟着横屏，还要有放大缩小镜头的以及点击屏幕能够聚焦等功能。

![腾讯水印相机.gif](http://upload-images.jianshu.io/upload_images/1716542-12ea92d5ec98730c.gif?imageMogr2/auto-orient/strip)

当然有人可能会想，将水印模式分成一个视图层然后放到相机的最上层不就行了吗？当然是不行的，首先UIImagePickerController在不同系统中的封装是略微不一样的，ui界面有所差别，界面不能够统一，即便是现在花了很过代码一个系统一个系统的适配，也很难保证以后不出问题，其次是手势的识别也有问题，即便是对手势进行了拦截处理，也不能解决，说白了也就是不是自己封装的东西，难以得到完美的掌控。

下面就开始自定义一个相机，并实现拍照、取消、闪光灯控制、前后摄像头控制、聚焦、放大缩小、拍照后预览、重拍、使用照片等功能。
```
@property (nonatomic, strong) ZTImagePickerOverLayView  *overlayView;//预览图层

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureSession* session;//用于捕捉视频和音频,协调视频和音频的输入和输出流

@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;//输出静态影像

@property (nonatomic, strong) AVCaptureDevice             *device;//主要用来获取iphone一些关于相机设备的属性
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;//预览图层layer

```

这里将相机的控件以及相机的实时显示的图层放在一个视图类ZTImagePickerOverLayView中，拍完照后的图层放在另外一个类ZTImagePickerPreImageView中,各个视图间的协调及部分逻辑放在控制器中ZTImagePickerController。封装完整个相机不过用了几百行代码。

1.初始化
```
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

```
2.添加手势
给预览层添加捏合手势控制放大缩小,添加点击手势来聚焦
```
 UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.preview addGestureRecognizer:pinch];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(focusAction:)];
    [self.preview addGestureRecognizer:tap];

```

3.给控件添加响应事件
闪光灯打开、关闭、自动，摄像头切换、取消、拍照、重新拍照、使用照片等按钮添加响应事件
```
[self.preview.cameraSwitchButton addTarget:self action:@selector(switchCameraSegmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashAutoButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashOpeanButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preview.flashCloseButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.takePictureButton addTarget:self action:@selector(takePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preview.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preImageView.reTakeButton addTarget:self action:@selector(retakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preImageView.useImageButton addTarget:self action:@selector(useImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];

```
4.闪光灯控制
```
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

```

5.前后摄像头切换
```
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

```

6.拍照
```
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
```

7.放大缩小
```
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
```

8.照片方向修正
拍完照的时候，拍出的照片你会发现呈现的方向不对，需要对照片的方向进行修正。
```
 AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}
```
这里需要注意的是如果想要拍完照的效果和UIimagePickerController的效果一样，即在横屏下拍完照，照片要旋转显示并且显示的小一些，那么就要对拍完照预览图层进行修改。

图片

在预览图层中修改imageview的大小。(这部分代码我并没有加到demo中，如果想实现拍完照后照片的方向与系统相机的一样，可以在ZTImagePickerPreImageView中加上)
```
- (void)changeImageViewFrameIfNeeded:(UIDeviceOrientation)orientation{
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight){
    
        self.imageView.frame = CGRectMake(0, 0, self.width, 240 * [UIScreen mainScreen].bounds.size.width / 320.0);
        self.imageView.centerY = self.height / 2.0;
    }else{
        _imageView.frame = CGRectMake(0, 0, self.width, 418 * [UIScreen mainScreen].bounds.size.width / 320.0);
        _imageView.centerY = self.height / 2.0;
    }
}
```

仅仅是这样还不够，还要对设备方向的获取进行改进。
通常我们获取设备方向是通过[[UIDevice currentDevice] orientation] 或者通过[UIApplication sharedApplication].statusBarOrientation的方式来获取。但这两种方式有一个缺点，在竖排方向开关关闭的时候，获取到的方向是正确的，在开关打开的时候获取到的方向是竖直方向，在横屏等情况下获取的方向不正确。这时候就要通过CMMotionManager来获取方向了。(下面这段代码也没有加到demo中，如果有这样的功能需求，可以在ZTImagePickerController中加上这段代码)
```
- (void)p_startMotionManager{
    self.deviceOrientation = UIDeviceOrientationPortrait;
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
    }
}

- (void)p_stopMonotionManager{
    [_motionManager stopDeviceMotionUpdates];
    _motionManager = nil;
}
```

二、添加水印
如果要实现类似腾讯的水印相机形式的水印，需要对水印专门做一个图层来进行管理。将水印图层放在相机的最上层就可以实时看到水印了，并且可以左右切换水印。这里使用scrollview来容纳每种水印样式，如果水印样式比较多当然可以使用collectionView来容纳。

为了让水印图层的手势(scrollView的左右滑动，每种水印样式视图中的控件响应手势)响应不与相机图层的手势响应不冲突，在水印图层可以将手势进行拦截，根据实际情况来返回响应手势的视图控件。

```
这里的代码根据实际情况修改
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    CGPoint tempPoint = [self.reportView convertPoint:point fromView:self];
    if(CGRectContainsPoint(self.reportView.reportTypeLb.frame, tempPoint)){
        view = self.reportView.reportTypeLb;
        return view;
    }
    
    NSInteger left = 0,top = 0, height = 0,width = self.contentSize.width;
     height = MAX(self.reportView.xmNameLb.top, self.handleProblemView.userLb.top);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        left = self.height - height;
        width = self.width;
    }

    if(CGRectContainsPoint(CGRectMake(left, top, width, height), point)){
            view = [self.superview.subviews objectAtIndex:0];
            view = [view hitTest:point withEvent:event];
        }else{

    }
    return view;
}
```

拍完照选择好水印样式后，将水印样式用的空间绘制到照片上，就形成了水印照片

```
- (UIImage *)markedImageWithType:(XBWaterMark )waterMarkType date:(NSDate *)date user:(NSString *)user placLocation:(ZTLocationModel *)locationModel withPhone:(NSString *)phone xmType:(NSString *)xmType{
    
    if (self.size.width == 0.0 || self.size.height == 0.0) return nil;
    
    UIImage *defaultImage = nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if(scale >= 3) scale = 2;
    
    UIImage *image = [self thumbnailForMaxWidth:1024/scale maxHeight:1024/scale];
    
    CGSize newSize = CGSizeMake(image.size.width*image.scale/scale, image.size.height*image.scale/scale);
    
    UIView *waterMarkView = [self p_markWaterMarkView:waterMarkType date:date user:user
                                            placLocation:locationModel  withPhone:phone newSize:newSize xmType:xmType];
    //将水印样式中的控件绘制到图片
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [image drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
    
    for (UIView *view in waterMarkView.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            UIImageView *iv = (UIImageView *)view;
            [iv.image drawInRect:CGRectMake(iv.left,iv.top, iv.width, iv.height)];
        }else if ([view isKindOfClass:[UILabel class]]){
            UILabel *lb = (UILabel *)view;
            UIImage *lbImage = [lb imageByRenderingView];
            [lbImage drawInRect:CGRectMake(lb.left, lb.top, lb.width, lb.height)];
        }
    }
    
    CGContextRestoreGState(context);
    
    defaultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return defaultImage;
}

```

效果图

![自定义水印相机.gif](http://upload-images.jianshu.io/upload_images/1716542-469450e831aebc08.gif?imageMogr2/auto-orient/strip)

自定义相机[demo](https://github.com/ZT0526/ZTImagePicker)
