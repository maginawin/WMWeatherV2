//
//  WMWeatherSetTempVC.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/30.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherSetTempVC.h"
#import "WMWeatherSet.h"

static NSString *const kWeatherSetTempVCCellId = @"idWeatherSetTempVCCellId";

@interface WMWeatherSetTempVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation WMWeatherSetTempVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath != _selectedIndexPath) {
        [tableView cellForRowAtIndexPath:_selectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [WMWeatherSet setupWeatherSetTempType:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"SELECT TYPE";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherSetTempVCCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeatherSetTempVCCellId];
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"℃";
            break;
        }
        case 1: {
            cell.textLabel.text = @"℉";
            break;
        }
    }
    
    NSInteger tempType = [WMWeatherSet weatherSetTempType];
    
    if (indexPath.row == tempType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Selector

- (void)rightClick:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Configure

- (void)configureBase {
    //
    self.navigationItem.title = @"TEMPERATURE";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = [UIColor whiteColor];
    
    // Right Item
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightClick:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
