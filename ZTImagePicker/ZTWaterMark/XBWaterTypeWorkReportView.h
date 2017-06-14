//
//  XBWaterTypeWorkReportView.h
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBWaterMarkModel.h"
#import "UIView+Category.h"
@protocol XBWaterTypeWorkReportViewDelegate <NSObject>

- (void)reportTypeViewDidShow;
- (void)reportTypeViewDidHidden;

@end

@interface XBWaterTypeWorkReportView : UIView

@property (nonatomic, strong) XBWaterMarkWorkReportModel *model;

@property (nonatomic, weak)    id<XBWaterTypeWorkReportViewDelegate> delegate;

@property (nonatomic , strong) UILabel      *xmNameLb;
@property (nonatomic , strong) UIImageView  *locationIcon;
@property (nonatomic , strong) UILabel      *locationLb;
@property (nonatomic , strong) UIImageView  *timeIcon;
@property (nonatomic , strong) UILabel      *timeLb;

@property (nonatomic , strong) UILabel      *reportTypeLb;

@property (nonatomic , assign) CGFloat      vertcalSpace;

@end
