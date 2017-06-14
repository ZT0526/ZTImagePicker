//
//  NSString+FWAddition.m
//  Fieldworks
//
//  Created by Peter Zhang on 14-4-22.
//  Copyright (c) 2014年 小步创想. All rights reserved.
//

#import "NSString+FWAddition.h"

#import <NSString+Hashes.h>
#import <XIMConfiguration.h>
#import "FWLanguagePackageTool.h"

@implementation NSString (FWAddition)

- (NSString *)clockTimeString
{
    NSUInteger value = self.integerValue;
    return value >= 10 ? [NSString stringWithFormat:@"%lu", (unsigned long)value] :
                         [NSString stringWithFormat:@"0%lu", (unsigned long)value];
}

- (NSString *)ossFileName
{
    NSString *extension = [self pathExtension];
    NSString *lastComponent = [[self lastPathComponent] stringByDeletingPathExtension];
    NSString *fileName = [lastComponent md5];
    return fileName ? (lastComponent ? [NSString stringWithFormat:@"%@.%@", lastComponent, extension] : fileName) :nil;
}

- (NSString *)imageServiceURLWithWidth_2:(NSUInteger)width height:(NSUInteger)height cutting:(BOOL)cutting
{
    if ([self containsString:@"@1e_"] && [self containsString:@"Q_1x.jpg"]) {
        return self;
    }
    NSString *imageServiceDomain = [XIMConfiguration defaultConfiguration].imageServiceDomain;
    NSURL *url = [NSURL URLWithString:self];
    if (imageServiceDomain.length == 0 || width == 0 || height == 0 || !url) return nil;
    
    NSString *parameter = [NSString stringWithFormat:@"1e_%luw_%luh_%dc_0i_0o_90Q_1x.jpg", (unsigned long)width, (unsigned long)height, cutting];
    if ([url.path hasPrefix:@"http://"]) {
        return [NSString stringWithFormat:@"%@@%@", url.path, parameter];
    }
    if ([url.path hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"http://%@%@@%@", imageServiceDomain, url.path, parameter];
    }
    return [NSString stringWithFormat:@"http://%@/%@@%@", imageServiceDomain, url.path, parameter];
}

- (NSString *)bareHost
{
    if ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"] || [self hasPrefix:@"ftp://"]) {
        NSRange schemeRange = [self rangeOfString:@"://"];
        if (schemeRange.location != NSNotFound) {
            NSUInteger bareLocation = schemeRange.location + schemeRange.length;
            return (bareLocation < self.length) ? [self substringFromIndex:schemeRange.location + schemeRange.length] : nil;
            // TODO: delete the paths.
        }
    }
    return self;
}

- (NSString*)sqliteArgString {
    NSMutableString *arg = [NSMutableString stringWithString:self];
    [arg replaceString:@"/" withString:@"//"];
    [arg replaceString:@"'" withString:@"''"];
    [arg replaceString:@"[" withString:@"/["];
    [arg replaceString:@"]" withString:@"/]"];
    [arg replaceString:@"%" withString:@"/%"];
    [arg replaceString:@"&" withString:@"/&"];
    [arg replaceString:@"_" withString:@"/_"];
    [arg replaceString:@"(" withString:@"/("];
    [arg replaceString:@")" withString:@"/)"];
    return [arg copy];
}

- (NSString*)stringByReplaceWithLanguagePackageInFunId:(NSString*)funId partId:(NSString*)partyId {

    NSMutableString *mutString = [NSMutableString stringWithString:self];
    NSInteger times = 0;
    do {
        times++;
        [mutString setString:[mutString __stringByReplaceWithLanguagePackageInFunId:funId partId:partyId]];
    } while ([mutString containsString:@"{"] && [mutString containsString:@"}"] && times < 6);
    
    return [mutString copy];
}

- (NSString*)__stringByReplaceWithLanguagePackageInFunId:(NSString*)funId partId:(NSString*)partyId {
    if (![self containsString:@"{"] || ![self containsString:@"}"]) {
        return self;
    }
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:self];
    NSMutableArray *params = [self _paramsOfLanguagePackageContain];
    [params enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *value = [[FWLanguagePackageTool currentTool] valueOfParamName:obj funId:funId partId:partyId];
        if (value.length > 0) {
            [mutStr replaceString:obj withString:value ignoringCase:YES];
        }
    }];
    return [mutStr copy];
}

- (NSMutableArray*)_paramsOfLanguagePackageContain {
    
    NSMutableArray *params = [NSMutableArray new];
    NSInteger start = 0;
    NSDictionary *dic = nil;
    while ((dic = [self _firstParamNameOfLanguagePackageContainFromIndex:start])) {
        NSString *param = dic[@"name"];
        if (param && ![params containsObject:param]) {
            [params addObjectIfNotNil:param];
        }
        NSInteger to = [dic[@"to"] integerValue];
        start = to + 1;
    }
    return params;
}

- (NSDictionary*)_firstParamNameOfLanguagePackageContainFromIndex:(NSInteger)start {
    if (start >= self.length) {
        return nil;
    }
    NSInteger fromIndex = [self rangeOfString:@"{" options:NSLiteralSearch range:NSMakeRange(start, self.length - start)].location;
    NSInteger toIndex = [self rangeOfString:@"}" options:NSLiteralSearch range:NSMakeRange(start, self.length - start)].location;
    if (fromIndex == NSNotFound ||
        toIndex == NSNotFound ||
        fromIndex >= toIndex) {
        return nil;
    }
    
    NSString *name = [self substringWithRange:NSMakeRange(fromIndex, toIndex - fromIndex + 1)];
    if (!name) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:name forKeyIfNotNil:@"name"];
    [dic setObject:@(fromIndex) forKeyIfNotNil:@"from"];
    [dic setObject:@(toIndex) forKeyIfNotNil:@"to"];
    return dic;
    
}

- (NSString *)sandboxIDRefreshedFilePath
{
    // /var/mobile/Containers/Data/Application/B1C8922B-D4C7-4860-B0DA-146A842EA326/Documents/business/static/9CCE2E2F-BFCC-4723-AE91-BBE6B6F31A53.jpg
    NSArray *components = self.pathComponents;
    __block NSUInteger index = NSNotFound;
    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
        if ([component hasPrefix:@"Application"]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index == NSNotFound || index + 1 >= components.count) return self;
    NSArray *subComponents = [components subarrayWithRange:NSMakeRange(index + 2, components.count - index - 2)];
    NSString *fileSuffix = [subComponents componentsJoinedByString:@"/"];
    NSString *refreshedPath = [NSHomeDirectory() stringByAppendingPathComponent:fileSuffix];
    return refreshedPath;
}

+ (NSString*)timelongWithTimeInterval:(long long)timeInterval {
    NSString *h;
    NSString *m;
    timeInterval = timeInterval/60;
    if (timeInterval >= 60) {
        h = [[@(timeInterval/60) description] stringByAppendingString:@"小时"];
    } else {
        h = @"";
    }
    m = timeInterval%60 ? [[@(timeInterval%60) description] stringByAppendingString:@"分钟"] : @"";
    
    NSString *timeLong = [NSString stringWithFormat:@"%@%@", h, m];
    if (timeLong.length == 0) {
        timeLong = @"1分钟";
    }
    return timeLong;
}

- (NSString*)ossURLString {
    NSString *imageServiceDomain = [XIMConfiguration defaultConfiguration].imageServiceDomain;

    if ([self hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"http://%@%@", imageServiceDomain, self];
    }
    return self;
}

- (NSString*)loginSecrectPassword {
    return [[self.md5 stringByAppendingString:@"hw_wq"] md5];
}

@end
