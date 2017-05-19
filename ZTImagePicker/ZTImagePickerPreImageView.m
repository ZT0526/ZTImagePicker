//
//  ZTImagePickerPreImageView.m
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/5/14.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTImagePickerPreImageView.h"
#import "UIView+Category.h"

@implementation ZTImagePickerPreImageView

- (instancetype)init{
    if(self = [super init]){
        [self p_cofigSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self p_cofigSubViews];
    }
    
    return self;
}

- (void)p_cofigSubViews{
    [self reTakeButton];
    [self useImageButton];
    [self imageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.imageView.frame = CGRectMake(0, 70, self.width, self.height - 70 - 90);
    self.reTakeButton.frame = CGRectMake(10, self.height - 80, 60, 60);
    self.useImageButton.frame = CGRectMake(self.width - 90, self.height - 80, 80, 60);
    
}

- (UIButton *)reTakeButton{
    if(_reTakeButton == nil){
        _reTakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reTakeButton setTitle:@"重拍" forState:UIControlStateNormal];
        [_reTakeButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_reTakeButton];
    }
    
    return _reTakeButton;
}

- (UIButton *)useImageButton{
    if(_useImageButton == nil){
        _useImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useImageButton setTitle:@"使用照片" forState:UIControlStateNormal];
        [_useImageButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_useImageButton];
    }
    
    return _useImageButton;
}

- (UIImageView *)imageView{
    if(_imageView == nil){
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end
