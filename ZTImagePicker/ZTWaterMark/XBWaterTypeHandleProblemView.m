//
//  XBWaterTypeHandleProblemView.m
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "XBWaterTypeHandleProblemView.h"
#import "NSDate+FWAddition.h"

@implementation XBWaterTypeHandleProblemView

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

- (void)setModel:(XBWaterMarkHandleProblemModel *)model{
    _model = model;
    NSString *userStr;
    if(_model.userName.length > 0)
        userStr = [NSString stringWithFormat:@"%@，",_model.userName];
    if(_model.date)
        userStr = [NSString stringWithFormat:@"%@%@",userStr,_model.date.timeStringUsedToMark];
    
    _userLb.text = userStr;
    
    _locationLb.text = _model.placMark.length > 0 ? _model.placMark : @"位置获取中";
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height;
//    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) height = 320;
//    else
    height = self.height;
    
    [self.locationLb sizeToFit];
    self.locationLb.left = 10 + 10.5 + 5;
    self.locationLb.width = self.width - self.locationLb.left - 10;
    self.locationLb.bottom = height - 50;
    
    self.locationIcon.frame = CGRectMake(10, self.locationLb.top, 10.5, 12.5);
    self.locationIcon.centerY = self.locationLb.centerY;
    
    [self.userLb sizeToFit];
    self.userLb.left = 10 + 12 + 5;
    self.userLb.width = self.width - self.userLb.left - 10;
    self.userLb.bottom = MIN(self.locationLb.top, self.locationIcon.top) - self.vertcalSpace;
    
    self.userIcon.frame = CGRectMake(10, self.userLb.top, 12, 12);
    self.userIcon.centerY = self.userLb.centerY;
}


#pragma mark private Methods
- (void)p_config{
    [self locationIcon];
    [self locationLb];
    [self userIcon];
    [self userLb];
    
    self.vertcalSpace = 10;
}


#pragma mark setters && getters
- (UIImageView *)locationIcon{
    if(_locationIcon == nil){
        _locationIcon = [[UIImageView alloc] init];
        _locationIcon.frame = CGRectMake(10, self.height - 20, 10.5, 12.5);
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
        _locationLb.frame = CGRectMake(self.locationIcon.right + 5, self.height - 50 , 80, 30);
        _locationLb.shadowColor = [UIColor grayColor];
        _locationLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_locationLb];
    }
    
    return _locationLb;
}

- (UIImageView *)userIcon{
    if(_userIcon == nil){
        _userIcon = [[UIImageView alloc] init];
        _userIcon.frame = CGRectMake(10, self.locationIcon.bottom + 10, 10.5, 10.5);
        _userIcon.image = [UIImage imageNamed:@"icon_person"];
        _userIcon.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _userIcon.layer.shadowColor = [UIColor grayColor].CGColor;
        _userIcon.layer.shadowOpacity = 0.5;
        [self addSubview:_userIcon];
    }
    
    return _userIcon;
}

- (UILabel *)userLb{
    if(_userLb == nil){
        _userLb = [UILabel new];
        _userLb.textColor = [UIColor whiteColor];
        _userLb.font = [UIFont systemFontOfSize:16.0];
        _userLb.frame = CGRectMake(self.userIcon.right + 5, self.locationIcon.bottom + 10 , 80, 30);
        _userLb.numberOfLines = 0;
        _userLb.shadowColor = [UIColor grayColor];
        _userLb.shadowOffset = CGSizeMake(0.5, 0.5);
        [self addSubview:_userLb];
    }
    
    return _userLb;
    
}

@end
