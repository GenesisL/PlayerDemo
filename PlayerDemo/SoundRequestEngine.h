//
//  SoundRequestEngine.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/11.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "RequestEngine.h"

@interface SoundRequestEngine : RequestEngine

+ (void)getSoundInfoWithSoundID:(NSString *)sound_id Success:(RequestBlock)success Failed:(RequestBlock)failed ;

+ (void)getSoundListDataWithAlbumID:(NSString *)album_id Success:(RequestBlock)success Failed:(RequestBlock)failed;

@end
