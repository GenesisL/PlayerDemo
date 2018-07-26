//
//  KeyChainManager.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/28.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

+ (NSString *)getDeviceIDInKeychain;

@end
