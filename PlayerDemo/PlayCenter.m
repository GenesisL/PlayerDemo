//
//  PlayCenter.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/8.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "PlayCenter.h"

@implementation PlayCenter
#pragma mark - Init
+ (instancetype)mainCenter {
    static PlayCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [PlayCenter new];
        center.circleMode = PlayerCircleModeCircle;
    });
    return center;
}
- (void)dealloc {
    
}

- (STKAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){.flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = { 50, 100, 200, 400, 800, 1600, 2600, 16000 }, .bufferSizeInSeconds = 1 }];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = NO;
        _audioPlayer.volume = 1;
    }
    
    return _audioPlayer;
}


#pragma mark - Play Control
- (BOOL)play {
    return YES;
}
- (BOOL)pause {
    return YES;
}
- (BOOL)previous {
    return YES;
}
- (BOOL)next {
    return YES;
}
- (BOOL)stop {
    return YES;
}

#pragma mark - STKAudioPlayerDelegate
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didStartPlayingQueueItemId:(NSObject *)queueItemId {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject *)queueItemId {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didFinishPlayingQueueItemId:(NSObject *)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line {
    
}
- (void)audioPlayer:(STKAudioPlayer *)audioPlayer didCancelQueuedItems:(NSArray *)queuedItems {
    
}

@end
