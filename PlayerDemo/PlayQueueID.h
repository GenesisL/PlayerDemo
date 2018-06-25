//
//  PlayQueueID.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/25.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayQueueID : NSObject

@property (readwrite) int count;
@property (readwrite) NSURL* url;
@property (readwrite) double dataSize;
@property (readwrite) double duration;
@property (readwrite) NSInteger isLocal;

- (id)initWithUrl:(NSURL*)url andCount:(int)count andDataSize:(double)dataSize andDuration:(double)duration andLocal:(NSInteger)local;

@end
