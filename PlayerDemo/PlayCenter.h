//
//  PlayCenter.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/8.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKAudioPlayer.h"

typedef NS_ENUM(NSUInteger, PlayerCircleMode) {
    PlayerCircleModeCircle,
    PlayerCircleModeSingle,
    PlayerCircleModeRandom,
};

@interface PlayCenter : NSObject <STKAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *playQueue;

@property (nonatomic, strong) STKAudioPlayer *audioPlayer;

@property (nonatomic, readonly, assign) NSInteger currentIndex;

@property (nonatomic, assign) PlayerCircleMode circleMode;

+ (instancetype)mainCenter;

//Play Control
- (BOOL)play;
- (BOOL)pause;
- (BOOL)previous;
- (BOOL)next;
- (BOOL)stop;



@end
