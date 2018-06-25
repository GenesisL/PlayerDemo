//
//  SoundModel.h
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/16.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundModel : NSObject

@property (nonatomic, copy) NSString *sound_id;
@property (nonatomic, copy) NSString *front_cover;
@property (nonatomic, copy) NSString *soundstr;
@property (nonatomic, copy) NSString *soundurl;
@property (nonatomic, copy) NSString *soundurl_32;
@property (nonatomic, copy) NSString *soundurl_64;
@property (nonatomic, copy) NSString *soundurl_128;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *view_count;
@property (nonatomic, copy) NSString *comments_num;
@property (nonatomic, copy) NSString *favorite_count;

+ (instancetype)initWithDic:(NSDictionary *)dic;

@end
