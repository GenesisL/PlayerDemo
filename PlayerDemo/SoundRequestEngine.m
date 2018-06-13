//
//  SoundRequestEngine.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/11.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "SoundRequestEngine.h"

@implementation SoundRequestEngine

+ (void)getSoundInfoWithSoundID:(NSString *)sound_id Success:(RequestBlock)success Failed:(RequestBlock)failed {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                sound_id, @"sound_id", nil];
    [super GETWithRequestURL:[REQUEST_HOST stringByAppendingString:kAPISound] andParameters:parameters andSuccessBlock:^(id returnValue, NSError *error) {
        success(returnValue, nil);
    } andFailedBlock:^(id returnValue, NSError *error) {
        failed(returnValue, error);
    }];
}

@end
