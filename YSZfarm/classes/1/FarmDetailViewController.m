//
//  FarmDetailViewController.m
//  YSZfarm
//
//  Created by Mac on 2017/7/26.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "FarmDetailViewController.h"
#import "DetailTableCell.h"
#import "AFHTTPSessionManager.h"
#import "SwitcherTableViewCell.h"
#import "FarmDatabase.h"

#define indexSensor _sensorList[indexPath.row]

NSString *const dCellIdentifier = @"cellIDsecond";
NSString *const dTableCellNibName = @"DetailTableCell";

NSString *const sCellIdentifier = @"cellIDthird";
NSString *const sTableCellNibName = @"SwitcherTableViewCell";

@interface FarmDetailViewController ()

///@brife TLink Get获取的数据字典
@property (nonatomic,strong) NSDictionary *httpDataDictionary;

///@brife 定时器
@property (nonatomic) NSTimer *timer;



@end

@implementation FarmDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:dTableCellNibName bundle:nil] forCellReuseIdentifier:dCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:sTableCellNibName bundle:nil] forCellReuseIdentifier:sCellIdentifier];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.httpDataDictionary = [NSDictionary dictionary];
    
    _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    // 将定时器添加到runloop中，否则定时器不会启动
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
}

#pragma mark - UiTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sensorList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]] isEqualToString:@"1"]) {
        DetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:dCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:dTableCellNibName owner:self options:nil] lastObject];
        }
        
        cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
        
        cell.labelDetail.text =[NSString stringWithFormat:@"%@ %@",[indexSensor objectForKey:@"value"],[indexSensor objectForKey:@"unit"]];
        
        return cell;
        
    }else if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]] isEqualToString:@"2"])
    {
        SwitcherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:sTableCellNibName owner:self options:nil] lastObject];
        }
        
        cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
        
        cell.switcher.on = NO;
        [cell.switcher addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[indexSensor objectForKey:@"switcher"] isEqualToString:@"1"]) {
            cell.switcher.on = YES;
        }else{
            cell.switcher.on = NO;
        }
        
        return cell;
        
    }else if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]]  isEqualToString:@"5"]){
        SwitcherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:sTableCellNibName owner:self options:nil] lastObject];
        }
        
        cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
        if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"switcher"]] isEqualToString:@"1"]) {
            cell.switcher.on = YES;
        }else{
            cell.switcher.on = NO;
        }
        cell.switcher.enabled = NO;
        
        return cell;
        
    }else{
        return nil;
    }
    
}

#pragma mark -SetNavigationItem

- (void)setNavigationTitle:(NSString *)title{
    self.navigationItem.title = title;
}

#pragma mark -TLink数据操作

-(NSString *)getData:(NSString *)sensorId{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[@"http://api.tlink.io/tlink_interface/api/device/getDataPoint_" stringByAppendingFormat:@"%@%@",sensorId,@".htm"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        if (responseDic != nil) {
            self.httpDataDictionary = responseDic;
            [self.tableView reloadData];
        }
        /*NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
         NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"success:%@",daetr);*///json打印为中文
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    return [self.httpDataDictionary objectForKey:@"value"];
}

- (void)refreshData{
    void(^block)(void) = ^(){
        NSArray *sensorList = [[[FarmDatabase shareInstance] allDevices][_indexPath.row] objectForKey:@"sensorList"];
        _sensorList = sensorList;
        //_deviceNo = [[[FarmDatabase shareInstance] allDevices][_indexPath.row] objectForKey:@"deviceNo"];
        [self.tableView reloadData];
    };
    [[FarmDatabase shareInstance] getDeviceData:block];
}

- (void)switchAction:(UISwitch *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    if (sender.on == YES) {
        
    }else{
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://api.dtuip.com/qy/device/controlSwitchValue.html" parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
              
              NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
              NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
              NSLog(@"success123:%@",daetr);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error:%@",error);
          }];
}

@end
