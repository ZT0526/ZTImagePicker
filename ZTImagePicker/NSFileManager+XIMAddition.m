//
//  NSFileManager+XIMAdditions.m
//
//  Created by ZT0526 on 2017/4/21.
//  Copyright © 2017年 小步创想. All rights reserved.
//

#import "NSFileManager+XIMAddition.h"
#import <sys/xattr.h>

@implementation NSFileManager (XIMAddition)

- (NSString *)sandboxDirecotry
{
    NSString *documentsDirectory = [self documentsDirectory];
    return [documentsDirectory stringByDeletingLastPathComponent];
}

- (NSString *)cacheDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return paths[0];
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

- (BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data intermediate:(BOOL)intermediate
{
    if (path.length == 0) return NO;
    
    NSString *dirPath = [path stringByDeletingLastPathComponent];
    if (intermediate && [self fileExistsAtPath:dirPath] == NO) {
        [self createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL success = [self createFileAtPath:path contents:data attributes:nil];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    return success;
}

- (BOOL)createDirectoryAtPath:(NSString *)path intermediate:(BOOL)intermediate
{
    if (![self fileExistsAtPath:path]) {
        BOOL success = [self createDirectoryAtPath:path withIntermediateDirectories:intermediate attributes:nil error:nil];
        if (success) {
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
        }
        return success;
    }
    return YES;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // for iOS <= 5.0.1
        const char* filePath = [[url path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else { // For iOS >= 5.1
        NSError *error = nil;
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}

@end
