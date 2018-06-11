//
//  RequestEngine.h
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/16.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestBlock)(id returnValue, NSError *error);

@interface RequestEngine : NSObject

//POST
+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed;

+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andConstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed;

//GET
+ (void)GETWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock) failed;


@end
