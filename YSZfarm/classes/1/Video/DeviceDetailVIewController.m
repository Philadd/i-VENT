//
//  ThirdVIewController.m
//  YSZfarm
//
//  Created by Mac on 2017/7/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "DeviceDetailVIewController.h"
#import "EZOpenSDK.h"
#import "EZUIKit.h"
#import "EZPlayer.h"
#import "EZUIPlayer.h"
#import "EZUIError.h"
#import "AppDelegate.h"
#import "EZAccessToken.h"
#import "EZDeviceInfo.h"
#import "EZCameraInfo.h"
#import "FarmDatabase.h"
#import "SliderTabBarView.h"
#import "DetailTabViewController.h"
#import "smallImageButton.h"

NSString *const CellIdentifier_cameraList = @"CellID_cameraList";


@interface DeviceDetailVIewController() <EZPlayerDelegate>

///@brife api获取摄像头视频列表以及accesstoken
@property (nonatomic, strong) NSMutableArray *cameraList;
@property (nonatomic, strong) NSString *deviceSerial;
@property (nonatomic, strong) EZUIPlayer *nPlayer;

///@brife 视频播放状态
@property (nonatomic) BOOL isPlaying;
///@brife 监控播放代理
@property (nonatomic,strong) EZPlayer *player;
///@brife 监控设备信息
@property (nonatomic,strong) EZDeviceInfo *hikDeviceInfo;
///@brife 监控设备关联的摄像头信息
@property (nonatomic, strong) EZCameraInfo *cameraInfo;

///@brife scrollView
@property (nonatomic,strong) UIScrollView *myScrollView;
@property (nonatomic,strong)  UIView *playView;
@property (nonatomic,strong) UIView *infoView;
@property (nonatomic,strong)  UIButton *playButton;

///@brife 视频的工具栏
@property (nonatomic,strong)  UIButton *collapseBtn;
@property (nonatomic,strong)  UIView *toolBarView;
@property (nonatomic,strong)  UIButton *playBtn;
@property (nonatomic,strong)  UIButton *voiceBtn;
@property (nonatomic,strong)  UIButton *emptyBtn;
@property (nonatomic,strong)  UIButton *qualityBtn;
@property (nonatomic,strong)  UIButton *largeBtn;

///@brife 播放页面的标题栏
@property (nonatomic,strong)  UILabel *largeTitleLabel;

///@brife 监控获取的设备Array
@property (nonatomic,strong) NSMutableArray *hikDeviceList;

///@brife 视频下方滑动控制页面
@property (strong,nonatomic) SliderTabBarView *slideTabBarView;

///@brife scrollView的总页数
@property (assign) NSInteger tabCount;

///@brife 定时器
@property (nonatomic) NSTimer *slideTimer;

///@brife 视频标题
@property (nonatomic,copy) NSString *videoTitle;

///@brife 摄像头列表view
@property (nonatomic, strong) UIView *cameraListView;
@property (nonatomic, strong) UITableView *cameraListTable;


@end

@implementation DeviceDetailVIewController

static int playViewHeight = 200;

- (void)dealloc{
    NSLog(@"%@ dealloc", self.class);
    [EZOPENSDK releasePlayer:_player];
    if (_nPlayer) {
        [_nPlayer stopPlay];
        _nPlayer = nil;
    }
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设备管理";
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:[UIImage imageNamed:@"视频列表"] forState:0];
    cameraBtn.frame = CGRectMake(0, 0, 30, 30);
    [cameraBtn setSelected:NO];
    [cameraBtn addTarget:self action:@selector(cameraSelectList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    self.navigationItem.rightBarButtonItem= rightItem;

    [self viewLayout];
    
    
    if (!self.hikDeviceList) {
        self.hikDeviceList = [NSMutableArray array];
    }
    
    //[self startRealPlay];
    [self startRealPlay_o];
    
    /***视频view里添加信息
     _largeTitleLabel.text = self.videoTitle;
    [self.view bringSubviewToFront:_largeTitleLabel];
    self.playBtn.enabled = NO;
    [self.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
     ***/
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_nPlayer stopPlay];
}

- (void)viewLayout{
    _myScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 ,0 ,ScreenWidth , ScreenHeight)];
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + playViewHeight - 64);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        //scrollView.delegate = self;
        scrollView;
    });
    [self.view addSubview:_myScrollView];
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    _playView.backgroundColor = [UIColor blackColor];
    [_myScrollView addSubview:_playView];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    _playButton.frame = CGRectMake(ScreenWidth / 2 - 30, 70, 80, 60);
    _playButton.hidden = YES;
    [_playButton addTarget:self action:@selector(playNPlayer) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_playButton];
    [_myScrollView bringSubviewToFront:_playButton];
    
    _collapseBtn = [[smallImageButton alloc] init];
    [_collapseBtn setTitle:LocalString(@"收起") forState:UIControlStateNormal];
    [_collapseBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateNormal];
    _collapseBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [_collapseBtn setTintColor:[UIColor whiteColor]];
    [_collapseBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    _collapseBtn.backgroundColor = [UIColor blackColor];
    _collapseBtn.alpha = 0.8;
    [_collapseBtn setButtonStyleWithColor:[UIColor whiteColor] Width:1.0 cornerRadius:15.0];
    [_collapseBtn addTarget:self action:@selector(collapseBtnPlayView) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_collapseBtn];
    [_myScrollView bringSubviewToFront:_collapseBtn];
    [_collapseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.top.equalTo(self.playView.mas_top);
        make.right.equalTo(self.playView.mas_right);
    }];
    
    DetailTabViewController *mainVc = [[DetailTabViewController alloc]init];
    mainVc.block = ^{
        [UIView animateWithDuration:0.5 animations:^{
            _myScrollView.contentOffset = CGPointMake(0, -64);
        }];
        _collapseBtn.enabled = !_collapseBtn.enabled;
        _myScrollView.scrollEnabled = !_myScrollView.scrollEnabled;
    };
    //mainVc.view.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight);
    [self addChildViewController:mainVc];
    [_myScrollView addSubview:mainVc.view];
    
    _cameraListView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, 0, 0)];
    _cameraListView.backgroundColor = [UIColor whiteColor];
    _cameraListView.alpha = 1;
    [_myScrollView addSubview:_cameraListView];
    
    
    _cameraListTable = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier_cameraList];
        
        [self.cameraListView addSubview:tableView];
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //tableView.scrollEnabled = NO;
        //tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, tableView.bounds.size.width, 30)];
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView;
    });
}

#pragma mark -- 获取监控信息并播放
/**
 **使用webkit的sdk包
 **/
- (void)startRealPlay{
    __weak typeof(self) weakSelf = self;
    
    if ([[FarmDatabase shareInstance] getAccessToken]) {
        [EZOPENSDK setAccessToken:[[FarmDatabase shareInstance] getAccessToken]];
        //_player = [EZOPENSDK createPlayerWithDeviceSerial:@"781802782" cameraNo:1];
        self.videoTitle = [[FarmDatabase shareInstance] getCameraName];
        
        _player = [EZOPENSDK createPlayerWithDeviceSerial:[[FarmDatabase shareInstance] getDeviceSerial] cameraNo:[[FarmDatabase shareInstance] getCameraNo]];
        _player.delegate = self;
        [_player setPlayVerifyCode:@"LWAFXI"];
        [_player setPlayerView:_playView];
        [_player startRealPlay];
        NSLog(@"设备信息3：%@",self.player);
        return;
    }else{
        [EZOPENSDK openLoginPage:^(EZAccessToken *accessToken) {
            //[[FarmDatabase shareInstance] setAccessToken:accessToken.accessToken];
            [EZOPENSDK setAccessToken:accessToken.accessToken];
            
            if (accessToken.accessToken) {
                
                [EZOpenSDK getDeviceList:0 pageSize:5 completion:^(NSArray *hikDeviceList, NSInteger totalCount, NSError *error) {
                    [weakSelf.hikDeviceList removeAllObjects];
                    [weakSelf.hikDeviceList addObjectsFromArray:hikDeviceList];
                }];
                
                if (weakSelf.hikDeviceList != NULL) {
                    _hikDeviceInfo = [weakSelf.hikDeviceList objectAtIndex:1];
                    _cameraInfo = [self.hikDeviceInfo.cameraInfo objectAtIndex:0];
                }
                
                [[FarmDatabase shareInstance] setAccessToken:accessToken.accessToken cameraInfo:_cameraInfo];
                
                NSLog(@"设备信息3：%@",self.cameraInfo);
                
                
                _player = [EZOPENSDK createPlayerWithDeviceSerial:self.cameraInfo.deviceSerial cameraNo:self.cameraInfo.cameraNo];
                _player.delegate = self;
                
                [_player setPlayVerifyCode:@"LWAFXI"];
                
                [_player setPlayerView:_playView];
                [_player startRealPlay];
                
            }
        }];
        return;
    }
}

/**
 **使用appkey和secret
 **/
- (void)startRealPlay_o{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[FarmDatabase shareInstance].sn forHTTPHeaderField:@"sn"];
    [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/camera/netgate" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        _cameraList = responseDic[@"data"];
        [_cameraListTable reloadData];
        NSLog(@"%@",responseDic);
        if (_cameraList.count > 0) {
            NSDictionary *cameraDic = _cameraList[0];
            _deviceSerial = J2String(cameraDic[@"deviceSerial"]);
            NSString *cameraURL = [NSString stringWithFormat:@"ezopen://open.ys7.com/%@/%@.live",_deviceSerial,J2String(cameraDic[@"channelNo"])];
            [[FarmDatabase shareInstance] setDeviceSerial:J2String(cameraDic[@"deviceSerial"])];
            [[FarmDatabase shareInstance] setCameraNo:[cameraDic[@"channelNo"] integerValue]];
            [self getAccessTokenByApi:J2String(cameraDic[@"deviceSerial"]) cameraURL:cameraURL];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

- (void)getAccessTokenByApi:(NSString *)deviceSerial cameraURL:(NSString *)cameraURL{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:deviceSerial forHTTPHeaderField:@"deviceSerial"];
    [manager GET:@"http://iotapi.thingcom.com:8080/dataPlatform/camera/token" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSArray *accesstokenArray = responseDic[@"data"];
        if (accesstokenArray.count > 0) {
            NSDictionary *camera = accesstokenArray[0];
            NSString *accessToken = J2String(camera[@"accessToken"]);
            
            [EZUIKit initWithAppKey:J2String(camera[@"appKey"])];
            [EZUIKit setAccessToken:accessToken];
            
            _nPlayer = [EZUIPlayer createPlayerWithUrl:cameraURL];
            _nPlayer.mDelegate = self;
            [_playView addSubview:_nPlayer.previewView];
            [_nPlayer setPreviewFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            [_nPlayer startPlay];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
}

- (void)stopNPlayer{
    [_nPlayer stopPlay];
    _playButton.hidden = NO;
}

- (void)playNPlayer{
    [_nPlayer startPlay];
    _playButton.hidden = YES;
}

- (void)playBtnClicked:(id)sender{
    if (_isPlaying) {
        [_player stopRealPlay];
        [_playView setBackgroundColor:[UIColor blackColor]];
        [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
    else{
        [_player startRealPlay];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
    _isPlaying = !_isPlaying;
}

#pragma mark - ezopenplayer delegate

- (void)player:(EZPlayer *)player didReceivedDataLength:(NSInteger)dataLength{
    
}

- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error{
    
    NSLog(@"player: %@, didReceivederror: %@", player, [error localizedDescription]);
    __weak typeof(self) weakSelf = self;
    /**失败后打开webkit
    [EZOPENSDK openLoginPage:^(EZAccessToken *accessToken) {
        [[FarmDatabase shareInstance] setAccessToken:accessToken.accessToken];
        [EZOPENSDK setAccessToken:accessToken.accessToken];
        
        if (accessToken.accessToken) {
            
            [EZOpenSDK getDeviceList:0 pageSize:5 completion:^(NSArray *hikDeviceList, NSInteger totalCount, NSError *error) {
                [weakSelf.hikDeviceList removeAllObjects];
                [weakSelf.hikDeviceList addObjectsFromArray:hikDeviceList];
            }];
            
            if (weakSelf.hikDeviceList != NULL) {
                _hikDeviceInfo = [weakSelf.hikDeviceList objectAtIndex:1];
                _cameraInfo = [self.hikDeviceInfo.cameraInfo objectAtIndex:0];
            }
            
            [[FarmDatabase shareInstance] setAccessToken:accessToken.accessToken cameraInfo:_cameraInfo];
            
            _player = [EZOPENSDK createPlayerWithDeviceSerial:self.cameraInfo.deviceSerial cameraNo:self.cameraInfo.cameraNo];
            _player.delegate = self;
            
            [_player setPlayVerifyCode:@"LWAFXI"];
            NSLog(@"设备信息3：%@",self.cameraInfo);
            [_player setPlayerView:_playView];
            [_player startRealPlay];
            
        }
    }];
     **/
    
}

- (void)player:(EZPlayer *)player didReceivedMessage:(NSInteger)messageCode{
    
    NSLog(@"player: %@, didReceivedMessage: %d", player, (int)messageCode);
    if (messageCode == PLAYER_REALPLAY_START) {
        [_playView bringSubviewToFront:_collapseBtn];
        _playBtn.enabled = YES;
        //[_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateHighlighted];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        _isPlaying = YES;
    }
    
}



#pragma mark - 视频列表选择弹出页面
- (void)cameraSelectList:(UIButton *)sender{
    if (!sender.isSelected) {
        [UIView animateWithDuration:1.0 animations:^{
            _cameraListView.frame = CGRectMake(ScreenWidth - 200, 0, 200, 120);
            //_cameraListTable.frame = CGRectMake(0, 0, 200, 120);
            _cameraListTable.hidden = NO;
        }];
        [sender setSelected:YES];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            _cameraListView.frame = CGRectMake(ScreenWidth, 0, 0, 0);
            //_cameraListTable.frame = CGRectMake(0, 0, 0, 0);
            _cameraListTable.hidden = YES;
        }]; 
        [sender setSelected:NO];
    }
    
}

- (void)collapseBtnPlayView{
    [UIView animateWithDuration:0.5 animations:^{
        _myScrollView.contentOffset = CGPointMake(0, 200 - 64);
    }];
    [self stopNPlayer];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cameraList.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_cameraList];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_cameraList];
    }
    NSDictionary *camera = _cameraList[indexPath.row];
    cell.textLabel.text = camera[@"deviceName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *camera = _cameraList[indexPath.row];
    _deviceSerial = J2String(camera[@"deviceSerial"]);
    NSString *cameraURL = [NSString stringWithFormat:@"ezopen://open.ys7.com/%@/%@.live",_deviceSerial,J2String(camera[@"channelNo"])];
    [[FarmDatabase shareInstance] setDeviceSerial:J2String(camera[@"deviceSerial"])];
    [[FarmDatabase shareInstance] setCameraNo:[camera[@"channelNo"] integerValue]];
    [self getAccessTokenByApi:J2String(camera[@"deviceSerial"]) cameraURL:cameraURL];
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
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    textLabel.text = LocalString(@"摄像头列表");
    [sectionView addSubview:textLabel];
    textLabel.center = sectionView.center;
    textLabel.textAlignment = NSTextAlignmentCenter;
    sectionView.backgroundColor = [UIColor darkGrayColor];
    sectionView.alpha = 0.8;
    return sectionView;
    
}

@end
