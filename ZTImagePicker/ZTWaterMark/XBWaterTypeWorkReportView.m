//
//  XBWaterTypeWorkReportView.m
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "XBWaterTypeWorkReportView.h"
#import "NSDate+FWAddition.h"

@interface XBWaterTypeWorkReportView ()

@property (nonatomic, assign) BOOL  isShowing;

@end

@implementation XBWaterTypeWorkReportView

- (instancetype)init{
    if(self = [super init]){
        [self p_config];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self p_config];
        
    }
    
    return self;
}

- (void)p_config{
    [self xmNameLb];
    [self locationIcon];
    [self locationLb];
    [self timeIcon];
    [self timeLb];
    [self reportTypeLb];
    self.vertcalSpace = 10;
    
}

- (void)tapAction:(id)sender{
//    self.isShowing = !self.isShowing;
    
//    if(self.isShowing){
        if([self.delegate respondsToSelector:@selector(reportTypeViewDidShow)])
            [self.delegate reportTypeViewDidShow];
//    }else{
//        if([self.delegate respondsToSelector:@selector(reportTypeViewDidHidden)])
//            [self.delegate reportTypeViewDidHidden];
//    }
}

- (void)setModel:(XBWaterMarkWorkReportModel *)model{
    _model = model;
    
    self.xmNameLb.text =  [NSString stringWithFormat:@"%@ . ",model.departMent.length > 0 ?
                           model.departMent : @"部门"];;
    self.locationLb.text = model.placMark.length > 0 ? model.placMark : @"位置获取中";
    self.timeLb.text = model.date.timeStringUsedToMark;
    self.reportTypeLb.text = model.reportType.length > 0 ? model.reportType : @"选择";
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height;
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) height = 320;
//    else
    height = self.height;
    
    [self.timeLb sizeToFit];
    self.timeLb.left = 10 + 10.5 + 5;
    self.timeLb.width = self.width - self.timeLb.left - 10;
    self.timeLb.bottom = height - 50;
    
    self.timeIcon.frame = CGRectMake(10, height - 15 - 10.5,
                                     10.5, 10.5);
    self.timeIcon.centerY = self.timeLb.centerY;
    
    [self.locationLb sizeToFit];
    self.locationLb.left = 10 + 10.5 + 5;
    self.locationLb.width = self.width - self.locationLb.left - 10;
    self.locationLb.bottom = MIN(self.timeIcon.top, self.timeLb.top) - self.vertcalSpace;
    
    self.locationIcon.frame = CGRectMake(10, self.locationLb.top, 10.5, 12.5);
    self.locationIcon.centerY = self.locationLb.centerY;
    
    [self.xmNameLb sizeToFit];
    self.xmNameLb.left = 10;
    self.xmNameLb.bottom = MIN(self.locationIcon.top, self.locationLb.top) - self.vertcalSpace;
    
    [self.reportTypeLb sizeToFit];
    self.reportTypeLb.left = self.xmNameLb.right + 1;
    self.reportTypeLb.width = MIN(self.width - self.xmNameLb.right - 10 -1, self.reportTypeLb.width);
    
    self.reportTypeLb.centerY = self.xmNameLb.centerY;
}


#pragma mark setters && getters
- (UILabel *)xmNameLb{
    if(_xmNameLb == nil){
        _xmNameLb = [UILabel new];
        _xmNameLb.textColor = [UIColor whiteColor];
        _xmNameLb.font = [UIFont systemFontOfSize:16.0];
        _xmNameLb.frame = CGRectMake(10, self.height - 138, 80, 30);
        _xmNameLb.shadowColor = [UIColor grayColor];
        _xmNameLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_xmNameLb];
    }
    
    return _xmNameLb;
}

- (UILabel *)reportTypeLb{
    if(_reportTypeLb == nil){
        _reportTypeLb = [UILabel new];
        _reportTypeLb.textColor = [UIColor whiteColor];
        _reportTypeLb.font = [UIFont systemFontOfSize:16.0];
        _reportTypeLb.frame = CGRectMake(10, self.height - 138, 80, 30);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(tapAction:)];
        [_reportTypeLb addGestureRecognizer:tap];
        _reportTypeLb.shadowColor = [UIColor grayColor];
        _reportTypeLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_reportTypeLb];
    }
    
    return _reportTypeLb;
}

- (UIImageView *)locationIcon{
    if(_locationIcon == nil){
        _locationIcon = [[UIImageView alloc] init];
        _locationIcon.frame = CGRectMake(10, self.xmNameLb.bottom + 10, 10.5, 12.5);
        _locationIcon.image = [UIImage imageNamed:@"icon_location"];
        _locationIcon.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _locationIcon.layer.shadowColor = [UIColor grayColor].CGColor;
        _locationIcon.layer.shadowOpacity = 0.5;
        [self addSubview:_locationIcon];
    }
    return _locationIcon;
}

- (UILabel *)locationLb{
    if(_locationLb == nil){
        _locationLb = [UILabel new];
        _locationLb.numberOfLines = 0;
        _locationLb.textColor = [UIColor whiteColor];
        _locationLb.font = [UIFont systemFontOfSize:16.0];
        _locationLb.frame = CGRectMake(self.locationIcon.right + 5, self.xmNameLb.bottom + 10 , 80, 30);
        _locationLb.shadowColor = [UIColor grayColor];
        _locationLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_locationLb];
    }
    
    return _locationLb;
}

- (UIImageView *)timeIcon{
    if(_timeIcon == nil){
        _timeIcon = [[UIImageView alloc] init];
        _timeIcon.frame = CGRectMake(10, self.locationIcon.bottom + 10, 10.5, 10.5);
        _timeIcon.image = [UIImage imageNamed:@"icon_time"];
        _timeIcon.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _timeIcon.layer.shadowColor = [UIColor grayColor].CGColor;
        _timeIcon.layer.shadowOpacity = 0.5;
        [self addSubview:_timeIcon];
    }
    
    return _timeIcon;
}

- (UILabel *)timeLb{
    if(_timeLb == nil){
        _timeLb = [UILabel new];
        _timeLb.textColor = [UIColor whiteColor];
        _timeLb.font = [UIFont systemFontOfSize:16.0];
        _timeLb.frame = CGRectMake(self.timeIcon.right + 5, self.locationIcon.bottom + 10 , 80, 30);
        _timeLb.numberOfLines = 0;
        _timeLb.shadowColor = [UIColor grayColor];
        _timeLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_timeLb];
    }
    
    return _timeLb;

}

@end
