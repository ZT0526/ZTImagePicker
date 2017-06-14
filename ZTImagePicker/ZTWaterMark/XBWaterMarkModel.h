//
//  XBWaterMarkModel.h
//  Fieldworks
//
//  Created by ZT0526 on 2017/4/24.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBWaterMarkModel : NSObject

@end


@interface XBWaterMarkWorkReportModel : NSObject

@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, copy)   NSString  *departMent;
@property (nonatomic, copy)   NSString  *placMark;

@property (nonatomic, copy)   NSString  *reportType;

@end


@interface XBWaterMarkHandleProblemModel : NSObject

@property (nonatomic, strong) NSDate    *date;
@property (nonatomic, copy)   NSString  *userName;
@property (nonatomic, copy)   NSString  *placMark;

@end
