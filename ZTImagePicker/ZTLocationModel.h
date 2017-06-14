//
//  ZTLocationModel.h
//  ZTImagePicker
//
//  Created by ZT0526 on 2017/6/13.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTLocationModel : NSObject

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat horizontalAccuracy;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat course;
@property (nonatomic, strong) NSDate *uptime;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, copy) NSString *placemark;

@property (nonatomic, assign) BOOL wifiReachable;
@property (nonatomic, assign) CGFloat floatBatteryLevel;

@property (nonatomic, strong) NSDictionary *addressComponent;
@property (nonatomic, copy, readonly) NSString *reformattedAddress;


@end
