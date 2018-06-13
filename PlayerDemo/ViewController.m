//
//  ViewController.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/15.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "ViewController.h"

#import "UserDefaultCenter.h"
#import "DownloadCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[DownloadCenter shareCenter] cacheFilesWithURL:@"http://static.missevan.com//128BIT/201506/27/bcf92338bbe1e48833a17867d9f24bdc170815.mp3"];
    [[DownloadCenter shareCenter] tryCacheFilesWithURL:@"http://static.missevan.com//128BIT/201506/27/bcf92338bbe1e48833a17867d9f24bdc170815.mp3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
