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

typedef NS_ENUM(NSUInteger, PlayerFileMode) {
    PlayerFileModeOnlineStream = 0,
    PlayerFileModeOfflineFile = 1,
    PlayerFileModeOnCache = 1 << 1 | PlayerFileModeOfflineFile,
    PlayerFileModeOnDownload = 1 << 2 | PlayerFileModeOfflineFile,
};

@class SoundModel, DownloadCenter;

@interface PlayCenter : NSObject <STKAudioPlayerDelegate>

//Player
@property (nonatomic, strong) NSMutableArray *playQueue;
@property (nonatomic, strong) STKAudioPlayer *audioPlayer;
@property (nonatomic, strong) STKDataSource *dataSource;

//Download Center
@property (nonatomic, strong) DownloadCenter *download_cen;

//Current Status
@property (nonatomic, readonly, assign) NSInteger currentIndex;
@property (nonatomic, readonly, assign) STKAudioPlayerState currentState;

//Circle Mode
@property (nonatomic, assign) PlayerCircleMode circleMode;

//Info
@property (nonatomic, assign) PlayerFileMode fileMode;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) unsigned long long dataSize;

+ (instancetype)mainCenter;

//Add
- (void)addDataToQueueWithArray:(NSArray *)dataAry;

//Check
- (void)checkStatusAndPlayWithModel:(SoundModel *)model;

//Play Control
- (BOOL)play;
- (BOOL)playAtIndex:(NSUInteger)index;
- (BOOL)pause;
- (BOOL)previous;
- (BOOL)next;
- (BOOL)stop;



@end
