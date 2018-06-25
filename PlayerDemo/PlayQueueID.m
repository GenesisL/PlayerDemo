//
//  PlayQueueID.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/25.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "PlayQueueID.h"

@implementation PlayQueueID

-(id) initWithUrl:(NSURL*)url andCount:(int)count andDataSize:(double)dataSize andDuration:(double)duration andLocal:(NSInteger)local
{
    if (self = [super init])
    {
        self.url = url;
        self.count = count;
        self.dataSize = dataSize;
        self.duration = duration;
        self.isLocal = local;
    }
    
    return self;
}

-(BOOL) isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [PlayQueueID class])
    {
        return NO;
    }
    
    return [((PlayQueueID*)object).url isEqual: self.url] && ((PlayQueueID*)object).count == self.count;
}

-(NSString*) description
{
    return [self.url description];
}

@end
