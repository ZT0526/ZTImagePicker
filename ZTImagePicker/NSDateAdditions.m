//
//  NSDateAdditions.m
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "NSDateAdditions.h"

@implementation NSDate (TapKit)


#pragma mark - Adjusting

- (NSDate *)startDate
{
  NSDateComponents *components = [self dateComponents];
  [components setHour:0];
  [components setMinute:0];
  [components setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)noonDate
{
  NSDateComponents *components = [self dateComponents];
  [components setHour:12];
  [components setMinute:0];
  [components setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:components];
}


- (NSDate *)dateByAddingSeconds:(int)seconds
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + seconds;
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingMinutes:(int)minutes
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + minutes * (60.0);
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

- (NSDate *)dateByAddingHours:(int)hours
{
  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + hours * (60.0*60.0);
  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
}

//- (NSDate *)dateByAddingDays:(int)days
//{
//  NSTimeInterval timeInterval = [self timeIntervalSinceReferenceDate] + days * (60.0*60.0*24);
//  return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timeInterval];
//}



#pragma mark - Comparing

- (BOOL)earlierThan:(NSDate *)date
{
  return ( [self earlierDate:date] == self );
}


- (BOOL)isSameYearAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return ( [components1 year] == [components2 year] );
}

- (BOOL)isSameMonthAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return (([components1 year] == [components2 year])
          && ([components1 month] == [components2 month])
          );
}

- (BOOL)isSameDayAsDate:(NSDate *)date
{
  NSDateComponents *components1 = [self dateComponents];
  NSDateComponents *components2 = [date dateComponents];
  return (([components1 year] == [components2 year])
          && ([components1 month] == [components2 month])
          && ([components1 day] == [components2 day])
          );
}

- (BOOL)isSameWeekAsDate:(NSDate *)date
{
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [date dateComponents];

    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    //  if ( [components1 week] != [components2 week] ) {
    if ( [components1 weekOfMonth] != [components2 weekOfMonth] ) {
        return NO;
    }

    // Must have a time interval under 1 week.
    return ( fabs([self timeIntervalSinceDate:date]) < (60.0*60.0*24*7) );
}

- (NSDate *)dateByAddingDays:(NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}



#pragma mark - Date components

- (NSDateComponents *)dateComponents
{
  NSCalendarUnit calendarUnit =
                      NSEraCalendarUnit
                    | NSYearCalendarUnit
                    | NSMonthCalendarUnit
                    | NSDayCalendarUnit
                    | NSHourCalendarUnit
                    | NSMinuteCalendarUnit
                    | NSSecondCalendarUnit
                    | NSWeekCalendarUnit
                    | NSWeekdayCalendarUnit
                    | NSWeekdayOrdinalCalendarUnit
                    | NSQuarterCalendarUnit
                    | NSWeekOfMonthCalendarUnit
                    | NSWeekOfYearCalendarUnit
                    | NSYearForWeekOfYearCalendarUnit
                    | NSCalendarCalendarUnit
                    | NSTimeZoneCalendarUnit;
  return [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
}

@end
