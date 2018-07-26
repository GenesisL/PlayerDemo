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

static NSString * const cellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PlayCenter *play_cen;

@property (nonatomic, strong) SoundModel *model;

@property (nonatomic, strong) UITableView *albumTable;
@property (nonatomic, strong) NSArray *albumList;

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
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadData
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [SoundRequestEngine getSoundListDataWithAlbumID:@"190382" Success:^(id returnValue, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (returnValue[@"info"][@"Datas"] && [returnValue[@"info"][@"Datas"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *mAry = [NSMutableArray array];
            for (NSDictionary *dic in returnValue[@"info"][@"Datas"]) {
                SoundModel *model = [SoundModel initWithDic:dic];
                [mAry addObject:model];
            }
            strongSelf.albumList = [mAry copy];
        }
        [strongSelf.albumTable reloadData];
    } Failed:^(id returnValue, NSError *error) {
        NSLog(@"ReturnValue: %@", returnValue);
    }];
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
    
    [self.view addSubview:self.albumTable];
    [self.albumTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(20);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.play_button.mas_top).with.offset(-20);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = ((SoundModel *)_albumList[indexPath.row]).soundstr;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SoundModel *model = _albumList[indexPath.row];
    [_play_cen addDataToQueueWithModel:model];
    [_play_cen playAtIndex:[_play_cen searchIndexWithModel:model]];
}

#pragma mark - ButtonAction
- (void)playButtonAction:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    [SoundRequestEngine getSoundInfoWithSoundID:@"1" Success:^(id returnValue, NSError *error) {
//        __strong typeof(self) strongSelf = weakSelf;
//        if ([returnValue[@"info"] isKindOfClass:[NSDictionary class]]) {
//            strongSelf.model = [SoundModel initWithDic:returnValue[@"info"]];
//            [strongSelf.play_cen checkStatusAndPlayWithModel:strongSelf.model];
//        }
//    } Failed:^(id returnValue, NSError *error) {
//        NSLog(@"Failed: %@", returnValue);
//    }];
    [_play_cen play];
}
- (void)previousButtonAction:(UIButton *)sender {
    [_play_cen previous];
}
- (void)nextButtonAction:(UIButton *)sender {
    [_play_cen next];
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
- (UITableView *)albumTable {
    if (!_albumTable) {
        _albumTable = [UITableView new];
        _albumTable.dataSource = self;
        _albumTable.delegate = self;
        
        [_albumTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _albumTable;
}

@end
