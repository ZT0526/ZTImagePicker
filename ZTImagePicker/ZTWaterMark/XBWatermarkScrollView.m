//
//  XBWatermarkScrollView.m
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "XBWatermarkScrollView.h"
#import "XBWaterTypeWorkReportView.h"
#import "XBWaterTypeHandleProblemView.h"
#import "XBWaterMarkModel.h"

#import "NSDate+FWAddition.h"



@interface XBWatermarkScrollView()<XBWaterTypeWorkReportViewDelegate>{
    BOOL firstSetTost;
}

@property (nonatomic , strong) XBWaterTypeHandleProblemView *handleProblemView;

@property (nonatomic , strong) CAShapeLayer *border;

@end

@implementation XBWatermarkScrollView

- (instancetype)init{
    if(self = [super init]){
        self.bounces = NO;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.xmReportType = @"路面冲洗";
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //[self p_config];
        self.xmReportType = @"路面冲洗";
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.reportView layoutSubviews];
    [self.handleProblemView layoutSubviews];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    CGPoint tempPoint = [self.reportView convertPoint:point fromView:self];
    if(CGRectContainsPoint(self.reportView.reportTypeLb.frame, tempPoint)){
        view = self.reportView.reportTypeLb;
        return view;
    }
    
    NSInteger left = 0,top = 0, height = 0,width = self.contentSize.width;
     height = MAX(self.reportView.xmNameLb.top, self.handleProblemView.userLb.top);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        left = self.height - height;
        width = self.width;
    }

    if(CGRectContainsPoint(CGRectMake(left, top, width, height), point)){
            view = [self.superview.subviews objectAtIndex:0];
            view = [view hitTest:point withEvent:event];
        }else{

    }
    
    return view;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self p_config];
    
    if(self.reportView.model == nil){
        XBWaterMarkWorkReportModel *reportModel = [XBWaterMarkWorkReportModel new];
        reportModel.reportType = @"去打扫卫生";
        reportModel.departMent = @"张三";
        reportModel.date = [NSDate date];
        reportModel.placMark = @"位置获取中";
        self.reportView.model = reportModel;
    }
    
    if(self.handleProblemView.model == nil){
        XBWaterMarkHandleProblemModel *problemModel = [XBWaterMarkHandleProblemModel new];
        problemModel.userName = @"李四";
        problemModel.date = [NSDate date];
        problemModel.placMark = @"位置获取中";
        self.handleProblemView.model = problemModel;
    }
    
    
}

- (void)setXmReportType:(NSString *)xmReportType{
    _xmReportType = xmReportType;
    
    XBWaterMarkWorkReportModel *reportModel = self.reportView.model;
    reportModel.reportType = _xmReportType;
    self.reportView.model = reportModel;
    
    if(self.border){
        self.border.path = [UIBezierPath bezierPathWithRect:self.reportView.reportTypeLb.bounds].CGPath;
    }
    
}

- (void)setDefaultPlacemark:(NSString *)placemark departMentplaceMark:(NSString *)departMentplaceMark{
    _deFaultPlacemark = [placemark copy];
    _departMentPlacemark = [departMentplaceMark copy];
    
    self.reportView.model.placMark = departMentplaceMark.length > 0 ? departMentplaceMark : @"位置获取中";
    self.handleProblemView.model.placMark = placemark.length > 0 ? placemark : @"位置获取中";
    
    self.reportView.model = self.reportView.model;
    self.handleProblemView.model = self.handleProblemView.model;
    
}

- (void)setWaterMarkType:(XBWaterMark)waterMarkType{
    _waterMarkType = waterMarkType;
    
    for (CALayer *layer in self.reportView.reportTypeLb.layer.sublayers) {
        if([layer isKindOfClass:[CAShapeLayer class]]) [layer removeFromSuperlayer];
    }
    
    if(_waterMarkType == XBWaterMarkDepartMent){
        firstSetTost = YES;
        
        if(firstSetTost){
            self.border = [CAShapeLayer layer];
            
            self.border.strokeColor = [UIColor whiteColor].CGColor;
            
            self.border.fillColor = nil;
            
            self.border.frame = self.bounds;
            
            self.border.lineWidth = 2.f;
            
            self.border.lineCap = @"square";
            
            self.border.lineDashPattern = @[@2, @4];
            self.border.hidden = YES;
            
            
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGRect rect = self.reportView.reportTypeLb.bounds;
                weakSelf.border.path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x - 2, rect.origin.y - 2, rect.size.width + 4, rect.size.height + 4)].CGPath;
                
                [UIView animateWithDuration:1.0 animations:^{
                    weakSelf.border.hidden = NO;
                    [weakSelf.reportView.reportTypeLb.layer addSublayer:self.border];
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:1.0 animations:^{
                        weakSelf.border.hidden = YES;
                        CGRect rect = weakSelf.reportView.reportTypeLb.bounds;
                        weakSelf.border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
                    }completion:^(BOOL finished) {
                        [weakSelf.border removeFromSuperlayer];
                        
                    }];
                    
                    if(weakSelf.waterMarkType == XBWaterMarkDepartMent )
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            if(weakSelf.waterMarkType == XBWaterMarkDepartMent ){
                                
                                CGRect rect = weakSelf.reportView.reportTypeLb.bounds;
                                weakSelf.border.path = [UIBezierPath bezierPathWithRect:CGRectMake(rect.origin.x - 2, rect.origin.y - 2, rect.size.width + 4, rect.size.height + 4)].CGPath;
                                
                                [UIView animateWithDuration:1.0 animations:^{
                                    weakSelf.border.hidden = NO;
                                    [weakSelf.reportView.reportTypeLb.layer addSublayer:weakSelf.border];
                                }];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [UIView animateWithDuration:1.0 animations:^{
                                        weakSelf.border.hidden = YES;
                                        CGRect rect = weakSelf.reportView.reportTypeLb.bounds;
                                        weakSelf.border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
                                    }completion:^(BOOL finished) {
                                        [weakSelf.border removeFromSuperlayer];
                                        weakSelf.border = nil;
                                    }];
                                });
                            }
                            
                        });
                });
                
                
            });
        }
    }else{
        if(self.border){
           [self.border removeFromSuperlayer];
            self.border = nil;
        }
    }
}

#pragma mark Private Methods
- (void)p_config{
    
    
    self.handleProblemView.frame = CGRectMake(0, 0, self.width, self.height);
    
    self.reportView.frame = CGRectMake(self.width, 0, self.width, self.height);
    
    
}


#pragma mark setters && getters

- (XBWaterTypeWorkReportView *)reportView{
    if(_reportView == nil){
        _reportView = [XBWaterTypeWorkReportView new];
        _reportView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_reportView];
    }
    
    return _reportView;
}

- (XBWaterTypeHandleProblemView *)handleProblemView{
    if(_handleProblemView == nil){
        _handleProblemView = [XBWaterTypeHandleProblemView new];
        _handleProblemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_handleProblemView];
    }
    
    return _handleProblemView;
}


@end
