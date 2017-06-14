//
//  XBImagePickerController.h
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWatermarkScrollView.h"
#import "ZTImagePickerController.h"

@interface XBImagePickerController : ZTImagePickerController

@property (nonatomic , strong) XBWatermarkScrollView *scrollView;
@property (nonatomic, assign) XBWaterMark waterMarkType;

- (void)showHiddenedView;

@end
