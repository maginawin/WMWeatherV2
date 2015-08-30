//
//  WMWeatherManager.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/29.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherManager.h"
#import "WMWeatherSet.h"

NSString *const kWeatherManagerNotiCityResponseStart = @"kWeatherManagerNotiCityResponseStart";
NSString *const kWeatherManagerNotiCityResponseEnd = @"kWeatherManagerNotiCityResponseEnd";
NSString *const kWeatherManagerNotiWeatherResponseStart = @"kWeatherManagerNotiWeatherResponseStart";
NSString *const kWeatherManagerNotiWeatherReponseEnd = @"kWeatherManagerNotiWeatherReponseEnd";

static NSString *const kCityRequestPrefix = @"http://sugg.us.search.yahoo.net/gossip-gl-location/?appid=weather&output=xml&command=";

static NSString *const kCityResponseRootElement = @"m";
static NSString *const kCityResponseDetailElement = @"s";
static NSString *const kCityResponseNameElement = @"k";
static NSString *const kCityResponseWoeidElement = @"d";

static NSString *const kWeatherResponseRootElement = @"rss";
static NSString *const kWeatherResponseDetailElement = @"yweather:condition";
static NSString *const kWeatherResponseDetailCode = @"code";
static NSString *const kWeatherResponseDetailTemperature = @"temp";
static NSString *const kWeatherResponseDetailDate = @"date";

@interface WMWeatherManager () <NSXMLParserDelegate>

@property (strong, nonatomic) WMWeatherCity *city;
@property (strong, nonatomic) NSString *currentString;

@end

@implementation WMWeatherManager

+ (WMWeatherManager *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance configureBase];
    });
    return sharedInstance;
}

#pragma mark - Request Methods

- (void)requestCityWithName:(NSString *)name {
    if (!name) {
        NSLog(@"Request city name is null");
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kCityRequestPrefix, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [_manager GET:urlString parameters:nil success:^ (AFHTTPRequestOperation * operation, id response) {
        NSXMLParser *parser = response;
        parser.delegate = self;
        [parser parse];
    } failure:^ (AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Request city with name error : %@", error);
    }];
}

- (void)requestWeatherInfoWithCity:(WMWeatherCity *)city {
    NSString *value0 = @"https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20weather.woeid%20WHERE%20w%3D%22";
    NSString *value1 = @"%22%20and%20u%3D%22";
    NSString *value2 = @"%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
    NSString *type = [WMWeatherSet weatherSetTempTypeStringForSearch];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@", value0, city.woeid, value1, type, value2];
    
    [_manager GET:urlString parameters:nil success:^ (AFHTTPRequestOperation * operation, id response) {
        NSXMLParser *parser = response;
        parser.delegate = self;
        [parser parse];
    } failure:^ (AFHTTPRequestOperation * operation, NSError * error) {
        NSLog(@"Request weather info with city %@ error : %@", city.name, error);
    }];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kWeatherResponseDetailElement]) {
        NSString *codeString = [NSString stringWithFormat:@"code%@", [attributeDict objectForKey:kWeatherResponseDetailCode]];
        _weatherInfo.information = NSLocalizedString(codeString, @"");
        _weatherInfo.temperature = [attributeDict objectForKey:kWeatherResponseDetailTemperature];
        _weatherInfo.updatedDate = [attributeDict objectForKey:kWeatherResponseDetailDate];
    }
    // City Roor
    else if ([elementName isEqualToString:kCityResponseRootElement]) {
        _citys = nil;
        _citys = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiCityResponseStart object:nil];
    }
    // City Detail
    else if ([elementName isEqualToString:kCityResponseDetailElement]) {
        _city = [[WMWeatherCity alloc] init];
       [_city setupNameWithYahooString:[attributeDict objectForKey:kCityResponseWoeidElement]];
       [_city setupWoeidWithYahooString:[attributeDict objectForKey:kCityResponseWoeidElement]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (string) {
        _currentString = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kWeatherResponseRootElement]) {
        // End Weather Request
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiWeatherReponseEnd object:_weatherInfo];
    }
    
    else if ([elementName isEqualToString:kCityResponseDetailElement]) {
        // End A City Detail
        [_citys addObject:_city];
        _city = nil;
    }
    
    else if ([elementName isEqualToString:kCityResponseRootElement]) {
        // End City Request
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeatherManagerNotiCityResponseEnd object:_citys];
    }
}

#pragma mark - Private

- (void)configureBase {
    _manager = [AFHTTPRequestOperationManager manager];
    // 设置解析器
    _manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    _citys = [NSMutableArray array];
    _weatherInfo = [[WMWeatherInfo alloc] init];
}

@end
