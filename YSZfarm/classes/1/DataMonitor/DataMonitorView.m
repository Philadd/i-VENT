//
//  DataMonitorView.m
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "DataMonitorView.h"
#import "TouchTableView.h"
#import "DevieceDataCell.h"
#import "DeviceSectionView.h"
#import "DeviceSectionModel.h"
#import "DeviceCellModel.h"
#import "DatapointBitCell.h"
#import "DatapointBit16_32Cell.h"
#import "UnusualTableViewCell.h"
#import "controledMonitorModel.h"
#import "DatapointButtonFFCell.h"

NSString *const CellIdentifier_unusual = @"CellID_unusual";
NSString *const CellIdentifier_Datapoint = @"CellID_datapoint";
NSString *const CellIdentifier_DatapointBIt = @"CellID_datapointBit";
NSString *const CellIdentifier_DatapointButtonFF = @"CellID_datapointButtonFF";
NSString *const CellIdentifier_DatapointBit16_32 = @"CellID_datapointBit16_32";
NSString *const SectionIdentifier_device = @"SectionHeader_device";


@interface DataMonitorView ()
@property (nonatomic, strong) UITableView *myTableView;
//@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) NSMutableArray *sectionData;
@property (nonatomic, strong) NSDictionary *plcModelJson;
@property (nonatomic, strong) NSMutableArray *controledMonitors;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation DataMonitorView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewLayout];
    //[self bindDatapointStatus];
    
    _controledMonitors = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sectionData:[[FarmDatabase shareInstance] deviceDic]];
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadMonitorData) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewLayout{
//    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, ScreenWidth-2, 44)];
//    _statusLabel.text = LocalString(@"没有绑定的监控点状态");
//    _statusLabel.textAlignment = NSTextAlignmentCenter;
//    _statusLabel.layer.borderColor = [UIColor blackColor].CGColor;
//    _statusLabel.layer.borderWidth = 1.5f;
//    _statusLabel.layer.cornerRadius = 10.f;
//    [self.view addSubview:_statusLabel];
    
    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44 - 44 - 20 - 44)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[UnusualTableViewCell class] forCellReuseIdentifier:CellIdentifier_unusual];
        [tableView registerClass:[DevieceDataCell class] forCellReuseIdentifier:CellIdentifier_Datapoint];
        [tableView registerClass:[DatapointBitCell class] forCellReuseIdentifier:CellIdentifier_DatapointBIt];
        [tableView registerClass:[DatapointButtonFFCell class] forCellReuseIdentifier:CellIdentifier_DatapointButtonFF];
        [tableView registerClass:[DatapointBit16_32Cell class]
          forCellReuseIdentifier:CellIdentifier_DatapointBit16_32];
        [tableView registerClass:[DeviceSectionView class] forHeaderFooterViewReuseIdentifier:SectionIdentifier_device];
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //去掉没有数据的tableview分割线
        tableView.tableFooterView = [[UIView alloc] init];
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

#pragma mark - DataInit
//懒加载
- (NSMutableArray *)sectionData:(NSDictionary *)dic{
    if (_sectionData == nil) {
        _sectionData = [[NSMutableArray alloc]init];
        NSLog(@"监控%@",dic);
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[dic objectForKey:@"data"] count] > 0) {
            [[dic objectForKey:@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                DeviceSectionModel *model = [[DeviceSectionModel alloc] init];
                model.deviceGroupName = J2String([obj objectForKey:@"name"]);
                model.datapointGroupUid = J2String([obj objectForKey:@"mac"]);
                if (obj[@"mac"] && [obj[@"mac"] isKindOfClass:[NSNumber class]]) {
                    model.datapointGroupId = obj[@"mac"];
                }else{
                    NSLog(@"datapointGroupId不是number类型");
                }
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [obj[@"streams"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    DeviceCellModel *cell = [[DeviceCellModel alloc] init];
                    if (obj[@"name"]) {
                        cell.streamName = obj[@"name"];
                    }
                    if (obj[@"streamId"]) {
                        cell.streamId = J2String(obj[@"streamId"]);
                    }
                    if (obj[@"rw"]) {
                        cell.writeRead = J2String(obj[@"rw"]);
                        
                    }
                    if (obj[@"unit"]) {
                        cell.unit = J2String(obj[@"unit"]);
                    }
                    if (obj[@"sn"]) {
                        cell.sn = J2String(obj[@"sn"]);
                    }
                    if (obj[@"streamUid"]) {
                        cell.streamUid = J2String(obj[@"streamUid"]);
                    }
                    
                    if (obj[@"desc"]) {
                        cell.desc = J2String(obj[@"desc"]);
                    }
                    
                    if (obj[@"dataType"]) {
                        cell.dataType = J2String(obj[@"dataType"]);
                    }
                    if (obj[@"addressType"]) {
                        cell.addressType = J2String(obj[@"addressType"]);
                    }
                    if (obj[@"bindDeviceType"]) {
                        cell.bindDeviceType = J2String(obj[@"bindDeviceType"]);
                    }
                    if (obj[@"bindDeviceName"]) {
                        cell.bindDeviceName = J2String(obj[@"bindDeviceName"]);
                    }
                    if (obj[@"modbusCode"]) {
                        cell.modbusCode = J2String(obj[@"modbusCode"]);
                    }
                    if (obj[@"cmd"]) {
                        NSDictionary *cmdDic = obj[@"cmd"];
                        if (cmdDic[@"protocol"]) {
                            cell.protocol = J2String(cmdDic[@"protocol"]);
                        }
                    }
                    if (obj[@"state"] && [obj[@"state"] isKindOfClass:[NSNumber class]]) {
                        cell.state = obj[@"state"];
                    }else{
                        NSLog(@"state不是number类型");
                    }
                    if (obj[@"intBit"] && [obj[@"intBit"] isKindOfClass:[NSNumber class]]) {
                        cell.intBit = obj[@"intBit"];
                    }else{
                        NSLog(@"intBit不是number类型");
                    }
                    if (obj[@"decimalBit"] && [obj[@"decimalBit"] isKindOfClass:[NSNumber class]]) {
                        cell.decimalBit = obj[@"decimalBit"];
                    }else{
                        NSLog(@"decimalBit不是number类型");
                    }
                    if (obj[@"address"] && [obj[@"address"] isKindOfClass:[NSNumber class]]) {
                        cell.address = obj[@"address"];
                    }else{
                        NSLog(@"address不是number类型");
                    }
                    if (obj[@"slaveAdr"] && [obj[@"slaveAdr"] isKindOfClass:[NSNumber class]]) {
                        cell.slaveAdr = obj[@"slaveAdr"];
                    }else{
                        NSLog(@"slaveAdr不是number类型");
                    }
                    if (obj[@"modbusRegisterAdd"] && [obj[@"modbusRegisterAdd"] isKindOfClass:[NSNumber class]]) {
                        cell.modbusRegisterAdd = obj[@"modbusRegisterAdd"];
                    }else{
                        NSLog(@"modbusRegisterAdd不是number类型");
                    }
                    
                    if ([FarmDatabase shareInstance].deviceDicOnenet) {
                        NSArray *onenetDatapoints = [[NSArray alloc] init];
                        onenetDatapoints = [[[[FarmDatabase shareInstance].deviceDicOnenet objectForKey:@"data"] objectForKey:@"devices"] copy];
                        [[onenetDatapoints[0] objectForKey:@"datastreams"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj[@"id"] && [obj[@"id"] isEqualToString:[NSString stringWithFormat:@"8%@",[cell.streamId substringWithRange:NSMakeRange(1, 3)]]]) {
                                if (obj[@"value"] && ![obj[@"value"] intValue]) {
                                    cell.isUnusual = 1;//表示数据异常
                                }else{
                                    cell.isUnusual = 0;
                                }
                            }
                            if (obj[@"id"] && [obj[@"id"] isEqualToString:cell.streamId]) {
                                if (obj[@"value"] && [obj[@"value"] isKindOfClass:[NSNumber class]]) {
                                    if (_controledMonitors.count > 0) {
                                        
                                        int hasConmodel = 0;//判断是否有conmodel；
                                        
                                        for (int i = 0; i < _controledMonitors
                                             .count; i++) {
                                            
                                            controledMonitorModel *conModel = _controledMonitors[i];
                                            if ([conModel.streamId isEqualToString:cell.streamId]) {
                                                
                                                hasConmodel = 1;//存在该监控点conmodel；
                                                
                                                if ([obj[@"value"] intValue] == [conModel.modifyValue intValue]) {
                                                    cell.value = obj[@"value"];
                                                    [_controledMonitors removeObject:conModel];
                                                    break;
                                                }
                                                if (conModel.judgeNum) {
                                                    cell.value = conModel.modifyValue;
                                                    
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                        if (!conModel.timeInterval) {
                                                            conModel.timeInterval = 0;
                                                        }
                                                        usleep(4000 * 1000 * ++conModel.timeInterval);
                                                        
                                                        conModel.judgeNum--;
                                                        
                                                        if (conModel.resendTime != 3 && [_controledMonitors containsObject:conModel]) {
                                                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                                            [manager.requestSerializer setValue:[FarmDatabase shareInstance].apiKey forHTTPHeaderField:@"api-key"];
                                                            
                                                            [manager POST:conModel.url parameters:conModel.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                                             {
                                                                 NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                                                                 NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                                                                 NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSLog(@"success:%@",daetr);
                                                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                 NSLog(@"Error:%@",error);
                                                             }];
                                                            conModel.resendTime++;
                                                            conModel.judgeNum = 3;
                                                        }
                                                    });
                                                    
                                                    
                                                    break;
                                                }else{
                                                    cell.value = obj[@"value"];
                                                    [_controledMonitors removeObject:conModel];
                                                    break;
                                                }
                                            }
                                        }
                                        if (!hasConmodel) {
                                            cell.value = obj[@"value"];
                                        }
                                    }else{
                                        cell.value = obj[@"value"];
                                    }
                                }else{
                                    NSLog(@"value不是number类型");
                                }
                            }
                        }];
                    }
                    
                    [array addObject:cell];
                }];
                model.cellArray = [array copy];
                [_sectionData addObject:model];
                NSLog(@"我的数组%@",model.cellArray);
                
            }];
        }
        
    }
    return _sectionData;
    
}


- (void)reloadMonitorData{
   // [self bindDatapointStatus];//刷新状态栏
    
    /*
     *在刷新前保存之前表格section的展开状态，
     *重新取数据后再将值重新赋给新数组，
     *这样就不会在刷新表格后二层表格折叠回去了
     */
    NSMutableDictionary *isExpandDic = [[NSMutableDictionary alloc] init];
    [_sectionData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DeviceSectionModel *model = (DeviceSectionModel *)obj;
        [isExpandDic setValue:model forKey:model.datapointGroupUid];
    }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
    
    NSString *url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/relation/netgate/streams?sn=%@",[FarmDatabase shareInstance].sn];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
        NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"success:%@",daetr);
        [[FarmDatabase shareInstance] setDeviceDic:responseDic];
        NSLog(@"返回数据%@",responseDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    [manager1.requestSerializer setValue:[FarmDatabase shareInstance].apiKey forHTTPHeaderField:@"api-key"];
    NSString *Url = [NSString stringWithFormat:@"http://api.heclouds.com/devices/datapoints"];
    NSDictionary *parameters = @{@"devIds":[FarmDatabase shareInstance].deviceId};
    Url = [Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    [manager1 GET:Url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        [[FarmDatabase shareInstance] setDeviceDicOnenet:responseDic];
        _sectionData = nil;
        [self sectionData:[[FarmDatabase shareInstance] deviceDic]];
        [_sectionData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DeviceSectionModel *model = (DeviceSectionModel *)obj;
            if ([isExpandDic objectForKey:model.datapointGroupUid]) {
                DeviceSectionModel *modelOld = (DeviceSectionModel *)[isExpandDic objectForKey:model.datapointGroupUid];
                model.isExpand = modelOld.isExpand;
            }
        }];
        [_myTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}

/*- (void)bindDatapointStatus{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
    [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/devices/eventBind" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *bindDataArray = responseDic[@"data"];
        if (bindDataArray.count >= 1 ) {
            NSDictionary *bindData = bindDataArray[0];
            if ([bindData[@"isBind"] intValue] == 1) {
                _statusLabel.text = LocalString(@"没有绑定寄存器信息");
            }else{
                [_sectionData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    DeviceSectionModel *model = obj;
                    [model.cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        DeviceCellModel *datapoint = obj;
                        if ([datapoint.address intValue] == [bindData[@"address"] intValue]) {
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
                            [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/devices/event" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                                NSMutableArray *statusCodeArray = responseDic[@"data"];
                                [statusCodeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if ([obj[@"eventId"] intValue] == [datapoint.value intValue]) {
                                        _statusLabel.text = J2String(obj[@"content"]);
                                    }
                                }];
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                NSLog(@"Error:%@",error);
                            }];
                        }
                    }];
                }];
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}*/

#pragma mark - UiTableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DeviceSectionModel *model = _sectionData[section];
    return model.isExpand?model.cellArray.count + 1:0;
}
//显示内容细节
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DevieceDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_Datapoint];
        cell.deviceName.text = LocalString(@"监控点名称");
        cell.monitorData.text = LocalString(@"数据");
        return cell;
    }
    DeviceSectionModel *section = _sectionData[indexPath.section];
    DeviceCellModel *model = section.cellArray[indexPath.row - 1];
    if (model.isUnusual) {
        UnusualTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_unusual];
        cell.dataMonitorName.text = model.streamName;
        return cell;
    }
    NSLog(@"读写操作%@",model.writeRead);
    
    if ([model.writeRead intValue] == 0) {
        if ([model.dataType intValue] == 1){
            DatapointBitCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DatapointBIt];
            cell.dataMonitorName.text = model.streamName;
            
            if ([[FarmDatabase shareInstance].auth isEqualToNumber:[NSNumber numberWithInt:4]]) {
                //判断用户对这个网关的权限
                cell.dataMonitorSwitch.enabled = NO;
            }
            
            if ([model.bindDeviceType isEqualToString:@"local"]){
                if ([model.value intValue]) {
                    cell.dataMonitorSwitch.on = YES;
                }else{
                    cell.dataMonitorSwitch.on = NO;
                }
            }else{
                if ([model.value intValue] % 2) {
                    cell.dataMonitorSwitch.on = YES;
                }else{
                    cell.dataMonitorSwitch.on = NO;
                }
            }
            cell.dataMonitorSwitch.enabled = NO;
            return cell;
        }else{
            DevieceDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_Datapoint];
            cell.deviceName.text = model.streamName;
            if (model.value) {
                if (model.unit) {
                    cell.monitorData.text = [NSString stringWithFormat:@"%@%@",model.value,model.unit];
                }else{
                    cell.monitorData.text = [NSString stringWithFormat:@"%@",model.value];
                }
                
            }else{
                cell.monitorData.text = @"NULL";
            }
            return cell;
        }
    }else{
        if ([model.dataType intValue] == 0) {
            DatapointBit16_32Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DatapointBit16_32];
            cell.dataMonitorName.text = model.streamName;
            if (model.value) {
                cell.dataMonitorDataTF.text = [NSString stringWithFormat:@"%@%@",model.value,model.unit];
            }else{
                cell.dataMonitorDataTF.text = @"NULL";
            }
            cell.dataMonitorDataTF.enabled = NO;
            return cell;
        }else if ([model.dataType intValue] == 1){
            DatapointBitCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DatapointBIt];
            cell.dataMonitorName.text = model.streamName;
            if ([[FarmDatabase shareInstance].auth isEqualToNumber:[NSNumber numberWithInt:4]]) {
                //判断用户对这个网关的权限
                cell.dataMonitorSwitch.enabled = NO;
            }
            
            if ([model.bindDeviceType isEqualToString:@"local"]){
                if ([model.value intValue]) {
                    cell.dataMonitorSwitch.on = YES;
                }else{
                    cell.dataMonitorSwitch.on = NO;
                }
            }else{
                if ([model.value intValue] % 2) {
                    cell.dataMonitorSwitch.on = YES;
                }else{
                    cell.dataMonitorSwitch.on = NO;
                }
            }
            cell.dataMonitorSwitch.enabled = NO;
            return cell;
        }else if ([model.dataType intValue] == 2){
            DatapointButtonFFCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_DatapointButtonFF];
            cell.dataMonitorName.text = model.streamName;
            return cell;
            
        }else{
            DevieceDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_Datapoint];
            cell.deviceName.text = model.streamName;
            if (model.value) {
                cell.monitorData.text = [NSString stringWithFormat:@"%@%@",model.value,model.unit];
            }else{
                cell.monitorData.text = @"NULL";
            }
            return cell;
        }
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*NSArray *sensorList = [[[FarmDatabase shareInstance] allDevices][indexPath.row] objectForKey:@"sensorList"];
     _farmItem = self.farmList[indexPath.row];
     
     FarmDetailViewController *detailVC = [[FarmDetailViewController alloc] init];
     detailVC.sensorList = sensorList;
     //detailVC.deviceNo = [[[FarmDatabase shareInstance] allDevices][indexPath.row] objectForKey:@"deviceNo"];
     detailVC.indexPath = indexPath;
     [detailVC setNavigationTitle:self.farmItem.farmName];
     
     [self.navigationController pushViewController:detailVC animated:YES];*/
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DeviceSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionIdentifier_device];
    DeviceSectionModel *model = _sectionData[section];
    view.model = model;
    //更变了section的cell数量，所以要刷新
    view.block = ^(BOOL isExpanded){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SectionViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}


#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataMonitorDataTFDone" object:nil userInfo:nil];
    
}


@end
