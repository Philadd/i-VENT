//
//  DeviceInfoViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/2/28.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "TouchTableView.h"
#import "DeviceInfoCell.h"
#import "DeviceInfoExtendCell.h"
#import "NickNameViewController.h"
#import "BindDevicesViewController.h"

NSString *const CellIdentifier_DeviceInfo = @"CellID_DeviceInfo";
NSString *const CellNibName_DeviceInfo = @"DeviceInfoCell";
NSString *const CellIdentifier_DeviceInfoEx = @"CellID_DeviceInfoEx";
NSString *const CellNibName_DeviceInfoEx = @"DeviceInfoExtendCell";


@interface DeviceInfoViewController ()
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *group;

@property (nonatomic, strong) NSString *shareUser;
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShareUserString];
    
    self.view.backgroundColor = [UIColor colorWithHexString:yColor_back];
    
    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44 - 20 - 44)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:CellNibName_DeviceInfo bundle:nil] forCellReuseIdentifier:CellIdentifier_DeviceInfo];
        [tableView registerNib:[UINib nibWithNibName:CellNibName_DeviceInfoEx bundle:nil] forCellReuseIdentifier:CellIdentifier_DeviceInfoEx];
        
        [self.view addSubview:tableView];
        //tableView.estimatedRowHeight = 0;
        //tableView.estimatedSectionHeaderHeight = 0;
        //tableView.estimatedSectionFooterHeight = 0;
        
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView;
    });
    
    NSArray *group1 = [NSArray array];
    NSArray *group2 = [NSArray array];
    NSArray *group3 = [NSArray array];
    NSArray *group4 = [NSArray array];
    group1 = @[@"盒子别名"];
    group2 = @[@"分享自"];
    group3 = @[@"连接设备",@"系统设置"];
    group4 = @[@"产品序列号",@"联网方式",@"状态",@"所属分组",@"备注"];
    _group = [NSMutableArray arrayWithObjects:group1,group2,group3,group4, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setShareUserString{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
    [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/devices/owner" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *userNameArray = responseDic[@"data"];
        if (userNameArray.count >= 1) {
            NSDictionary *userName = userNameArray[0];
            _shareUser = userName[@"userName"];
            [_myTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _group.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *groupSec = _group[section];
    return groupSec.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DeviceInfoExtendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceInfoEx];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_DeviceInfoEx owner:self options:nil] lastObject];
        }
        NSArray *group1 = _group[0];
        cell.title.text = group1[0];
        cell.detail.text = [FarmDatabase shareInstance].nickName;
        return cell;
    }else if (indexPath.section == 1){
        DeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceInfo];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_DeviceInfo owner:self options:nil] lastObject];
        }
        NSArray *group2 = _group[1];
        cell.title.text = group2[0];
        
        if (_shareUser == nil) {
            cell.detail.text = LocalString(@"NONE");
        }else{
            cell.detail.text = _shareUser;
        }
        
        return cell;
    }else if (indexPath.section == 2){
        DeviceInfoExtendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceInfoEx];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_DeviceInfoEx owner:self options:nil] lastObject];
        }
        NSArray *group3 = _group[2];
        cell.title.text = group3[indexPath.row];
        return cell;
    }else{
        NSArray *group4 = _group[3];
        if (indexPath.row <= 3) {
            DeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceInfo];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_DeviceInfo owner:self options:nil] lastObject];
            }
            cell.title.text = group4[indexPath.row];
            if (indexPath.row == 0) {
                cell.detail.text = [FarmDatabase shareInstance].deviceId;
            }else if (indexPath.row == 1){
                if ([FarmDatabase shareInstance].connectType) {
                    cell.detail.text = [FarmDatabase shareInstance].connectType;
                }
            }else if (indexPath.row == 2){
                if ([[FarmDatabase shareInstance].online intValue] == 0) {
                    cell.detail.text = LocalString(@"离线");
                }else{
                    cell.detail.text = LocalString(@"在线");
                }
                
            }else if (indexPath.row == 3){
                cell.detail.text = [FarmDatabase shareInstance].groupName;
            }
            return cell;
        }else{
            DeviceInfoExtendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DeviceInfoEx];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_DeviceInfoEx owner:self options:nil] lastObject];
            }
            cell.title.text = group4[indexPath.row];
            cell.detail.text = @"";
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                if ([[FarmDatabase shareInstance].auth isEqualToNumber:[NSNumber numberWithInt:4]]) {
                    //判断用户对这个网关的权限
                    NSLog(@"%@",LocalString(@"你没有这个权限"));
                }else{
                    NickNameViewController *nickNameVC = [[NickNameViewController alloc] init];
                    DeviceInfoExtendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    nickNameVC.nickName = cell.detail.text;
                    [self.navigationController pushViewController:nickNameVC animated:YES];
                }
            }
            break;
            
        case 2:
            if (indexPath.row == 0) {
                BindDevicesViewController *bindDevicesVC = [[BindDevicesViewController alloc] init];
                [self.navigationController pushViewController:bindDevicesVC animated:YES];
            }
            
        default:
            break;
    }
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
