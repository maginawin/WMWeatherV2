//
//  WMWeatherSet.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherSet.h"
#import "WMWeatherCity.h"

static NSString *const kWeatherSetCityName = @"com.maginawin.kWeatherSetCityName";
static NSString *const kWeatherSetCityWoeid = @"com.maginawin.kWeatherSetCityWoeid";
static NSString *const kWeatherSetTempType = @"com.maginawin.kWeatherSetTempType";

@implementation WMWeatherSet

+ (WMWeatherCity *)weatherSetCity {
    WMWeatherCity *city = [[WMWeatherCity alloc] init];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:kWeatherSetCityName];
    NSString *woeid = [[NSUserDefaults standardUserDefaults] valueForKey:kWeatherSetCityWoeid];
    
    if (name) {
        city.name = name;
    } else {
        city.name = @"请设置";
    }
    
    if (woeid) {
        city.woeid = woeid;
    }
    
    return city;
}

+ (void)setupWeatherSetCity:(WMWeatherCity *)city {
    if (!city) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:city.name forKey:kWeatherSetCityName];
    [[NSUserDefaults standardUserDefaults] setValue:city.woeid forKey:kWeatherSetCityWoeid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (WeatherSetTempType)weatherSetTempType {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kWeatherSetTempType];
}

+ (NSString *)weatherSetTempTypeString {
    NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:kWeatherSetTempType];
    
    if (type) {
        return @"℉";
    }
    
    return @"℃";
}

+ (NSString *)weatherSetTempTypeStringForSearch {
    NSInteger type = [[NSUserDefaults standardUserDefaults] integerForKey:kWeatherSetTempType];
    
    if (type) {
        return @"f";
    }
    
    return @"c";
}

+ (void)setupWeatherSetTempType:(WeatherSetTempType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:kWeatherSetTempType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
