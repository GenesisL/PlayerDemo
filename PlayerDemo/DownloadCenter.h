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

@property (nonatomic, strong) ASIHTTPRequest *request;

+ (instancetype)shareCenter;

- (void)cacheFilesWithURL:(id)url;
- (void)tryCacheFilesWithURL:(id)url;

@end
