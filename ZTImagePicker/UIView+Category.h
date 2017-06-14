
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
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
