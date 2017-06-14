//
//  XBWaterTypeHandleProblemView.h
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWaterMarkModel.h"
#import "UIView+Category.h"
@interface XBWaterTypeHandleProblemView : UIView

@property (nonatomic, strong) XBWaterMarkHandleProblemModel *model;

@property (nonatomic , strong) UIImageView  *locationIcon;
@property (nonatomic , strong) UILabel      *locationLb;
@property (nonatomic , strong) UIImageView  *userIcon;
@property (nonatomic , strong) UILabel      *userLb;

@property (nonatomic , assign) CGFloat      vertcalSpace;

@end
