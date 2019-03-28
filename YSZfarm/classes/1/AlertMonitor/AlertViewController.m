//
//  AlertViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/2/26.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "AlertViewController.h"
#import "TouchTableView.h"
#import "AlertCell.h"
#import "MJRefresh.h"
#import "alertSectionView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WSDatePickerView.h"

NSString *const CellIdentifier_alert = @"CellID_alert";
NSString *const SectionIdentifier_alert = @"SectionHeader_alert";
NSString *const CellIdentifier_alertHis = @"CellID_alertHis";
NSString *const SectionIdentifier_alertHis = @"SectionHeader_alertHis";

@interface AlertViewController ()

@property (nonatomic, strong) UIView *historyView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *startTime;
@property (nonatomic, strong) UIButton *endTime;
@property (nonatomic, strong) WSDatePickerView *startDatePicker;
@property (nonatomic, strong) WSDatePickerView *endDatePicker;

///@brife MBProgressHUD
@property (nonatomic, strong) MBProgressHUD *HUD;

///@brife 当前报警
@property (nonatomic, strong) NSMutableArray *currentAlertArray;
@property (nonatomic, strong) UITableView *myTableView;
///@brife 历史报警
@property (nonatomic, strong) NSMutableArray *historyAlertArray;
@property (nonatomic, strong) UITableView *myHisTableView;

@end

@implementation AlertViewController
static int searchBarHeight = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:yColor_back];

    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 44 - 20 - 44 - 40)];
        //tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[AlertCell class] forCellReuseIdentifier:CellIdentifier_alert];
        [tableView registerClass:[alertSectionView class] forHeaderFooterViewReuseIdentifier:SectionIdentifier_alert];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAlert)];
        tableView.mj_header.automaticallyChangeAlpha = YES;
        [tableView.mj_header beginRefreshing];
         
        
        
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
        tableView;
    });
    
    [self createSegmentControl];
    [self historyView];
    [self setCurrentAlertArray];
    
    _myHisTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 40 + searchBarHeight, ScreenWidth, _historyView.bounds.size.height - 40 - searchBarHeight)];
        //tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[AlertCell class] forCellReuseIdentifier:CellIdentifier_alertHis];
        [tableView registerClass:[alertSectionView class] forHeaderFooterViewReuseIdentifier:SectionIdentifier_alertHis];
        
        [self.historyView addSubview:tableView];
        
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
        
        tableView;
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

//懒加载
- (UIView *)historyView{
    if (_historyView == nil) {
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.myTableView.bounds.size.width, self.myTableView.bounds.size.height)];
        _historyView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_historyView];
        if (_searchBar == nil) {
            self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchBarHeight)];
            self.searchBar.placeholder = LocalString(@"输入报警名称");
            [_historyView addSubview:self.searchBar];
            _historyView.hidden = YES;
        }
        if (_startTime == nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *datenow = [NSDate date];
            NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:datenow];
            NSString *lastDayTimeString = [formatter stringFromDate:lastDay];
            _startTime = [UIButton buttonWithTitle:lastDayTimeString titleColor:[UIColor blackColor]];
            [_startTime addTarget:self action:@selector(selectStartTime) forControlEvents:UIControlEventTouchUpInside];
            [_startTime setButtonStyle1];
            [_historyView addSubview:_startTime];
            [_startTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(150, 40));
                make.top.equalTo(_searchBar.mas_bottom);
                make.right.equalTo(self.view.mas_centerX).offset(-(40/375)*ScreenWidth);
            }];
        }
        if (_endTime == nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            _endTime = [UIButton buttonWithTitle:currentTimeString titleColor:[UIColor blackColor]];
            [_endTime setButtonStyle1];
            [_endTime addTarget:self action:@selector(selectEndTime) forControlEvents:UIControlEventTouchUpInside];
            [_historyView addSubview:_endTime];
            [_endTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(150, 40));
                make.top.equalTo(_searchBar.mas_bottom);
                make.left.equalTo(self.view.mas_centerX).offset((40/375)*ScreenWidth);
            }];
        }
    }
    return _historyView;
}

- (void)setMBHUD{
    _HUD = [MBProgressHUD showHUDAddedTo:self.historyView animated:YES];
    _HUD.label.text = LocalString(@"正在加载中...");
    _HUD.delegate = self;
    _HUD.margin = 0;
    _HUD.minSize = CGSizeMake(50, 50);
    [_HUD setSquare:YES];
    _HUD.completionBlock = ^{
        
    };
}


- (void)setCurrentAlertArray{
    if (_currentAlertArray == nil) {
        _currentAlertArray = [[NSMutableArray alloc] init];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        FarmDatabase *db = [FarmDatabase shareInstance];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = yHttpTimeoutInterval;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSString *url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/trigger/data/current?sn=%@",[FarmDatabase shareInstance].sn];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        
        [manager GET: url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            _currentAlertArray = responseDic[@"data"];
            
            [_currentAlertArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                db.alarmId = obj[@"id"];
            }];
            
            [_myTableView reloadData];
            [_myTableView.mj_header endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create Segmented Control
- (void)createSegmentControl{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"当前", @"历史", nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    segmentedControl.frame = CGRectMake((ScreenWidth - 200) / 2, 5, 200, 30);
    segmentedControl.selectedSegmentIndex = 0;
    //segmentedControl.tintColor = [UIColor colorWithRed:252/255.0 green:245/255.0 blue:248/255.0 alpha:1];
    
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            _myTableView.hidden = NO;
            _historyView.hidden = YES;
            break;
            
        case 1:
            _myTableView.hidden = YES;
            _historyView.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - Get current alert


#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_myHisTableView]) {
        return _historyAlertArray.count;
    }else{
        return _currentAlertArray.count;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_myHisTableView]) {
        NSDictionary *alertInfoDic = _historyAlertArray[indexPath.row];
        
        AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_alertHis];
        if ([alertInfoDic[@"content"] isKindOfClass:[NSString class]]) {
            cell.deviceName.text = alertInfoDic[@"content"];
        }
        cell.status.text = LocalString(@"已处理");

        if ([alertInfoDic[@"value"] isKindOfClass:[NSNumber class]]) {
            cell.data.text = [NSString stringWithFormat:@"%@",alertInfoDic[@"value"]];
        }
        if ([alertInfoDic[@"time"] isKindOfClass:[NSString class]]) {
            cell.time_ymd.text = [alertInfoDic[@"time"] substringWithRange:NSMakeRange(0, 10)];
            cell.time_hms.text = [alertInfoDic[@"time"] substringWithRange:NSMakeRange(11, 8)];
        }
        return cell;
    }else{
        NSDictionary *alertInfoDic = _currentAlertArray[indexPath.row];
        AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_alert];
        if ([alertInfoDic[@"content"] isKindOfClass:[NSString class]]) {
            cell.deviceName.text = alertInfoDic[@"content"];
        }
        if ([alertInfoDic[@"handleState"] intValue] == 0) {
            cell.status.text = LocalString(@"已处理");
        }else if ([alertInfoDic[@"handleState"] intValue] == 1){
            cell.status.text = LocalString(@"未处理");
        }else{
            cell.status.text = LocalString(@"未知");
        }
        if ([alertInfoDic[@"value"] isKindOfClass:[NSNumber class]]) {
            cell.data.text = [NSString stringWithFormat:@"%@",alertInfoDic[@"value"]];
        }
        if ([alertInfoDic[@"time"] isKindOfClass:[NSString class]]) {
            cell.time_ymd.text = [alertInfoDic[@"time"] substringWithRange:NSMakeRange(0, 10)];
            cell.time_hms.text = [alertInfoDic[@"time"] substringWithRange:NSMakeRange(11, 8)];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:_myTableView]) {
        
        NSDictionary *alertInfoDic = _currentAlertArray[indexPath.row];
        
        if ([[FarmDatabase shareInstance].auth isEqualToNumber:[NSNumber numberWithInt:4]]) {
            //判断用户对这个网关的权限
            NSLog(@"%@",LocalString(@"你没有这个权限"));
            [NSObject showHudTipStr:LocalString(@"你没有确认报警的权限")];
        }else{
            //显示提示框
            //过时
            //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
            //    [alert show];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"确认报警")
                                                                           message:LocalString(@"是否确定报警")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:LocalString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [_myTableView.mj_header beginRefreshing];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                NSDictionary *parameters = @{@"id":[FarmDatabase shareInstance].alarmId};
                [manager PUT:@"http://rijin.thingcom.com:80/api/v1/trigger/data/current" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                 {
                     NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                     NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                     NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"success:%@",daetr);
                     
                     _currentAlertArray = nil;
                     [self setCurrentAlertArray];
                     [_myTableView reloadData];
                     [_myTableView.mj_header endRefreshing];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"Error:%@",error);
                     [_myTableView.mj_header endRefreshing];
                     [NSObject showHudTipStr:LocalString(@"确认失败")];
                 }];
            }];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:LocalString(@"NO") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
            }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_myHisTableView]) {
        alertSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier: SectionIdentifier_alertHis];
        //view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        alertSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier: SectionIdentifier_alert];
        //view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
}

#pragma mark - tableview refresh
- (void)refreshAlert{
    _currentAlertArray = nil;
    [self setCurrentAlertArray];
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 时间选择按钮
- (void)selectStartTime{
    
    _startDatePicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [_startTime setTitle:dateString forState:UIControlStateNormal];
        
        [self setMBHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //获取历史报警
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",_startTime.titleLabel.text,@":00"] forHTTPHeaderField:@"startTime"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",_endTime.titleLabel.text,@":00"] forHTTPHeaderField:@"endTime"];
            [manager GET:@"http://rijin.thingcom.com:80/api/v1/trigger/data/history" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                _historyAlertArray = responseDic[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [_myHisTableView reloadData];
                });
                NSLog(@"%@",_historyAlertArray);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [_myHisTableView reloadData];
                });
            }];
        });
        
    }];
    _startDatePicker.dateLabelColor = [UIColor orangeColor];
    _startDatePicker.datePickerColor = [UIColor blackColor];
    _startDatePicker.doneButtonColor = [UIColor orangeColor];
    [_startDatePicker show];
}

- (void)selectEndTime{

    _endDatePicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        NSLog(@"时间%@",dateString);
        [_endTime setTitle:dateString forState:UIControlStateNormal];
        
        [self setMBHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //获取历史报警
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",_startTime.titleLabel.text,@":00"] forHTTPHeaderField:@"startTime"];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@%@",_endTime.titleLabel.text,@":00"] forHTTPHeaderField:@"endTime"];
            [manager GET:@"http://rijin.thingcom.com:80/api/v1/trigger/data/history" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                _historyAlertArray = responseDic[@"data"];
                
                NSLog(@"%@",_historyAlertArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [_myHisTableView reloadData];
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [_myHisTableView reloadData];
                });
            }];
        });
    }];
    _endDatePicker.dateLabelColor = [UIColor orangeColor];
    _endDatePicker.datePickerColor = [UIColor blackColor];
    _endDatePicker.doneButtonColor = [UIColor orangeColor];
    [_endDatePicker show];
}

@end
