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
    
    //Cookies
    [self saveUUIDCookies];
    
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

-(void)saveUUIDCookies{
    if (self.UUIDCache_S) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:@"equip_code" forKey:NSHTTPCookieName];
        [cookieProperties setObject:self.UUIDCache_S forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@".missevan.com" forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:60*60*24*365] forKey:NSHTTPCookieExpires];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
}

- (NSString *)UUIDCache_S{
    if (!_UUIDCache_S) {
        NSString *UUIDCache = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUIDCache"];
        
        if (UUIDCache == nil) {
            UUIDCache = [UIDevice currentDevice].identifierForVendor.UUIDString.lowercaseString;
            if (UUIDCache&&UUIDCache.length>0) {
                [[NSUserDefaults standardUserDefaults] setObject:UUIDCache forKey:@"UUIDCache"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                UUIDCache = [NSString stringWithFormat:@"%0.0f%i",(double)([[NSDate date] timeIntervalSince1970]*1000),((int)arc4random_uniform((int)1000))];
                [[NSUserDefaults standardUserDefaults] setObject:UUIDCache forKey:@"UUIDCache"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        _UUIDCache_S = UUIDCache;
    }
    return _UUIDCache_S;
}


@end
