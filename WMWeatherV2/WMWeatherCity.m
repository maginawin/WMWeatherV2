//
//  WMWeatherCity.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherCity.h"

@implementation WMWeatherCity

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.woeid = @"";
    }
    return self;
}

- (void)setupNameWithYahooString:(NSString *)yahooString {
    _name = [WMWeatherCity nameFromYahooString:yahooString];
}

- (void)setupWoeidWithYahooString:(NSString *)yahooString {
    _woeid = [WMWeatherCity woeidFromYahooString:yahooString];
}

+ (NSString *)nameFromYahooString:(NSString *)yahooString {
    if (!yahooString) {
        return @"---";
    }
    
    NSArray *firstSteps = [yahooString componentsSeparatedByString:@"="];
    
    if (firstSteps.count < 3) {
        return @"----";
    }
    
    return firstSteps.lastObject;
}

+ (NSString *)woeidFromYahooString:(NSString *)yahooString {
    if (!yahooString) {
        return @"";
    }
    
    NSArray *firstSteps = [yahooString componentsSeparatedByString:@"="];
    
    if (firstSteps.count < 3) {
        return @"";
    }
    
    NSString *acutalSep = firstSteps[2];
    NSArray *secondSteps = [acutalSep componentsSeparatedByString:@"&"];
    
    if (secondSteps.count < 1) {
        return @"";
    }
    
    return secondSteps.firstObject;
}

@end
