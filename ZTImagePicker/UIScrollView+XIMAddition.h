

#import <UIKit/UIKit.h>

extern const CGPoint CGPointUndefined;

@interface UIScrollView (XIMAddition)

@property (nonatomic, assign) CGPoint targetContentOffset;

- (CGPoint)contentOffsetAtBottom;

/** UIScrollView will internally modify contentOffset property when contentInset/contentSize
 is changed. If you don't want this behaviour happen, you can set contentOffset on the same runLoop.
 These two methods are a hack solution on this.
 */
- (void)setContentInset:(UIEdgeInsets)contentInset adjustingOffset:(BOOL)adjust;
- (void)setContentSize:(CGSize)contentSize adjustingOffset:(BOOL)adjust;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated targeted:(BOOL)targeted;

- (void)scrollToTopAnimated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)scrollToBottomWhenBottomHeight:(CGFloat)bottomHeight animated:(BOOL)animated;

@end
