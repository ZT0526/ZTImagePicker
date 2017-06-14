//
//  NSFileManager+XIMAdditions.h
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (XIMAddition)

- (NSString *)sandboxDirecotry;

- (NSString *)cacheDirectory;

- (NSString *)documentsDirectory;

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data intermediate:(BOOL)intermediate;

- (BOOL)createDirectoryAtPath:(NSString *)path intermediate:(BOOL)intermediate;

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url;

@end
