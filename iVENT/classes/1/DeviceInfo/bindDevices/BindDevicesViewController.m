//
//  BindDevicesViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/8.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "BindDevicesViewController.h"
#import "BindDeviceTableViewCell.h"
#import "TouchTableView.h"

NSString *const CellIdentifier_BindDevices = @"CellID_BindDevices";


@interface BindDevicesViewController ()

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *bindDevicesArray;

@end

@implementation BindDevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:yColor_back];

    
    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[BindDeviceTableViewCell class] forCellReuseIdentifier:CellIdentifier_BindDevices];

        
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
    
    [self getBindDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get bind devices
- (void)getBindDevices{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
    [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/devices/bindDevices" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        _bindDevicesArray = responseDic[@"data"];
        [_myTableView reloadData];
        NSLog(@"%@",_bindDevicesArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        [_myTableView reloadData];
    }];
}

#pragma mark - tableview deelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _bindDevicesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BindDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_BindDevices];
    NSDictionary *bindDevice = _bindDevicesArray[indexPath.section];
    if ([bindDevice[@"isBind"] intValue] == 0) {
        cell.nameLabel.text = LocalString(@"未绑定设备");
        cell.typeLabel.text = LocalString(@"unkonwn");
        cell.comLabel = bindDevice[@"com"];
    }else{
        cell.nameLabel.text = bindDevice[@"bindDeviceName"];
        cell.typeLabel.text = bindDevice[@"bindDeviceType"];
        cell.comLabel.text = bindDevice[@"com"];
    }
    return cell;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
