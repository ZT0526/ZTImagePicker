//
//  XBImagePickerController.m
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "XBImagePickerController.h"
#import "XBWaterTypeWorkReportView.h"

#import "UIImage+FWAddition.h"



#import <UIImage+XIMAddition.h>
#import <NSFileManager+XIMAddition.h>





@interface XBImagePickerController ()<UIScrollViewDelegate,XBWatermarkScrollViewDlegate>{
    NSInteger buttomBarHeight;
    NSInteger topBarHeight;
}

@property (nonatomic, strong) NSMutableArray *photoItems;


@property (nonatomic, copy) NSString *placemark;


@property (nonatomic , strong) UITextField                      *pageLb;

@property (nonatomic, assign) BOOL           canRotate;

@property (nonatomic, assign) BOOL           canTransForm;

@end

@implementation XBImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if(self.scrollView.hidden){
        [self showHiddenedView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self hiddenView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.canRotate) self.canRotate = NO;
    self.scrollView.frame = CGRectMake(0, topBarHeight, self.view.width,
                                       self.view.height - topBarHeight - buttomBarHeight);
    self.pageLb.frame = CGRectMake(self.view.width / 2.0 - 25, self.view.height - 37.5 - buttomBarHeight, 50, 25);
    //self.realCancelBtn.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    buttomBarHeight = self.preview.buttomBar.height;
    topBarHeight = self.preview.topbar.height;
    
}
#pragma mark Private Methods

- (void)p_config{
    [super p_config];
    
    [self scrollView];
    

    [self pageLb];
    
    self.photoItems = [NSMutableArray new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(albumTapAction:)];
    [self.preview.imageLibraryView addGestureRecognizer:tap];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
        UISwipeGestureRecognizer *swipGetureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipGetureAction:)];
        swipGetureRight.numberOfTouchesRequired = 1;
        swipGetureRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipGetureRight];
        
        
        UISwipeGestureRecognizer *swipGetureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(swipGetureAction:)];
        swipGetureLeft.numberOfTouchesRequired = 1;
        swipGetureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipGetureLeft];
        
        
        UISwipeGestureRecognizer *swipGetureTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(swipGetureAction:)];
        swipGetureTop.numberOfTouchesRequired = 1;
        swipGetureTop.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipGetureTop];
        
        UISwipeGestureRecognizer *swipGetureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(swipGetureAction:)];
        swipGetureDown.numberOfTouchesRequired = 1;
        swipGetureDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:swipGetureDown];
        
        [((UIView *)[self.view.subviews objectAtIndex:0]) becomeFirstResponder];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
}


#pragma mark actions
- (void)swipGetureAction:(UISwipeGestureRecognizer *)sender{
    
 
    
    if((sender.direction == UISwipeGestureRecognizerDirectionRight
        && [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft)||
       (sender.direction == UISwipeGestureRecognizerDirectionDown &&
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)){
           if(self.scrollView.contentOffset.x >= self.view.width){
               [UIView animateWithDuration:0.5 animations:^{
                   [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
                   
                   self.scrollView.waterMarkType = XBWaterMarkDefault;
               } completion:^(BOOL finished) {
                   self.waterMarkType = XBWaterMarkDefault;
               }];
               
           }
       }else if ((sender.direction == UISwipeGestureRecognizerDirectionLeft
                  && [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft) ||
                 (sender.direction == UISwipeGestureRecognizerDirectionUp &&
                  [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)){
                     [UIView animateWithDuration:0.5 animations:^{
                         [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, self.scrollView.contentOffset.y)
                                                  animated:YES];
                         
                         self.scrollView.waterMarkType = XBWaterMarkDepartMent;
                     } completion:^(BOOL finished) {
                         self.waterMarkType = XBWaterMarkDepartMent;
                     }];
                 }
    
}


- (void)albumTapAction:(id)sender{

}

- (void)hiddenView{
    self.scrollView.hidden = YES;
    self.pageLb.hidden = YES;
}

- (void)showHiddenedView{
    self.scrollView.hidden = NO;
    self.pageLb.hidden = NO;
}


#pragma mark Notifications
- (void)orientationDidChangeNotification:(NSNotification *)nti{
    NSLog(@"%@",nti.userInfo);
    
    if(self.canRotate) return;
    
    NSLog(@"%ld",(long)[UIDevice currentDevice].orientation);
    
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft && !self.canRotate){
        
        self.preImageView.imageView.frame = CGRectMake(0, 0, self.view.width, 240 * [UIScreen mainScreen].bounds.size.width / 320.0);
        self.preImageView.imageView.centerY = self.view.height / 2.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.scrollView.frame = CGRectMake(0, topBarHeight, self.view.height - topBarHeight - buttomBarHeight, self.view.height - topBarHeight - buttomBarHeight);
            if(self.waterMarkType == XBWaterMarkDepartMent )
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, self.scrollView.contentOffset.y)
                                         animated:YES];
            [self.scrollView layoutSubviews];
            //self.cameraViewTransform = CGAffineTransformMakeRotation(M_PI_2);
            
            
            self.pageLb.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.pageLb.frame = CGRectMake(12.5, self.view.centerY - 12.5, 25, 50);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
        
        self.preImageView.imageView.frame = CGRectMake(0, 0, self.view.width, 427 * [UIScreen mainScreen].bounds.size.width / 320.0);
        self.preImageView.imageView.centerY = self.view.height / 2.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.transform = CGAffineTransformIdentity;
            self.scrollView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height - topBarHeight - buttomBarHeight);
            [self.scrollView layoutSubviews];
            
    
            
            self.pageLb.transform = CGAffineTransformIdentity;
            self.pageLb.frame = CGRectMake(self.view.width / 2.0 - 25, self.view.height - 37.5 - buttomBarHeight, 50, 25);
        } completion:^(BOOL finished) {
            
        }];
    }
    

    
}

#pragma mark XBWaterTypeWorkReportViewDelegate
- (void)reportTypeViewDidShow{
        [UIView animateWithDuration:0.3 animations:^{
        if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
            self.pageLb.hidden = YES;
            
        }else{
            self.pageLb.hidden = YES;
            
        }
    } completion:^(BOOL finished) {
       
    }];
}

- (void)reportTypeViewDidHidden{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pageLb.hidden = NO;
            
    } completion:^(BOOL finished) {
        
    }];
}

- (void)waterMarkFixed{
    self.scrollView.transform = CGAffineTransformIdentity;
    self.scrollView.frame = CGRectMake(0, topBarHeight, self.view.width, self.view.height - topBarHeight - buttomBarHeight);
    [self.scrollView layoutSubviews];
    
    
    self.pageLb.transform = CGAffineTransformIdentity;
    self.pageLb.frame = CGRectMake(self.view.width / 2.0 - 25, self.view.height - 37.5 - buttomBarHeight, 50, 25);
    
    self.canRotate = YES;
}

- (void)waterMarkUnFixed{
    self.preImageView.imageView.frame = CGRectMake(0, 0, self.view.width, 427 * [UIScreen mainScreen].bounds.size.width / 320.0);
    self.preImageView.imageView.centerY = self.view.height / 2.0;
    self.canRotate = NO;
}


#pragma  mark setters && getters
- (void)setWaterMarkType:(XBWaterMark)waterMarkType{
    _waterMarkType = waterMarkType;
    
    if(_waterMarkType == XBWaterMarkDefault){
        self.pageLb.text = @"1/2";
    }else{
        self.pageLb.text = @"2/2";
    }
}

- (XBWatermarkScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [XBWatermarkScrollView new];
        _scrollView.waterDelegate = self;
        //_scrollView.userInteractionEnabled = NO;
        _scrollView.frame = CGRectMake(0, 40, self.view.width, self.view.height - 40 - 101);
        _scrollView.contentSize = CGSizeMake(self.scrollView.width * 2, self.scrollView.height);
        _scrollView.reportView.delegate = self;
        [_scrollView removeGestureRecognizer:_scrollView.pinchGestureRecognizer];
        _scrollView.scrollEnabled = NO;
        _scrollView.waterMarkType = XBWaterMarkDefault;
        [self.view addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UITextField *)pageLb{
    if(_pageLb == nil){
        _pageLb = [UITextField new];
        _pageLb.backgroundColor = [UIColor blackColor];
        _pageLb.frame = CGRectMake(self.view.width / 2.0 - 25, self.view.height - 37.5 - 101, 50, 25);
        _pageLb.textColor = [UIColor whiteColor];
        _pageLb.font = [UIFont systemFontOfSize:15.0];
        _pageLb.textAlignment = NSTextAlignmentCenter;
        _pageLb.text = @"1/2";
        _pageLb.layer.cornerRadius = 12.5;
        _pageLb.userInteractionEnabled = NO;
        
        [self.view addSubview:_pageLb];
    }
    
    return _pageLb;
}

@end
