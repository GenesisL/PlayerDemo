//
//  FileMD5Tools.h
//  PlayerDemo
//
//  Created by 林开宇 on 2018/6/25.
//  Copyright © 2018年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileMD5Tools : NSObject

+ (NSString *)fileMD5StringByFilePath:(NSString *)path;

@end
