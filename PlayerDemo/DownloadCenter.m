//
//  DownloadCenter.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/12.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "DownloadCenter.h"

#import "RequestEngine.h"
#import "FileMD5Tools.h"

#pragma mark - Get Path
//NS_INLINE NSString *documentPath () {
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//}
NS_INLINE NSString *cachesPath (void) {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.missevan.MediaCaches"];
}
NS_INLINE NSString *tmpPath (void) {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"com.missevan.MediaCaches"];
}

#pragma mark - URL Check
NS_INLINE NSURL *checkURL (id url) {
    NSURL *fileURL = nil;
    if ([url isKindOfClass:[NSString class]]) {
        fileURL = [NSURL URLWithString:url];
    }else if ([url isKindOfClass:[NSURL class]]) {
        fileURL = url;
    }
    return fileURL;
}

@interface DownloadCenter ()

@property (nonatomic, assign) CGFloat cacheProgress;

@end

@implementation DownloadCenter

#pragma mark - Init
+ (instancetype)shareCenter {
    static DownloadCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [DownloadCenter new];
        
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:cachesPath()]) {
            [fileManager createDirectoryAtPath:cachesPath() withIntermediateDirectories:YES attributes:nil error:nil];
        }
        if (![fileManager fileExistsAtPath:tmpPath()]) {
            [fileManager createDirectoryAtPath:tmpPath() withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return center;
}

#pragma mark - Reset
- (void)resetCacheRequest {
    if (_cacheRequest) {
        [_cacheRequest clearDelegatesAndCancel];
        _cacheRequest = nil;
    }
}

#pragma mark - Cache Function
- (void)cacheFilesWithURL:(id)url {
    NSURL *fileURL = checkURL(url);
    if (fileURL == nil) {
        return;
    }
    if (_cacheRequest) {
        [_cacheRequest clearDelegatesAndCancel];
        _cacheRequest = nil;
    }
    NSString * fileName = [fileURL lastPathComponent];
    _cacheRequest = [[ASIHTTPRequest alloc] initWithURL:fileURL];
    _cacheRequest.requestMethod = @"GET";
    [_cacheRequest addRequestHeader:@"Referer" value:@"https://app.missevan.com/ios"];
    _cacheRequest.tag = 1001;
    _cacheRequest.downloadDestinationPath = [cachesPath() stringByAppendingPathComponent:fileName];
    NSLog(@"%@", _cacheRequest.downloadDestinationPath);
    _cacheRequest.temporaryFileDownloadPath = [tmpPath() stringByAppendingPathComponent:fileName];
    NSLog(@"%@", _cacheRequest.temporaryFileDownloadPath);
    _cacheRequest.allowResumeForFileDownloads = YES;
    _cacheRequest.downloadProgressDelegate = self;
    _cacheRequest.delegate = self;
    _cacheRequest.shouldContinueWhenAppEntersBackground = YES;
    [_cacheRequest startAsynchronous];
}
- (void)tryCacheFilesWithURL:(id)url {
    
    NSURL *fileURL = checkURL(url);
    if (fileURL == nil) {
        return;
    }
    //AFNetWork
    __weak typeof(self) weakSelf = self;
    [RequestEngine HEADWithRequestURL:fileURL.absoluteString andSuccessBlock:^(id returnValue, NSError *error) {
        NSLog(@"%@", returnValue);
        NSString *fileMD5Str = [[FileMD5Tools fileMD5StringByFilePath:[cachesPath() stringByAppendingPathComponent:fileURL.lastPathComponent]] uppercaseString];
        if (fileMD5Str && [returnValue[@"Etag"] rangeOfString:fileMD5Str].location != NSNotFound) {
            //Not Download
        }else {
            //Download
            [weakSelf cacheFilesWithURL:fileURL];
        }
    } andFailedBlock:^(id returnValue, NSError *error) {}];
}

#pragma mark - Check Function
- (BOOL)checkCacheFilesWithURL:(id)url OptionBlock:(void (^)(BOOL isExist, NSString  * _Nullable filePath, unsigned long long dataSize))optionBlock {
    NSURL *fileURL = nil;
    if ([url isKindOfClass:[NSString class]]) {
        fileURL = [NSURL URLWithString:url];
    }else if ([url isKindOfClass:[NSURL class]]) {
        fileURL = url;
    }
    if (fileURL == nil) {
        return NO;
    }
    NSString *path = [cachesPath() stringByAppendingPathComponent:fileURL.lastPathComponent];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        unsigned long long fs = [manager attributesOfItemAtPath:path error:nil].fileSize;
        if (optionBlock) {
            optionBlock(YES, path, fs);
        }
        return YES;
    }else {
        if (optionBlock) {
            optionBlock(NO, nil, 0);
        }
        return NO;
    }
}
- (void)checkDownloadFilesWithKey:(id)key URL:(id)url {
    
}

#pragma mark - ASIProgressDelegate
- (void)setProgress:(float)newProgress {
    _cacheProgress = newProgress;
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request {
    NSLog(@"Started %li, Method: %@", (long)request.tag, request.requestMethod);
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Finished %li, Method: %@", (long)request.tag, request.requestMethod);
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"Failed %li, Method: %@", (long)request.tag, request.requestMethod);
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    NSLog(@"ReceiveHeader %li, Method: %@", (long)request.tag, request.requestMethod);
    NSLog(@"Header: %@", responseHeaders);
}



@end

