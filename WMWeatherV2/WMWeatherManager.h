//
//  WMWeatherManager.h
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "WMWeatherInfo.h"
#import "WMWeatherCity.h"

extern NSString *const kWeatherManagerNotiCityResponseStart;
extern NSString *const kWeatherManagerNotiCityResponseEnd;
extern NSString *const kWeatherManagerNotiWeatherResponseStart;
extern NSString *const kWeatherManagerNotiWeatherReponseEnd;

@interface WMWeatherManager : NSObject

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

+ (WMWeatherManager *)sharedInstance;

@property (strong, nonatomic) WMWeatherInfo *weatherInfo;

@property (strong, nonatomic) NSMutableArray *citys;

// Request Methods

- (void)requestCityWithName:(NSString *)name;

- (void)requestWeatherInfoWithCity:(WMWeatherCity *)city;

@end
