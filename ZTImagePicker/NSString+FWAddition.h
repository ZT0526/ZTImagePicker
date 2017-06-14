//
//  NSString+FWAddition.h
//  Fieldworks
//
//  Created by Peter Zhang on 14-4-22.
//  Copyright (c) 2014年 小步创想. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FWAddition)

// will convert 1 into 01
- (NSString *)clockTimeString;

- (NSString *)ossFileName;

// Make sure self is a legal oss object url.
- (NSString *)imageServiceURLWithWidth_2:(NSUInteger)width height:(NSUInteger)height cutting:(BOOL)cutting;

- (NSString *)bareHost;

- (NSString*)sqliteArgString;

- (NSString*)stringByReplaceWithLanguagePackageInFunId:(NSString*)funId partId:(NSString*)partyId;

- (NSString *)sandboxIDRefreshedFilePath;

+ (NSString*)timelongWithTimeInterval:(long long)timeInterval;

- (NSString*)ossURLString;

- (NSString*)loginSecrectPassword;

@end
