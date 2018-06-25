//
//  DownloadCenter.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/12.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@interface DownloadCenter : NSObject <ASIProgressDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIHTTPRequest *cacheRequest;
@property (nonatomic, strong) ASIHTTPRequest *downloadRequest;

//Init
+ (instancetype)shareCenter;

//Reset
- (void)resetCacheRequest;

//Cache Function
- (void)cacheFilesWithURL:(id)url;
- (void)tryCacheFilesWithURL:(id)url;

//Check Function
- (BOOL)checkCacheFilesWithURL:(id)url OptionBlock:(void (^)(BOOL isExist, NSString  * _Nullable filePath, unsigned long long dataSize))optionBlock;
- (void)checkDownloadFilesWithKey:(id)key URL:(id)url;

@end
