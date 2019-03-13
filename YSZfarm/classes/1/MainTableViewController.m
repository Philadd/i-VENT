//
//  FirstViewController.m
//  YSZfarm
//
//  Created by Mac on 2017/7/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "MainTableViewController.h"
#import "FarmDatabase.h"
#import "FarmDetailViewController.h"
#import "TableCell.h"
#import "SectionView.h"
#import "SectionModel.h"
#import "CellModel.h"
#import "TouchTableView.h"
#import "DeviceDetailVIewController.h"
#import "UIViewController+MMDrawerController.h"


NSString *const kCellIdentifier_main = @"cellID_main";
NSString *const kCellIdentifier_mainSearch = @"cellID_mainSearch";
NSString *const kTableCellNibName = @"TableCell";
NSString *const kSectionIdentifier = @"sectionHeader";

@interface MainTableViewController()

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *sectionData;
@property (nonatomic, strong) NSMutableArray *apiKeyArray;

@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) UITableView *searchTableView;
@property (strong,nonatomic) NSMutableArray *searchData;

@end

@implementation MainTableViewController

static int searchBarHeight = 40;
static int apiKeyArrayCount = 0;


#pragma mark - life
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self viewLayout];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    void(^block)(NSDictionary *) = ^(NSDictionary *dic){
        [self sectionData:dic];
    };
    [[FarmDatabase shareInstance] getDeviceData:block];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(datapointAlarm) name:@"datapointAlarm" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"datapointAlarm" object:nil];
}

- (void)viewLayout
{
    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, searchBarHeight, ScreenWidth, ScreenHeight - searchBarHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[tableView registerClass:[WorktimeCell class] forCellReuseIdentifier:kCellIdentifier_WorkTime];
        [tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier_main];
        [tableView registerClass:[SectionView class] forHeaderFooterViewReuseIdentifier:kSectionIdentifier];
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        /*tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.myTableView.bounds.size.width, 30)];
        UILabel *noMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        noMoreLabel.text = @"没有更多了";
        noMoreLabel.font = [UIFont systemFontOfSize:15];
        [tableView.tableFooterView addSubview:noMoreLabel];
        noMoreLabel.center = tableView.tableFooterView.center;*/
        tableView;
    });
    //分割线全部显示
    /*if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
     [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
     }
     if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)])  {
     [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
     }*/

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchBarHeight)];
    self.searchBar.placeholder = LocalString(@"搜索");
    _searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    _searchTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, searchBarHeight, ScreenWidth, ScreenHeight - searchBarHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //[tableView registerClass:[WorktimeCell class] forCellReuseIdentifier:kCellIdentifier_WorkTime];
        [tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier_mainSearch];
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView.hidden = YES;
        tableView;
    });
    
    _searchData = [[NSMutableArray alloc] init];
}

//懒加载
- (NSMutableArray *)sectionData:(NSDictionary *)dic{
    if (_sectionData == nil) {
        
        if (_apiKeyArray == nil) {
            _apiKeyArray = [[NSMutableArray alloc] init];
        }
        _sectionData = [[NSMutableArray alloc]init];
        
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[dic objectForKey:@"data"] count] > 0) {
            [[dic objectForKey:@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SectionModel *model = [[SectionModel alloc] init];
                model.groupName = J2String([obj objectForKey:@"groupName"]);
                model.deviceGroupId = J2String(obj[@"deviceGroupId"]);
                NSLog(@"组%@", model.groupName);
                NSLog(@"设备%@", model.deviceGroupId);
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [obj[@"devices"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CellModel *cell = [[CellModel alloc] init];
                    if (obj[@"title"]) {
                        cell.title = J2String(obj[@"title"]);
                    }
                    if (obj[@"sn"]) {
                        cell.sn = J2String(obj[@"sn"]);
                    }
                    if (obj[@"deviceId"]) {
                        cell.deviceId = J2String(obj[@"deviceId"]);
                    }
                    if (obj[@"connectType"]) {
                        cell.connectType = J2String(obj[@"connectType"]);
                    }
                    if (obj[@"apiKey"]) {
                        cell.apiKey = J2String(obj[@"apiKey"]);
                    }
                    if ([_apiKeyArray containsObject:cell.apiKey]) {
                        
                    }else{
                        [_apiKeyArray addObject:cell.apiKey];
                    }
                    
                    if (obj[@"location"]) {
                        cell.location = obj[@"location"];
                    }
                    if (obj[@"auth"] && [obj[@"auth"] isKindOfClass:[NSNumber class]]) {
                        cell.auth = obj[@"auth"];
                    }else{
                        NSLog(@"auth不是number类型");
                    }
                    
                    [array addObject:cell];
                    
                }];
                model.cellArray = [array copy];
                [_sectionData addObject:model];
            }];
        }
        
        
        NSMutableArray *onenetDevicesArray = [[NSMutableArray alloc] init];
        apiKeyArrayCount = 0;
        NSLog(@"key %@",_apiKeyArray);
        
        if (_apiKeyArray.count > 0 ) {
            NSLog(@"我是谁");
            for (int i = 0; i < _apiKeyArray.count; i++) {
                NSString *apiKey = _apiKeyArray[i];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSString *url = [NSString stringWithFormat:@"http://api.heclouds.com/devices"];
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
                
                [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"api-key"];
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                    NSDictionary *oneNETDic = responseDic[@"data"];
                    NSLog(@"onenetdic%@",oneNETDic);
                    if ([oneNETDic[@"devices"] isKindOfClass:[NSArray class]]) {
                        [onenetDevicesArray addObjectsFromArray:oneNETDic[@"devices"]];
                        NSLog(@"devices%@",oneNETDic[@"devices"]);
                    }else{
                        NSLog(@"devices不是一个数组");
                    }
                    
                    if (apiKeyArrayCount == (_apiKeyArray.count - 1)) {
                        NSLog(@"%lu,%d",(unsigned long)_apiKeyArray.count,apiKeyArrayCount);
                        NSLog(@"进入online取值循环");
                        for (SectionModel *section in _sectionData) {
                            for (CellModel *cell in section.cellArray) {
                                for (NSDictionary *deviceInfo in onenetDevicesArray) {
                                    NSLog(@"在线nslog%@",deviceInfo);
                                    if ([cell.deviceId isEqualToString:deviceInfo[@"id"]]) {
                                        cell.online = deviceInfo[@"online"];
                                    }
                                }
                            }
                        }
                        [_myTableView reloadData];
                    }
                    apiKeyArrayCount++;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error:%@",error);
                }];
            }
        }
        
    }else{
        [_myTableView reloadData];
    }
    return _sectionData;
}
#pragma mark - resign keyboard control
/**
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    _searchTableView.hidden = YES;
    [self.myTableView resignFirstResponder];
    [_searchData removeAllObjects];
    [_searchTableView reloadData];
}
**/

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UiTableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _myTableView) {
        return self.sectionData.count;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        SectionModel *model = _sectionData[section];
        return model.isExpand?model.cellArray.count:0;
    }else{
        return _searchData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        TableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_main];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTableCellNibName owner:self options:nil] lastObject];
        }
        SectionModel *section = _sectionData[indexPath.section];
        CellModel *model = section.cellArray[indexPath.row];
        
        UIImage *farmImage = [UIImage imageNamed:@""];
        if ([model.online intValue] == 1) {
            farmImage = [UIImage imageNamed:@"online"];
        }else{
            farmImage = [UIImage imageNamed:@"offline"];
        }
        cell.farmImageView.image = farmImage;
        cell.farmNameLabel.text = model.title;
        
        if ([model.title isEqualToString:[FarmDatabase shareInstance].alarmGateway]) {
            cell.alarmLabel.hidden = NO;
        }
        
        return cell;
    }else{
        TableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_mainSearch];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:kTableCellNibName owner:self options:nil] lastObject];
        }
        CellModel *model = _searchData[indexPath.row];
        
        UIImage *farmImage = [UIImage imageNamed:@""];
        if ([model.online intValue] == 1) {
            farmImage = [UIImage imageNamed:@"online"];
        }else{
            farmImage = [UIImage imageNamed:@"offline"];
        }
        cell.farmImageView.image = farmImage;
        cell.farmNameLabel.text = model.title;
        
        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        if (_sectionData != nil) {
            SectionModel *section = _sectionData[indexPath.section];
            CellModel *cell = section.cellArray[indexPath.row];
            [FarmDatabase shareInstance].nickName = cell.title;
            [FarmDatabase shareInstance].groupName = section.groupName;
            
            AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
            [manager1.requestSerializer setValue:cell.apiKey forHTTPHeaderField:@"api-key"];
            NSString *url = [NSString stringWithFormat:@"http://api.heclouds.com/devices/datapoints"];
            NSDictionary *parameters = @{@"devIds":cell.deviceId};
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
            [manager1 GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                [[FarmDatabase shareInstance] setDeviceDicOnenet:responseDic];
                NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"success:%@",daetr);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
            }];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:cell.sn forHTTPHeaderField:@"sn"];
            [manager GET:@"http://rijin.thingcom.com:80/api/v1/relation/netgate/streams" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"success:%@",daetr);
                
                [[FarmDatabase shareInstance] setDeviceDic:responseDic];
                DeviceDetailVIewController *detailVC = [[DeviceDetailVIewController alloc]init];
                [FarmDatabase shareInstance].deviceId = cell.deviceId;
                [FarmDatabase shareInstance].apiKey = cell.apiKey;
                [FarmDatabase shareInstance].sn = cell.sn;
                [FarmDatabase shareInstance].auth = cell.auth;
                [FarmDatabase shareInstance].online = cell.online;
                [FarmDatabase shareInstance].connectType = cell.connectType;
                [self.navigationController pushViewController:detailVC animated:YES];
                
                TableCell *tablecell = [tableView cellForRowAtIndexPath:indexPath];
                SectionView *tableSection = (SectionView *)[tableView headerViewForSection:indexPath.section];
                if (tablecell.alarmLabel.hidden == NO) {
                    tablecell.alarmLabel.hidden = YES;
                    [FarmDatabase shareInstance].alarmGateway = nil;
                }
                if (tableSection.alarmLabel.hidden == NO) {
                    tableSection.alarmLabel.hidden = YES;
                    [FarmDatabase shareInstance].alarmGateway = nil;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
            }];
            
        }
    }else{
        CellModel *cell = _searchData[indexPath.row];
        [FarmDatabase shareInstance].nickName = cell.title;
        [FarmDatabase shareInstance].groupName = cell.groupName;
        
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        [manager1.requestSerializer setValue:cell.apiKey forHTTPHeaderField:@"api-key"];
        NSString *url = [NSString stringWithFormat:@"http://api.heclouds.com/devices/datapoints"];
        NSDictionary *parameters = @{@"devIds":cell.deviceId};
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        [manager1 GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            [[FarmDatabase shareInstance] setDeviceDicOnenet:responseDic];
            NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
            NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"success:%@",daetr);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:cell.sn forHTTPHeaderField:@"sn"];
     
        [manager GET:@"http://rijin.thingcom.com:80/api/v1/relation/netgate/streams" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
            NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"success:%@",daetr);
            
            [[FarmDatabase shareInstance] setDeviceDic:responseDic];
            DeviceDetailVIewController *detailVC = [[DeviceDetailVIewController alloc]init];
            [FarmDatabase shareInstance].deviceId = cell.deviceId;
            [FarmDatabase shareInstance].apiKey = cell.apiKey;
            [FarmDatabase shareInstance].sn = cell.sn;
            [FarmDatabase shareInstance].auth = cell.auth;
            [FarmDatabase shareInstance].online = cell.online;
            [FarmDatabase shareInstance].connectType = cell.connectType;
            [self.navigationController pushViewController:detailVC animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionIdentifier];
    SectionModel *model = _sectionData[section];
    view.model = model;
    [model.cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CellModel *cell = obj;
        if ([cell.title isEqualToString:[FarmDatabase shareInstance].alarmGateway]) {
            view.alarmLabel.hidden = NO;
        }
    }];
    //更变了section的cell数量，所以要刷新
    view.block = ^(BOOL isExpanded){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        return SectionViewHeight;
    }else{
        return 0;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - datapoint alarm

- (void)datapointAlarm{
    NSLog(@"adsfsd%@",[FarmDatabase shareInstance].alarmGateway);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_myTableView reloadData];
    });
}

#pragma mark - uisearchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchTableView.hidden = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _searchTableView.hidden = YES;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [_searchData removeAllObjects];
    [_searchTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    for (SectionModel *section in _sectionData) {
        for (CellModel *cell in section.cellArray) {
            if ([cell.title containsString:searchText]) {
                cell.groupName = section.groupName;
                [_searchData addObject:cell];
                [_searchTableView reloadData];
                NSLog(@"%@",cell.title);
            }
        }
    }
}

@end
