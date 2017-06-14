//
//  NSFileManager+XIMAdditions.h
//  XBIMKit
//
//  Created by Zhang Studyro on 13-7-23.
//  Copyright (c) 2013年 Xbcx. All rights reserved.
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
