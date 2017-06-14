//
//  NSDateAdditions.h
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TapKit)

///-------------------------------
/// Adjusting
///-------------------------------

- (NSDate *)startDate;

- (NSDate *)noonDate;


- (NSDate *)dateByAddingSeconds:(int)seconds;

- (NSDate *)dateByAddingMinutes:(int)minutes;

- (NSDate *)dateByAddingHours:(int)hours;

- (NSDate *)dateByAddingDays:(NSInteger) dDays;

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
///-------------------------------
/// Comparing
///-------------------------------

- (BOOL)earlierThan:(NSDate *)date;


- (BOOL)isSameYearAsDate:(NSDate *)date;

- (BOOL)isSameMonthAsDate:(NSDate *)date;

- (BOOL)isSameDayAsDate:(NSDate *)date;

- (BOOL)isSameWeekAsDate:(NSDate *)date;


///-------------------------------
/// Date components
///-------------------------------

- (NSDateComponents *)dateComponents;

@end
