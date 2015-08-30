//
//  ViewController.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "ViewController.h"
#import "WMWeatherTVC.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *weatherButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Weather btn
    _weatherButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 120, 44)];
    [_weatherButton setTitle:@"Weather" forState:UIControlStateNormal];
    [_weatherButton addTarget:self action:@selector(weatherClick) forControlEvents:UIControlEventTouchUpInside];
    [_weatherButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_weatherButton];
}

- (void)weatherClick {
    WMWeatherTVC *weatherTVC = [[WMWeatherTVC alloc] initWithNibName:@"WMWeatherTVC" bundle:nil];
    
    [self.navigationController pushViewController:weatherTVC animated:YES];
}

@end
