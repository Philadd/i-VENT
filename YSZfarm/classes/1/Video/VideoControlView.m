//
//  VideoControlView.m
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "VideoControlView.h"
#import "EZConstants.h"
#import "EZOpenSDK.h"
#import "FarmDatabase.h"

@interface VideoControlView ()

///@brife 视频控制页面四个主按钮
@property (nonatomic, strong) UIButton *controlBtn;
@property (nonatomic, strong) UIButton *talkBtn;
@property (nonatomic, strong) UIButton *screenshotBtn;
@property (nonatomic, strong) UIButton *recordBtn;

///@brife 摄像上下左右移动操作按钮
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIButton *controlBgBtn;
@property (nonatomic, strong) UIButton *ptzLeftBtn;
@property (nonatomic, strong) UIButton *ptzRightBtn;
@property (nonatomic, strong) UIButton *ptzUpBtn;
@property (nonatomic, strong) UIButton *ptzDownBtn;
@property (nonatomic, strong) UIButton *controlCloseBtn;
@end

@implementation VideoControlView

static int controlBtnInset = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fourMainBtnLayout];
    [self cameraControlViewLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.block) {
        self.block();
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.block) {
        self.block();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fourMainBtnLayout{
    _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_controlBtn setTitle:LocalString(@"云台") forState:UIControlStateNormal];
    [_controlBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    [_controlBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_controlBtn setImage:[UIImage imageNamed:@"preview_barrel"] forState:UIControlStateNormal];
    [_controlBtn addTarget:self action:@selector(showControlView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_controlBtn];
    [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(self.view.mas_top).offset(controlBtnInset);
        make.right.equalTo(self.view.mas_centerX).offset(-controlBtnInset);
        
    }];
    
    _talkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_talkBtn setTitle:LocalString(@"对讲") forState:UIControlStateNormal];
    [_talkBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    [_talkBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_talkBtn setImage:[UIImage imageNamed:@"preview_talkback"] forState:UIControlStateNormal];
    [self.view addSubview:_talkBtn];
    [_talkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(self.view.mas_top).offset(controlBtnInset);
        make.left.equalTo(self.view.mas_centerX).offset(controlBtnInset);
    }];
    
    _screenshotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_screenshotBtn setTitle:LocalString(@"截图") forState:UIControlStateNormal];
    [_screenshotBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    [_screenshotBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_screenshotBtn setImage:[UIImage imageNamed:@"preview_screenshot"] forState:UIControlStateNormal];
    [self.view addSubview:_screenshotBtn];
    [_screenshotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(self.controlBtn.mas_bottom).offset(controlBtnInset * 1.5);
        make.right.equalTo(self.view.mas_centerX).offset(-controlBtnInset);
    }];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setTitle:LocalString(@"录像") forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
    [_recordBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_recordBtn setImage:[UIImage imageNamed:@"preview_recording"] forState:UIControlStateNormal];
    [self.view addSubview:_recordBtn];
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(self.controlBtn.mas_bottom).offset(controlBtnInset * 1.5);
        make.left.equalTo(self.view.mas_centerX).offset(controlBtnInset);
    }];
}

- (void)cameraControlViewLayout{
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44 - 200 - 20- 44)];
    _controlView.backgroundColor = [UIColor whiteColor];
    //_controlView.alpha = 0.0;
    [self.view addSubview:_controlView];
    
    _controlBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _controlBgBtn.frame = CGRectMake(0, 0, 154, 154);
    [_controlBgBtn setImage:[UIImage imageNamed:@"ptz_bg"] forState:UIControlStateNormal];
    _controlBgBtn.enabled = NO;
    [_controlView addSubview:_controlBgBtn];
    _controlBgBtn.center = _controlView.center;
    
    
    _controlCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_controlCloseBtn setImage:[UIImage imageNamed:@"play_close"] forState:UIControlStateNormal];
    [_controlCloseBtn addTarget:self action:@selector(closeControlView) forControlEvents:UIControlEventTouchUpInside];
    [_controlView addSubview:_controlCloseBtn];
    [_controlCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(self.controlView.mas_bottom);
        make.right.equalTo(self.controlView.mas_right);
    }];
    _controlCloseBtn.hidden = YES;
    
    _ptzLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ptzLeftBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_ptzLeftBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_controlView addSubview:_ptzLeftBtn];
    [_ptzLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.controlBgBtn.mas_left);
        make.centerY.equalTo(self.controlBgBtn.mas_centerY);
    }];
    
    _ptzUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ptzUpBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_ptzUpBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_controlView addSubview:_ptzUpBtn];
    [_ptzUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(self.controlBgBtn.mas_top);
        make.centerX.equalTo(self.controlBgBtn.mas_centerX);
    }];
    
    _ptzRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ptzRightBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_ptzRightBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_controlView addSubview:_ptzRightBtn];
    [_ptzRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.equalTo(self.controlBgBtn.mas_right);
        make.centerY.equalTo(self.controlBgBtn.mas_centerY);
    }];
    
    _ptzDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ptzDownBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_ptzDownBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_controlView addSubview:_ptzDownBtn];
    [_ptzDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.bottom.equalTo(self.controlBgBtn.mas_bottom);
        make.centerX.equalTo(self.controlBgBtn.mas_centerX);
    }];
    
}

#pragma mark - 视频设备控制页面
- (void)showControlView{
    [UIView animateWithDuration:0.5 animations:^{
        _controlView.alpha = 1.0;
    }];
}

- (void)closeControlView{
    [UIView animateWithDuration:0.5 animations:^{
        _controlView.alpha = 0.0;
    }];
}

- (void)ptzControlButtonTouchDown:(id)sender{
    EZPTZCommand command;
    NSString *imageName = nil;
    if (sender == self.ptzUpBtn) {
        command = EZPTZCommandUp;
        imageName = @"ptz_up_sel";
    }else if (sender == self.ptzDownBtn){
        command = EZPTZCommandDown;
        imageName = @"ptz_bottom_sel";
    }else if (sender == self.ptzLeftBtn){
        command = EZPTZCommandLeft;
        imageName = @"ptz_left_sel";
    }else{
        command = EZPTZCommandRight;
        imageName = @"ptz_right_sel";
    }
    [self.controlBgBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
    NSLog(@"%@",[FarmDatabase shareInstance].deviceSerial);
    NSLog(@"%ld",(long)[FarmDatabase shareInstance].cameraNo);
    [EZOpenSDK controlPTZ:[FarmDatabase shareInstance].deviceSerial
                 cameraNo:[FarmDatabase shareInstance].cameraNo
                  command:command
                   action:EZPTZActionStart
                    speed:2
                   result:^(NSError *error) {
                       NSLog(@"error is %@", error);
                       if (error.code == EZ_HTTPS_DEVICE_PTZ_NOT_SUPPORT) {
                           [NSObject showHudTipStr:@"该摄像头没有云台控制的功能"];
                       }
                   }];
}

- (void)ptzControlButtonTouchUpInside:(id)sender{
    
    EZPTZCommand command;
    if(sender == self.ptzLeftBtn)
    {
        command = EZPTZCommandLeft;
    }
    else if (sender == self.ptzDownBtn)
    {
        command = EZPTZCommandDown;
    }
    else if (sender == self.ptzRightBtn)
    {
        command = EZPTZCommandRight;
    }
    else {
        command = EZPTZCommandUp;
    }
    [self.controlBgBtn setImage:[UIImage imageNamed:@"ptz_bg"] forState:UIControlStateDisabled];
    [EZOpenSDK controlPTZ:[FarmDatabase shareInstance].deviceSerial
                 cameraNo:[FarmDatabase shareInstance].cameraNo
                  command:command
                   action:EZPTZActionStop
                    speed:3.0
                   result:^(NSError *error) {
                       NSLog(@"error is %@", error);
                   }];
}


@end
