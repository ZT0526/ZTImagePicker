

#import "UIImage+FWAddition.h"

#import "UIImage+XIMAddition.h"
#import "UIView+Category.h"
#import "XBWaterTypeWorkReportView.h"
#import "XBWaterTypeHandleProblemView.h"
#import "XBWaterMarkModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (FWAddition)

+ (instancetype)separatorImage
{
    return [UIImage imageNamed:@"gen_list_line"];
}

+ (instancetype)resizableRoundButtonImage
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 20.0, 24.0, 20.0);
    return [[UIImage imageNamed:@"btn_round_80h"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableRoundButtonImageHighlighted
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 21.0, 24.0, 21.0);
    return [[UIImage imageNamed:@"btn_round_80h_p"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableLeftButtonImage
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 20.0, 24.0, 2.0);
    return [[UIImage imageNamed:@"btn_left_80h"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableLeftButtonImageHighlighted
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 20.0, 24.0, 2.0);
    return [[UIImage imageNamed:@"btn_left_80h_p"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableRightButtonImage
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 2.0, 24.0, 20.0);
    return [[UIImage imageNamed:@"btn_right_80h"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableRightButtonImageHighlighted
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24.0, 2.0, 24.0, 20.0);
    return [[UIImage imageNamed:@"btn_right_80h_p"] resizableImageWithCapInsets:insets];
}

+ (instancetype)resizableFormCellTopImage
{
    return [[UIImage imageNamed:@"gen_table_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 10.0, 1.0, 10.0)];
}

+ (instancetype)resizableFormCellMiddleImage
{
    return [[UIImage imageNamed:@"gen_table_middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 1.0, 2.0)];
}

+ (instancetype)resizableFormCellBottomImage
{
    return [[UIImage imageNamed:@"gen_table_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 15.0, 10.0)];
}

+ (instancetype)resizableFormCellSingleImage
{
    return [[UIImage imageNamed:@"gen_table_single"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 10.0, 15.0, 10.0)];
}

+ (instancetype)thumbnailAvatarPlaceholder
{
    return [UIImage imageNamed:@"default_avatar_user"];
}

- (UIImage *)thumbnailWithSize:(CGSize)asize
{
    UIImage *newimage;
    
    if (nil == self) {
        
        newimage = nil;
    } else {
        
        UIGraphicsBeginImageContext(asize);
        
        [self drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (UIImage *)markedImageWithType:(XBWaterMark )waterMarkType date:(NSDate *)date user:(NSString *)user placLocation:(ZTLocationModel *)locationModel withPhone:(NSString *)phone xmType:(NSString *)xmType{
    
    if (self.size.width == 0.0 || self.size.height == 0.0) return nil;
    
    UIImage *defaultImage = nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if(scale >= 3) scale = 2;
    
    UIImage *image = [self thumbnailForMaxWidth:1024/scale maxHeight:1024/scale];
    
    CGSize newSize = CGSizeMake(image.size.width*image.scale/scale, image.size.height*image.scale/scale);
    
    UIView *waterMarkView = [self p_markWaterMarkView:waterMarkType date:date user:user
                                            placLocation:locationModel  withPhone:phone newSize:newSize xmType:xmType];
    
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

- (UIView *)p_markWaterMarkView:(XBWaterMark )waterMarkType date:(NSDate *)date user:(NSString *)user placLocation:(ZTLocationModel *)locationModel withPhone:(NSString *)phone newSize:(CGSize )newSize xmType:(NSString *)xmType{
    UIView *waterMarkView = nil;
    if(waterMarkType == XBWaterMarkDepartMent){
        XBWaterTypeWorkReportView *reportView = [[XBWaterTypeWorkReportView alloc]
                                                 initWithFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
        XBWaterMarkWorkReportModel *model = [XBWaterMarkWorkReportModel new];
        model.date = date;
        model.departMent = user;
        model.placMark = locationModel.reformattedAddress;
        model.reportType = xmType;
        reportView.vertcalSpace = 10;
        reportView.model = model;
        [reportView layoutSubviews];
        waterMarkView = reportView;
        
    }else if(waterMarkType == XBWaterMarkDefault){
        XBWaterTypeHandleProblemView *problemView = [[XBWaterTypeHandleProblemView alloc] initWithFrame:
                                                     CGRectMake(0, 0, newSize.width, newSize.height)];
        XBWaterMarkHandleProblemModel *model = [XBWaterMarkHandleProblemModel new];
        model.userName = user;
        model.placMark = locationModel.placemark;
        model.date = date;
        problemView.vertcalSpace = 10;
        problemView.model = model;
        [problemView layoutSubviews];
        waterMarkView = problemView;
    }
    
    return waterMarkView;
}


//- (UIImage *)markedImageWithDate:(NSDate *)date user:(NSString *)user type:(NSString *)type placemark:(NSString *)placemark withPhone:(NSString *)phone
//{
//    if (self.size.width == 0.0 || self.size.height == 0.0) return nil;
//    
//    NSMutableString *textToDraw = [NSMutableString new];
//    if (date) {
//        [textToDraw appendFormat:@"%@, ", date.timeStringUsedToMark];
//    }
//    if (user.length) {
//        [textToDraw appendFormat:@"%@, ", user];
//    }
//    if (phone.length) {
//        [textToDraw appendFormat:@"%@, ",phone];
//    }
//    if (type.length) {
//        [textToDraw appendFormat:@"%@, ", type];
//    }
//    if (textToDraw.length >= 2) {
//        [textToDraw deleteCharactersInRange:NSMakeRange(textToDraw.length - 2, 2)];
//    }
//    if (placemark) {
//        [textToDraw appendFormat:@"\n%@", placemark];
//    }
//    
//    return [self markedImageWithText:textToDraw];
//}

- (UIImage *)markedImageWithText:(NSString *)text
{
    if (text.length == 0) return nil;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *image = [self thumbnailForMaxWidth:1024/scale maxHeight:1024/scale];
    
    CGSize newSize = CGSizeMake(image.size.width*image.scale/scale, image.size.height*image.scale/scale);
    
    CGFloat maxTextWidth = MIN(600/scale, newSize.width - 80/scale);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:30/[UIScreen mainScreen].scale], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: style, NSBackgroundColorAttributeName:[UIColor clearColor]};
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxTextWidth, 200/scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    UIImage *resultImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [image drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
    CGRect backgroundRect = CGRectMake((newSize.width - textSize.width) / 2.0 - 20.0/scale, newSize.height - textSize.height - 40/scale, textSize.width + 40.0/scale, textSize.height + 32/scale);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:backgroundRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(14/scale, 14/scale)];
    [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6] setFill];
    [path fill];
    
    CGFloat margenX = 20.0/scale;
    CGFloat margenY = 16.0/scale;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
        l.font = [UIFont systemFontOfSize:30/[UIScreen mainScreen].scale];
        l.textColor = [UIColor whiteColor];
        l.lineBreakMode = NSLineBreakByWordWrapping;
        l.numberOfLines = 0;
        l.backgroundColor = [UIColor clearColor];
        l.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        UIImage *textImage = [l imageByRenderingView];
        [textImage drawAtPoint:CGPointMake(margenX + backgroundRect.origin.x, margenY + backgroundRect.origin.y)];
    } else {
        [text drawWithRect:CGRectMake(margenX + backgroundRect.origin.x, margenY + backgroundRect.origin.y, backgroundRect.size.width - margenX*2, backgroundRect.size.height - margenY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    }
    
    CGContextRestoreGState(context);
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)getImageFromRect:(CGRect)rect
{
    //大图bigImage
    //定义myImageRect，截图的{quyu}
    CGRect myImageRect = rect;
    
    UIImage* bigImage= self;
    
    CGImageRef imageRef = bigImage.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size;
    
    size.width = rect.size.width;
    
    size.height = rect.size.height;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (NSString*)alarmPhotoPath {
    return @"hahaha";
}

+ (NSString*)tempPhotoPath {
    NSString *photoPath = NSTemporaryDirectory();
    
    return photoPath;
}

+ (void)deleteAlarmPhotoAlbum {
    [[NSFileManager defaultManager] removeItemAtPath:[self alarmPhotoPath] error:nil];
}

- (void)saveImageToAlarmPhotoAlbum {
    [self saveImageToAlarmPhotoAlbumWithQuality:0.3f];
}


- (void)saveImageToAlarmPhotoAlbumWithQuality:(CGFloat)quality {
    NSString *photoPath = [self.class alarmPhotoPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photoPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:photoPath withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:photoPath isDirectory:YES]];
    }
    UIImage *thumbImage = [self thumbnailForMaxWidth:240 maxHeight:240];
    NSData *data = UIImageJPEGRepresentation(self, quality);
    NSData *thumbData = UIImageJPEGRepresentation(thumbImage, quality);
    NSString *imageName = [[@((long long)[[NSDate date] timeIntervalSince1970]) description] stringByAppendingString:@".jpg"];
    NSString *thumbImageName = [imageName stringByAppendingString:@".thumb"];
    [data writeToFile:[photoPath stringByAppendingPathComponent:imageName] atomically:YES];
    [thumbData writeToFile:[photoPath stringByAppendingPathComponent:thumbImageName] atomically:YES];
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageMaskWithColor:(UIColor *)maskColor {
    if (!maskColor) {
        return nil;
    }
    
    UIImage *newImage = nil;
    
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, maskColor.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
