//
//  UserDefaultCenter.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/12.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultCenter : NSObject
//Remove
+ (void)removeUserDefaultWithUKey:(NSString *)u_key;
//Set
+ (void)setUserDefaultWithUKey:(NSString *)u_key andBlock:(NSDictionary* _Nonnull (^)(NSDictionary *userDefDic))block;


@end
