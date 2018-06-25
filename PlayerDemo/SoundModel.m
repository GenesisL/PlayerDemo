//
//  SoundModel.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/16.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "SoundModel.h"

@implementation SoundModel

+ (instancetype)initWithDic:(NSDictionary *)dic {
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dic];
    return obj;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"sound_id"];
    }
}

#pragma mark - Set
- (void)setSoundurl:(NSString *)soundurl {
    if (![soundurl hasPrefix:IMAGE_HOST]) {
        _soundurl = [IMAGE_HOST stringByAppendingString:soundurl];
    }else {
        _soundurl = soundurl;
    }
}
- (void)setSoundurl_32:(NSString *)soundurl_32 {
    if (![soundurl_32 hasPrefix:IMAGE_HOST]) {
        _soundurl_32 = [IMAGE_HOST stringByAppendingString:soundurl_32];
    }else {
        _soundurl_32 = soundurl_32;
    }
}
- (void)setSoundurl_64:(NSString *)soundurl_64 {
    if (![soundurl_64 hasPrefix:IMAGE_HOST]) {
        _soundurl_64 = [IMAGE_HOST stringByAppendingString:soundurl_64];
    }else {
        _soundurl_64 = soundurl_64;
    }
}
- (void)setSoundurl_128:(NSString *)soundurl_128 {
    if (![soundurl_128 hasPrefix:IMAGE_HOST]) {
        _soundurl_128 = [IMAGE_HOST stringByAppendingString:soundurl_128];
    }else {
        _soundurl_128 = soundurl_128;
    }
}

@end
