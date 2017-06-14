//
//  UIView+Category.h
//  TestPro
//
//  Created by mac iko on 14-3-5.
//  Copyright (c) 2014年 mac iko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
//sets frame.origin.x = left;
@property (nonatomic) CGFloat left;
//sets frame.origin.y = top;
@property (nonatomic) CGFloat top;
//sets frame.origin.x = right - frame.size.wigth;
@property (nonatomic) CGFloat right;
//sets frame.origin.y = botton - frmae.size.height;
@property (nonatomic) CGFloat bottom;
//sets frame.size.width = width;
@property (nonatomic) CGFloat width;
//sets frame.size.height = height;
@property (nonatomic) CGFloat height;
//sets center.x = centerX;
@property (nonatomic) CGFloat centerX;
//sets center.y = centerY;
@property (nonatomic) CGFloat centerY;
//frame.origin
@property (nonatomic) CGPoint origin;
//frame.size
@property (nonatomic) CGSize size;
//包含这个view的controller
-(UIViewController *)viewcontroller;
-(void)removeAllSubviews;
-(void)setbackgroundImage:(UIImage *)img;

- (void)bringToFront;

- (UIImage *)imageByRenderingView;

@end
