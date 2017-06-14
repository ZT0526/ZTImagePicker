//
//  UIImage+XIMAddition.h
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxThumbnailHeight 124.0
#define kMaxThumbnailWidth 105.0

@interface UIImage (XIMAddition)

- (UIImage *)thumbnailForMaxWidth:(CGFloat)maxWith maxHeight:(CGFloat)maxHeight;

- (UIImage *)orientationFixedImageUsingOrientation:(UIImageOrientation)orientation;

- (UIImage *)orientationFixedImage;

@end
