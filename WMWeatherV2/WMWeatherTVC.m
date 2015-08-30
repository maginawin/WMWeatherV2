//
//  WMWeatherTVC.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherTVC.h"
#import "WMWeatherManager.h"
#import "WMWeatherSet.h"
#import "WMWeatherSetVC.h"
#import "WMWeatherSetTempVC.h"

static NSString *const kWeatherCellId = @"idWeatherCell";

@interface WMWeatherTVC ()

@end

@implementation WMWeatherTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBase];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    [[WMWeatherManager sharedInstance] requestWeatherInfoWithCity:[WMWeatherSet weatherSetCity]];
    
    [super viewWillAppear:animated];
}

#pragma mark - Selecotr

- (void)weatherManagerNotiWeatherReponseEnd:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source & Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            WMWeatherSetVC *setVC = [[WMWeatherSetVC alloc] initWithNibName:@"WMWeatherSetVC" bundle:nil];
            [self.navigationController pushViewController:setVC animated:YES];
            break;
        }
        case 2: {
            WMWeatherSetTempVC *tempVC = [[WMWeatherSetTempVC alloc] initWithNibName:@"WMWeatherSetTempVC" bundle:nil];
            [self.navigationController pushViewController:tempVC animated:YES];
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    switch (section) {
        case 0: {
            title = @"city";
            break;
        }
        case 3: {
            title = @"update date";
            break;
        }
        case 1: {
            title = @"weather";
            break;
        }
        case 2: {
            title = @"temperature";
            break;
        }
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kWeatherCellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = [WMWeatherSet weatherSetCity].name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            cell.detailTextLabel.text = @"";
            break;
        }
        case 3: {
            cell.textLabel.text = [WMWeatherManager sharedInstance].weatherInfo.updatedDate;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.detailTextLabel.text = @"";
            break;
        }
        case 1: {
            cell.textLabel.text = [WMWeatherManager sharedInstance].weatherInfo.information;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.detailTextLabel.text = @"";
            break;
        }
        case 2: {
            cell.textLabel.text = [WMWeatherManager sharedInstance].weatherInfo.temperature;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            cell.detailTextLabel.text = [WMWeatherSet weatherSetTempTypeString];
            break;
        }
    }
    
    return cell;
}

#pragma mark - Private

- (void)configureBase {
    //
    self.navigationItem.title = @"WEATHER";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // 接收到气预报的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherManagerNotiWeatherReponseEnd:) name:kWeatherManagerNotiWeatherReponseEnd object:nil];
}

@end
