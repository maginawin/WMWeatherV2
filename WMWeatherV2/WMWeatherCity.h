//
//  WMWeatherCity.h
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMWeatherCity : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *woeid;

- (void)setupNameWithYahooString:(NSString *)yahooString;
- (void)setupWoeidWithYahooString:(NSString *)yahooString;

+ (NSString *)nameFromYahooString:(NSString *)yahooString;
+ (NSString *)woeidFromYahooString:(NSString *)yahooString;

@end
