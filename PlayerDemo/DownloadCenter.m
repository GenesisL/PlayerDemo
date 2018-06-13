//
//  DownloadCenter.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/12.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "DownloadCenter.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <stddef.h>

//NS_INLINE NSString *documentPath () {
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//}
NS_INLINE NSString *cachesPath (void) {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.missevan.MediaCaches"];
}
NS_INLINE NSString *tmpPath (void) {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"com.missevan.MediaCaches"];
}

#define FileHashDefaultChunkSizeForReadingData 256

@interface DownloadCenter ()

@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation DownloadCenter

+ (instancetype)shareCenter {
    static DownloadCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [DownloadCenter new];
        
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

- (void)cacheFilesWithURL:(id)url {
    NSURL *fileURL;
    if ([url isKindOfClass:[NSString class]]) {
        fileURL = [NSURL URLWithString:url];
    }else if ([url isKindOfClass:[NSURL class]]) {
        fileURL = url;
    }else {
        return;
    }
    if (_request) {
        [_request clearDelegatesAndCancel];
        _request = nil;
    }
    _fileName = [fileURL lastPathComponent];
    _request = [[ASIHTTPRequest alloc] initWithURL:fileURL];
    [_request addRequestHeader:@"Referer" value:@"https://app.missevan.com/ios"];
    _request.tag = 1001;
    self.request.downloadDestinationPath = [cachesPath() stringByAppendingPathComponent:_fileName];
    NSLog(@"%@", self.request.downloadDestinationPath);
    self.request.temporaryFileDownloadPath = [tmpPath() stringByAppendingPathComponent:_fileName];
    NSLog(@"%@", self.request.temporaryFileDownloadPath);
    self.request.allowResumeForFileDownloads = YES;
    self.request.downloadProgressDelegate = self;
    self.request.delegate = self;
    self.request.shouldContinueWhenAppEntersBackground = YES;
    [self.request startSynchronous];
}
- (void)tryCacheFilesWithURL:(id)url {
    NSURL *fileURL;
    if ([url isKindOfClass:[NSString class]]) {
        fileURL = [NSURL URLWithString:url];
    }else if ([url isKindOfClass:[NSURL class]]) {
        fileURL = url;
    }else {
        return;
    }
    if (_request) {
        [_request clearDelegatesAndCancel];
        _request = nil;
    }
    _fileName = [fileURL lastPathComponent];
    _request = [[ASIHTTPRequest alloc] initWithURL:fileURL];
    _request.requestMethod = @"HEAD";
    _request.tag = 1000;
    [_request addRequestHeader:@"Referer" value:@"https://app.missevan.com/ios"];
    self.request.delegate = self;
    [self.request startSynchronous];
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
//    NSLog(@"Header: %@", responseHeaders);
    if (request.tag == 1000) {
        NSString *fileMD5Str = [CFBridgingRelease(FileMD5HashCreateWithPath(CFBridgingRetain([cachesPath() stringByAppendingPathComponent:_fileName]), 256)) uppercaseString];
        if (fileMD5Str && [responseHeaders[@"Etag"] rangeOfString:fileMD5Str].location != NSNotFound) {
            //Not Download
        }else {
            //Download
            [self cacheFilesWithURL:request.originalURL];
        }
    }
}

#pragma mark - MD5 Compare
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath, size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}





@end

