//
//  ViewController.m
//  PlayerDemo
//
//  Created by 林开宇 on 2017/6/15.
//  Copyright © 2017年 林开宇. All rights reserved.
//

#import "ViewController.h"
//Center
#import "PlayCenter.h"
//RequestEngine
#import "SoundRequestEngine.h"
//Model
#import "SoundModel.h"

@interface ViewController ()

@property (nonatomic, strong) PlayCenter *play_cen;

@property (nonatomic, strong) SoundModel *model;

@property (nonatomic, strong) UIButton *play_button;
@property (nonatomic, strong) UIButton *previous_button;
@property (nonatomic, strong) UIButton *next_button;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _play_cen = [PlayCenter mainCenter];
    
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CreateView
- (void)createView {
    [self.view addSubview:self.play_button];
    [self.play_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@44);
    }];
    [self.view addSubview:self.previous_button];
    [self.previous_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.play_button.mas_left).with.offset(-8);
        make.centerY.equalTo(self.play_button.mas_centerY);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@44);
    }];
    [self.view addSubview:self.next_button];
    [self.next_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.play_button.mas_right).with.offset(8);
        make.centerY.equalTo(self.play_button.mas_centerY);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@44);
    }];
}

#pragma mark - ButtonAction
- (void)playButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [SoundRequestEngine getSoundInfoWithSoundID:@"1" Success:^(id returnValue, NSError *error) {
        if ([returnValue[@"info"] isKindOfClass:[NSDictionary class]]) {
            weakSelf.model = [SoundModel initWithDic:returnValue[@"info"]];
            [weakSelf.play_cen checkStatusAndPlayWithModel:weakSelf.model];
        }
    } Failed:^(id returnValue, NSError *error) {
        NSLog(@"Failed: %@", returnValue);
    }];
}
- (void)previousButtonAction:(UIButton *)sender {
    
}
- (void)nextButtonAction:(UIButton *)sender {
    
}


#pragma mark - Get/Set
- (UIButton *)play_button {
    if (!_play_button) {
        _play_button = [UIButton new];
        _play_button.backgroundColor = [UIColor redColor];
        [_play_button addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play_button;
}
- (UIButton *)previous_button {
    if (!_previous_button) {
        _previous_button = [UIButton new];
        _previous_button.backgroundColor = [UIColor blueColor];
        [_previous_button addTarget:self action:@selector(previousButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previous_button;
}
- (UIButton *)next_button {
    if (!_next_button) {
        _next_button = [UIButton new];
        _next_button.backgroundColor = [UIColor greenColor];
        [_next_button addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _next_button;
}

@end
