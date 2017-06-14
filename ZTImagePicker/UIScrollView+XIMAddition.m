
#import "UIScrollView+XIMAddition.h"
#import <objc/runtime.h>

const CGPoint CGPointUndefined = {-2000.0, -2000.0};

@implementation UIScrollView (XIMAddition)

- (CGPoint)targetContentOffset
{
  NSValue *value = objc_getAssociatedObject(self, "target_content_offset");
  
  return value ? value.CGPointValue : CGPointUndefined;
}

- (void)setTargetContentOffset:(CGPoint)targetContentOffset
{
  NSValue *value = [NSValue valueWithCGPoint:targetContentOffset];
  objc_setAssociatedObject(self, "target_content_offset", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setContentInset:(UIEdgeInsets)contentInset adjustingOffset:(BOOL)adjust
{
    CGPoint originContentOffset = self.contentOffset;
    
    self.contentInset = contentInset;
    if (!adjust) self.contentOffset = originContentOffset;
}

- (void)setContentSize:(CGSize)contentSize adjustingOffset:(BOOL)adjust
{
    CGPoint originContentOffset = self.contentOffset;
    
    self.contentSize = contentSize;
    if (!adjust) self.contentOffset = originContentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated targeted:(BOOL)targeted
{
    [self setContentOffset:contentOffset animated:animated];
    if (targeted) {
        self.targetContentOffset = contentOffset;
    }
}

- (CGPoint)contentOffsetAtBottom
{
    CGFloat visibleHeight = MIN(CGRectGetHeight(self.bounds), self.contentSize.height) - self.contentInset.bottom;
    CGFloat bottomOriginY = self.contentSize.height - visibleHeight;
    return CGPointMake(0.0, bottomOriginY);
}

- (void)scrollToTopAnimated:(BOOL)animated
{
  [self setContentOffset:CGPointMake(0.0, 0.0) animated:animated targeted:YES];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
  [self setContentOffset:self.contentOffsetAtBottom animated:animated targeted:YES];
}

- (void)scrollToBottomWhenBottomHeight:(CGFloat)bottomHeight animated:(BOOL)animated
{
    // otherwise we should move the scroll to the bottom first and change contentInset.
    if (self.contentInset.bottom != bottomHeight) {
        CGFloat contentHeight = MIN(self.contentSize.height, CGRectGetHeight(self.bounds));
        CGFloat blankHeight = CGRectGetHeight(self.bounds) - contentHeight;
        CGFloat insetBottom = ABS(MIN(0.0, blankHeight - bottomHeight));
        
        UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, insetBottom, 0.0);
        
        [self setContentInset:contentInset adjustingOffset:NO];
    }
    [self scrollToBottomAnimated:animated];
}

@end
