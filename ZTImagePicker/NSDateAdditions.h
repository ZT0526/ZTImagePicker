//
//  NSDateAdditions.h
//  TapKit
//
//  Created by Wu Kevin on 4/27/13.
//  Copyright (c) 2013 Telligenty. All rights reserved.
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
