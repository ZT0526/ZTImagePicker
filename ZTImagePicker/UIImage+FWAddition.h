//
//  UIImage+FWAddition.h
//  Fieldworks
//
//  Created by Peter Zhang on 14-4-17.
//  Copyright (c) 2014年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWatermarkScrollView.h"
#import "ZTLocationModel.h"
#import "NSFileManager+XIMAddition.h"

#define FW_BUTTON_SHADOW_OFFSET 4.0

@interface UIImage (FWAddition)

+ (instancetype)separatorImage;

+ (instancetype)resizableRoundButtonImage;
+ (instancetype)resizableRoundButtonImageHighlighted;

+ (instancetype)resizableLeftButtonImage;
+ (instancetype)resizableLeftButtonImageHighlighted;

+ (instancetype)resizableRightButtonImage;
+ (instancetype)resizableRightButtonImageHighlighted;

+ (instancetype)resizableFormCellTopImage;
+ (instancetype)resizableFormCellMiddleImage;
+ (instancetype)resizableFormCellBottomImage;
+ (instancetype)resizableFormCellSingleImage;

+ (instancetype)thumbnailAvatarPlaceholder;

- (UIImage *)thumbnailWithSize:(CGSize)asize ;
- (UIImage *)getImageFromRect:(CGRect)rect ;

- (UIImage *)markedImageWithDate:(NSDate *)date user:(NSString *)user type:(NSString *)type placemark:(NSString *)placemark withPhone:(NSString *)phone;

- (UIImage *)markedImageWithType:(XBWaterMark )waterMarkType date:(NSDate *)date user:(NSString *)user placLocation:(ZTLocationModel *)locationModel withPhone:(NSString *)phone xmType:(NSString *)xmType;
- (UIImage *)markedImageWithType:(XBWaterMark )waterMarkType parameters:(NSDictionary *)parameters;
- (UIImage *)p_makeWaterMarkDefaultTypeImageWithDate:(NSDate *)date user:(NSString *)user placemark:(NSString *)placemark withPhone:(NSString *)phone;

- (UIImage *)markedImageWithText:(NSString *)text;


- (UIImage *)imageMaskWithColor:(UIColor *)maskColor;

+ (NSString*)alarmPhotoPath;
+ (NSString*)tempPhotoPath;
+ (void)deleteAlarmPhotoAlbum;
- (void)saveImageToAlarmPhotoAlbum;
- (void)saveImageToCache:(NSString *)time;
- (void)saveImageToAlarmPhotoAlbumWithQuality:(CGFloat)quality;
+ (UIImage *)imageFromColor:(UIColor *)color;

@end
