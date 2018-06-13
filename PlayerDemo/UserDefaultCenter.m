//
//  UserDefaultCenter.m
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/12.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import "UserDefaultCenter.h"

@implementation UserDefaultCenter

+ (void)removeUserDefaultWithUKey:(NSString *)u_key {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:u_key];
    [def synchronize];
}

+ (void)setUserDefaultWithUKey:(NSString *)u_key andBlock:(NSDictionary* _Nonnull (^)(NSDictionary *userDefDic))block {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *mDic = [def objectForKey:u_key]?:@{};
    NSDictionary *returnData = block(mDic);
    [def setObject:returnData forKey:u_key];
    [def synchronize];
}

@end
