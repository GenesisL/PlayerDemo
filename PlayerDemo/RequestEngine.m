//
//  RequestEngine.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/16.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "RequestEngine.h"

static AFHTTPRequestOperationManager *manager = nil;

@implementation RequestEngine

#pragma mark - dispatch_once
+ (AFHTTPRequestOperationManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return manager;
}

#pragma mark - POST
+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] POST:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"success"] || [responseObject[@"state"] isEqualToString:@"success"]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil, error);
    }];
}

+ (void)POSTWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andConstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] POST:requestURLString parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"success"] || [responseObject[@"state"] isEqualToString:@"success"]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil, error);
    }];
}


#pragma mark - GET
+ (void)GETWithRequestURL:(NSString *)requestURLString andParameters:(NSDictionary *)parameters andSuccessBlock:(RequestBlock)success andFailedBlock:(RequestBlock)failed{
    [[self sharedAFManager] GET:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"status"] isEqualToString:@"success"] || [responseObject[@"state"] isEqualToString:@"success"]) {
            success(responseObject, nil);
        }else {
            failed(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failed(nil, error);
    }];
}

@end
