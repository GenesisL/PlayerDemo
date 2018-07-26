//
//  RequestEngine.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/16.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "RequestEngine.h"

#import "AppDelegate.h"

static AFHTTPRequestOperationManager *manager = nil;

@implementation RequestEngine

#pragma mark - dispatch_once
+ (AFHTTPRequestOperationManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:((AppDelegate *)[UIApplication sharedApplication].delegate).UUIDCache_S forHTTPHeaderField:@"equip-code"];
    });
    return manager;
}

#pragma mark - POST
+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] POST:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Header: %@", operation.request.allHTTPHeaderFields);
        NSLog(@"Fail Response: %@", operation.responseObject[@"info"]);
        failed(nil, error);
    }];
}

+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andConstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] POST:requestURLString parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Header: %@", operation.request.allHTTPHeaderFields);
        NSLog(@"Fail Response: %@", operation.responseObject[@"info"]);
        failed(nil, error);
    }];
}


#pragma mark - GET
+ (void)GETWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] GET:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"success"] boolValue]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Header: %@", operation.request.allHTTPHeaderFields);
        NSLog(@"Fail Response: %@", operation.responseObject[@"info"]);
        failed(nil, error);
    }];
}

#pragma mark - HEAD
+ (void)HEADWithRequestURL:(NSString *)requestURLString andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed {
    [[self sharedAFManager] HEAD:requestURLString parameters:nil success:^(AFHTTPRequestOperation *operation) {
        success(operation.response.allHeaderFields, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail Header: %@", operation.request.allHTTPHeaderFields);
        NSLog(@"Fail Response: %@", operation.responseObject[@"info"]);
        failed(operation.response.allHeaderFields, error);
    }];
}

@end
