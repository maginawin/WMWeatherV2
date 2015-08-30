//
//  WMWeatherSetVC.m
//  WMWeatherV2
//
//  Created by wangwendong on 15/8/30.
//  Copyright (c) 2015年 wangwendong. All rights reserved.
//

#import "WMWeatherSetVC.h"
#import "WMWeatherManager.h"
#import "WMWeatherSet.h"

static NSString *const kWeatherSetCellId = @"idWeatherSetCell";

@interface WMWeatherSetVC () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation WMWeatherSetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBase];
}

- (void)viewWillAppear:(BOOL)animated {
    [[WMWeatherManager sharedInstance].citys removeAllObjects];
    
    [_mTableView reloadData];
    
    [super viewWillAppear:animated];
}

#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchBar.text = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [[WMWeatherManager sharedInstance].citys removeAllObjects];
    _selectedIndexPath = nil;
    [_mTableView reloadData];
    
    [[WMWeatherManager sharedInstance] requestCityWithName:searchBar.text];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndexPath) {
        [tableView cellForRowAtIndexPath:_selectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedIndexPath = indexPath;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 300, 20)];
    header.text = [NSString stringWithFormat:@"AVAILABLE CITY : %d", (int)[WMWeatherManager sharedInstance].citys.count];
    header.textColor = [UIColor lightGrayColor];
    header.textAlignment = NSTextAlignmentLeft;
    header.font = [UIFont systemFontOfSize:15.f];
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    mView.backgroundColor = [UIColor whiteColor];
    [mView addSubview:header];
    return mView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WMWeatherManager sharedInstance].citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeatherSetCellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kWeatherSetCellId];
    }
    
    WMWeatherCity *city = [WMWeatherManager sharedInstance].citys[indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.woeid;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([city.woeid isEqualToString:[WMWeatherSet weatherSetCity].woeid]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedIndexPath = indexPath;
    }

    return cell;
}

#pragma mark - Selector

- (void)rightItemClick:(UIBarButtonItem *)sender {
    if (_selectedIndexPath) {
        WMWeatherCity *city = [WMWeatherManager sharedInstance].citys[_selectedIndexPath.row];
        
        [WMWeatherSet setupWeatherSetCity:city];
        
        [WMWeatherManager sharedInstance].weatherInfo = [[WMWeatherInfo alloc] init];
    }   
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)weatherManagerNotiCityResponseEnd {
    dispatch_async(dispatch_get_main_queue(), ^ {
        _selectedIndexPath = nil;
        
        [_mTableView reloadData];
    });
}

#pragma mark - Configure

- (void)configureBase {
    //
    self.navigationItem.title = @"CITY";
    
    _mTableView.tableFooterView = [[UIView alloc] init];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mSearchBar.delegate = self;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Notificaiton
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherManagerNotiCityResponseEnd) name:kWeatherManagerNotiCityResponseEnd object:nil];
}

@end
