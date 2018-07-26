//
//  PlayCenter.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/8.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "PlayCenter.h"
#import "DownloadCenter.h"

//Model
#import "SoundModel.h"
#import "PlayQueueID.h"

@implementation PlayCenter
#pragma mark - Init
+ (instancetype)mainCenter {
    static PlayCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [PlayCenter new];
        center.download_cen = [DownloadCenter shareCenter];
        center.fileMode = PlayerFileModeOnlineStream;
        center.dataSize = 0;
        center.circleMode = PlayerCircleModeCircle;
    });
    return center;
}
- (void)dealloc {
    
}

#pragma mark - Play Queue Manager
- (void)addDataToQueueWithModel:(SoundModel *)model {
    [self insertDatasToQueueWithArray:[NSArray arrayWithObject:model] Index:self.playQueue.count];
}
- (void)addDataToQueueWithArray:(NSArray *)dataAry {
    [self insertDatasToQueueWithArray:dataAry Index:self.playQueue.count];
}
- (void)insertDataToQueueWithModel:(SoundModel *)model {
    [self insertDatasToQueueWithArray:[NSArray arrayWithObject:model] Index:self.playQueue.count];
}
- (void)insertDatasToQueueWithArray:(NSArray *)dataArray Index:(NSUInteger)index {
    [self.playQueue insertObjects:dataArray atIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)removeDatasFromQueueWithIndex:(NSUInteger)index {
    [self.playQueue removeObjectAtIndex:index];
}
- (void)removeAllDataFromQueue {
    [self.playQueue removeAllObjects];
}

#pragma mark - Check Status
- (void)checkStatusAndPlayWithModel:(SoundModel *)model {
    if (model) {
        //Check Download
#warning Check Download
        //Check Cache
        __weak typeof(self) weakSelf = self;
        [_download_cen checkCacheFilesWithURL:model.soundurl_64 OptionBlock:^(BOOL isExist, NSString * _Nullable filePath, unsigned long long dataSize) {
            __strong typeof(self) strongSelf = weakSelf;
            //Play
            strongSelf.dataSize = dataSize;
            strongSelf.currentIndex = [strongSelf searchIndexWithModel:model];
            if (isExist) {
                strongSelf.fileMode = PlayerFileModeOnCache;
                [strongSelf startStreamingWithURL:[NSURL fileURLWithPath:filePath]];
            }else {
                strongSelf.fileMode = PlayerFileModeOnlineStream;
                [strongSelf startStreamingWithURL:[NSURL URLWithString:model.soundurl_64]];
            }
            [strongSelf.download_cen tryCacheFilesWithURL:model.soundurl_64];
        }];
    }
}

#pragma mark - Search
- (NSUInteger)searchIndexWithModel:(SoundModel *)model {
    return [_playQueue indexOfObject:model];
}

#pragma mark - Play Control
- (BOOL)play {
    if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
        [self.audioPlayer pause];
    }else if (self.audioPlayer.state == STKAudioPlayerStatePaused) {
        [self.audioPlayer resume];
    }
    return YES;
}
- (BOOL)playAtIndex:(NSUInteger)index {
    if (_playQueue.count != 0) {
        if (index < _playQueue.count) {
            [self checkStatusAndPlayWithModel:[_playQueue objectAtIndex:index]];
        }else {
            [self checkStatusAndPlayWithModel:_playQueue.firstObject];
        }
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)pause {
    if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
        [self.audioPlayer pause];
    }else {
        [self.audioPlayer resume];
    }
    return YES;
}
- (BOOL)previous {
    if (_playQueue.count != 0) {
        if (_circleMode != PlayerCircleModeRandom) {
            if (_currentIndex > 0) {
                [self checkStatusAndPlayWithModel:[_playQueue objectAtIndex:_currentIndex - 1]];
                return YES;
            }else {
                [self checkStatusAndPlayWithModel:_playQueue.lastObject];
                return YES;
            }
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}
- (BOOL)next {
    if (_playQueue.count != 0) {
        if (_circleMode != PlayerCircleModeRandom) {
            if (_currentIndex + 1 < _playQueue.count) {
                [self checkStatusAndPlayWithModel:[_playQueue objectAtIndex:_currentIndex + 1]];
                return YES;
            }else {
                [self checkStatusAndPlayWithModel:_playQueue.firstObject];
                return YES;
            }
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}
- (BOOL)stop {
    [self.audioPlayer stop];
    [self resetStream];
    return YES;
}
     
#pragma mark - CancelStream
- (void)resetStream {
    [_download_cen resetCacheRequest];
    _fileMode = PlayerFileModeOnlineStream;
    _duration = 0;
    _dataSize = 0;
}

#pragma mark - Play Core
- (void)startStreamingWithURL:(NSURL *)soundURL {
    _dataSource = [STKAudioPlayer dataSourceFromURL:soundURL];
    [self.audioPlayer setDataSource:_dataSource withQueueItemId:[[PlayQueueID alloc] initWithUrl:soundURL andCount:0 andDataSize:_dataSize andDuration:_duration andLocal:(_fileMode & 1 ? 1 : 0)]];
}

#pragma mark - STKAudioPlayerDelegate
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICENTER_PLAYERSTATUS object:@(state)];
    switch (state) {
        case STKAudioPlayerStateReady:
            NSLog(@"State Changed To: Ready");
            break;
        case STKAudioPlayerStateRunning:
            NSLog(@"State Changed To: Running");
            break;
        case STKAudioPlayerStatePlaying:
            NSLog(@"State Changed To: Playing");
            break;
        case STKAudioPlayerStateBuffering:
            NSLog(@"State Changed To: Buffering");
            break;
        case STKAudioPlayerStatePaused:
            NSLog(@"State Changed To: Paused");
            break;
        case STKAudioPlayerStateStopped:
            NSLog(@"State Changed To: Stopped");
            break;
        case STKAudioPlayerStateError:{
            NSLog(@"State Changed To: Error");
            switch (_fileMode) {
                case PlayerFileModeOnlineStream:
                    break;
                case PlayerFileModeOfflineFile:
                    break;
                case PlayerFileModeOnCache:
                    break;
                case PlayerFileModeOnDownload:
                    break;
                default:
                    break;
            }
        }break;
        case STKAudioPlayerStateDisposed:
            NSLog(@"State Changed To: Disposed");
            break;
        default:
            break;
    }
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    switch (stopReason) {
        case STKAudioPlayerStopReasonNone:
            NSLog(@"Stop Reason: None");
            break;
        case STKAudioPlayerStopReasonEof:
            NSLog(@"Stop Reason: Eof");
            break;
        case STKAudioPlayerStopReasonUserAction:
            NSLog(@"Stop Reason: UserAction");
            break;
        case STKAudioPlayerStopReasonPendingNext:
            NSLog(@"Stop Reason: Pending Next");
            break;
        case STKAudioPlayerStopReasonDisposed:
            NSLog(@"Stop Reason: Disposed");
            break;
        case STKAudioPlayerStopReasonError:
            NSLog(@"Stop Reason: Error");
            break;
        default:
            break;
    }
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems {
    
}

#pragma mark - Get/Set
- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){.flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = { 50, 100, 200, 400, 800, 1600, 2600, 16000 }, .bufferSizeInSeconds = 1 }];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = NO;
        _audioPlayer.volume = 1;
    }
    
    return _audioPlayer;
}
- (STKAudioPlayerState)currentState {
    return self.audioPlayer.state;
}
- (NSMutableArray *)playQueue {
    if (!_playQueue) {
        _playQueue = [NSMutableArray array];
    }
    return _playQueue;
}

#pragma makr - Tools
- (void)randomPlayQueue {
    
}
- (NSArray *)swapArrayWithArray:(NSArray *)array {
    NSMutableArray *mAry = [NSMutableArray arrayWithArray:array];
    return mAry;
}

@end
