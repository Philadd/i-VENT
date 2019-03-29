//
//  MapViewController.m
//  YSZfarm
//
//  Created by Mac on 2017/12/14.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "SectionModel.h"
#import "CellModel.h"
#import "UIViewController+MMDrawerController.h"
#import "DetailTabViewController.h"


@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (strong,nonatomic) BMKMapView *myMapView;
@property (strong,nonatomic) BMKLocationService *locationService;
@property (strong,nonatomic) NSMutableArray *sectionData;
@property (strong,nonatomic) NSMutableArray *annotationArray;

@property (nonatomic, strong) NSMutableArray *apiKeyArray;


@property (strong,nonatomic) UISearchBar *searchBar;
@end

@implementation MapViewController
static int searchBarHeight = 40;
static int apiKeyArrayCount = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myMapView viewWillAppear];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [self initMap];
    [self initSearchBar];
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
    
    _myMapView.delegate = self;
    if (_annotationArray == nil) {
        _annotationArray = [[NSMutableArray alloc] init];
    }
    void(^block)(NSDictionary *) = ^(NSDictionary *dic){
        [self sectionData:dic];
        
    };
    [[FarmDatabase shareInstance] getDeviceData:block];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        usleep(1000 * 1000);
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self loadData];
    //        });
    //    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [_myMapView viewWillDisappear];
    _myMapView.delegate = nil;
    _locationService.delegate = nil;
    _sectionData = nil;
}

#pragma mark - 用户网关的数据
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
                model.deviceGroupId = J2String(obj[@"groupId"]);
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [obj[@"devices"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CellModel *cell = [[CellModel alloc] init];
                    if (obj[@"sn"]) {
                        cell.sn = J2String(obj[@"sn"]);
                        NSLog(@"sn%@",cell.sn);
                    }
                    if (obj[@"deviceId"]) {
                        cell.deviceId = J2String(obj[@"deviceId"]);
                        NSLog(@"deviceId%@",cell.deviceId);
                    }
                    if (obj[@"name"]) {
                        cell.title = J2String(obj[@"name"]);
                    }
                    if (obj[@"online"]) {
                        cell.online = (obj[@"online"]);
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
        
        if (_apiKeyArray.count > 0 ) {
            
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
                        [self loadData];
                    }
                    apiKeyArrayCount++;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error:%@",error);
                }];
            }
        }
        
    }else{
        [self loadData];
    }
    return _sectionData;
}

- (void)loadData{
    NSLog(@"分区数据%@",_sectionData);
    for (SectionModel *section in _sectionData) {
        for (CellModel *cell in section.cellArray) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            [annotation setCoordinate:CLLocationCoordinate2DMake([cell.location[@"lat"] floatValue], [cell.location[@"lon"] floatValue])];
            //NSLog(@"%f",[cell.location[@"lon"] floatValue]);
            [annotation setTitle:cell.title];
            [annotation setSubtitle:cell.groupName];
            [_annotationArray addObject:annotation];
        }
    }
    [_myMapView addAnnotations:_annotationArray];
    
}

#pragma mark - init fuc
- (void)initMap{
    _myMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height)];
    self.myMapView.mapType = BMKMapTypeStandard;
    self.myMapView.userTrackingMode = BMKUserTrackingModeNone;
    self.myMapView.trafficEnabled = NO;
    self.myMapView.baiduHeatMapEnabled = NO;
    _myMapView.delegate = self;
    // 不显示比例尺
    _myMapView.showMapScaleBar = NO;
    
    _myMapView.baseIndoorMapEnabled = NO;
    // 开启定位
    _myMapView.showsUserLocation = YES;
    [_myMapView setZoomLevel:10];
    
    [self.view addSubview:self.myMapView];
}

- (void)initSearchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchBarHeight)];
    self.searchBar.placeholder = LocalString(@"搜索");
    [self.myMapView addSubview:self.searchBar];
    [self.myMapView bringSubviewToFront:self.searchBar];
}
#pragma mark - 搜索功能


#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 内存优化

#pragma mark - mkmapview delegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        for (SectionModel *section in _sectionData) {
            for (CellModel *cell in section.cellArray) {
                if ([annotation.title isEqualToString:cell.title] && ([cell.online intValue] == 0)) {
                    NSLog(@"BMKAnnotation设置颜色%@",cell.online);
                    annotationView.pinColor = BMKPinAnnotationColorRed;
                }
            }
        }
        
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = NO;          //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}

- (void)mapStatusDidChanged:(BMKMapView *)mapView{
    //    if (mapView.annotations == nil) {
    //        [self loadData];
    //    }
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.0001;
    region.span.longitudeDelta = 0.0001;
    
    _myMapView.centerCoordinate = userLocation.location.coordinate;//让地图的中心位置在这里
    //[_myMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];//出现动画效果
    
    [_myMapView setZoomEnabled:YES];
    [_myMapView setZoomEnabledWithTap:YES];
    
    
    //NSLog(@"定位的经度:%f,定位的纬度:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    _myMapView.showsUserLocation = YES;//显示用户位置
    [_myMapView updateLocationData:userLocation];//更新用户位置
    //[_locationService stopUserLocationService];//停止获取用户的位置
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    BMKPointAnnotation *annotation = view.annotation;
    NSLog(@"%@",annotation.title);
    
    if (_sectionData != nil) {
        for (SectionModel *section in _sectionData) {
            for (CellModel *cell in section.cellArray) {
                if ([cell.title isEqualToString:annotation.title]) {
                    [FarmDatabase shareInstance].nickName = cell.title;
                    [FarmDatabase shareInstance].groupName = section.groupName;
                    
                    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
                    [manager1.requestSerializer setValue:cell.apiKey forHTTPHeaderField:@"api-key"];
                    NSString *Url = [NSString stringWithFormat:@"http://api.heclouds.com/devices/datapoints"];
                    NSDictionary *parameters = @{@"devIds":cell.deviceId};
                    Url = [Url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
                    [manager1 GET:Url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                    NSString *url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/relation/netgate/streams?sn=%@",cell.sn];
                    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
                    
                    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                        NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                        NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"success:%@",daetr);
                        
                        [[FarmDatabase shareInstance] setDeviceDic:responseDic];
                        
                        DetailTabViewController *detailVC = [[DetailTabViewController alloc]init];
                        [FarmDatabase shareInstance].deviceId = cell.deviceId;
                        [FarmDatabase shareInstance].apiKey = cell.apiKey;
                        [FarmDatabase shareInstance].sn = cell.sn;
                        [FarmDatabase shareInstance].auth = cell.auth;
                        [FarmDatabase shareInstance].online = cell.online;
                        [self.navigationController pushViewController:detailVC animated:YES];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"Error:%@",error);
                    }];
                }
            }
        }
        
        
        
    }
}
@end
