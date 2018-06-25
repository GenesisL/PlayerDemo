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

#pragma mark - Add
- (void)addDataToQueueWithArray:(NSArray *)dataAry {
    
}

#pragma mark - Check Status
- (void)checkStatusAndPlayWithModel:(SoundModel *)model {
    //Check Download
#warning Check Download
    //Check Cache
    __weak typeof(self) weakSelf = self;
    [_download_cen checkCacheFilesWithURL:model.soundurl_64 OptionBlock:^(BOOL isExist, NSString * _Nullable filePath, unsigned long long dataSize) {
        //Play
        weakSelf.dataSize = dataSize;
        if (isExist) {
            weakSelf.fileMode = PlayerFileModeOnCache;
            [weakSelf startStreamingWithURL:[NSURL fileURLWithPath:filePath]];
        }else {
            weakSelf.fileMode = PlayerFileModeOnlineStream;
            [weakSelf startStreamingWithURL:[NSURL URLWithString:model.soundurl_64]];
        }
        [weakSelf.download_cen tryCacheFilesWithURL:model.soundurl_64];
    }];
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
    
    return YES;
}
- (BOOL)next {
    
    return YES;
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

@end
