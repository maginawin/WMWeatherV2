//
//  WMWeatherSet.h
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMWeatherCity;

typedef NS_ENUM(NSInteger, WeatherSetTempType) {
    WeatherSetTempC = 0,
    WeatherSetTempF = 1
};

@interface WMWeatherSet : NSObject

+ (WMWeatherCity *)weatherSetCity;
+ (void)setupWeatherSetCity:(WMWeatherCity *)city;

// 具体表现
+ (WeatherSetTempType)weatherSetTempType;
+ (NSString *)weatherSetTempTypeString;
+ (void)setupWeatherSetTempType:(WeatherSetTempType)type;
// 用来查询天气
+ (NSString *)weatherSetTempTypeStringForSearch;

@end
