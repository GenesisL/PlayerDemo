//
//  PlayCenter.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/8.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayCenter : NSObject

@property (nonatomic, strong) NSMutableArray *playQueue;

@property (nonatomic, readonly, assign) NSInteger currentIndex;

@end
