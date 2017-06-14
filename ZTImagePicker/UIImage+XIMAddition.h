//
//  UIImage+XIMAddition.h
//  XBIMKit
//
//  Created by Peter Zhang on 13-10-28.
//  Copyright (c) 2013年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxThumbnailHeight 124.0
#define kMaxThumbnailWidth 105.0

@interface UIImage (XIMAddition)

- (UIImage *)thumbnailForMaxWidth:(CGFloat)maxWith maxHeight:(CGFloat)maxHeight;

- (UIImage *)orientationFixedImageUsingOrientation:(UIImageOrientation)orientation;

- (UIImage *)orientationFixedImage;

@end
