//
//  AppDelegate.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/15.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "AppDelegate.h"

#import <Sentry/Sentry.h>
#import <AVFoundation/AVFoundation.h>

#import "LGReachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //CrashCache
    [self crashCache];
    
    //注册后台播放
    [self registAudioSession];
    
    //NetWork Check
    [self netWorkCheck];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Funcation
- (void)crashCache {
    NSError *error = nil;
    SentryClient *client = [[SentryClient alloc] initWithDsn:@"https://4d3b3666546041fab1012e191ea8409e@sentry.io/1222103" didFailWithError:&error];
    SentryClient.sharedClient = client;
    [SentryClient.sharedClient startCrashHandlerWithError:&error];
    if (nil != error) {
        NSLog(@"%@", error);
    }
}

- (void)registAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)netWorkCheck {
    [LGReachability LGwithSuccessBlock:^(NSString* status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICENTER_NETWORKSTATUS object:nil userInfo:@{@"NetStatus": status}];
        if ([status isEqualToString:@"无连接"]) {
            
        }
        else if ([status isEqualToString:@"3G/4G网络"]) {
            
        }
        else if ([status isEqualToString:@"wifi状态下"]) {
            
        }
        
    }];
}


@end
