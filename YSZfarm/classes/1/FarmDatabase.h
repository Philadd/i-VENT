//
//  FarmDatabase.h
//  YSZfarm
//
//  Created by Mac on 2017/7/26.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EZCameraInfo;

@interface FarmDatabase : NSObject

///@brife 报警网关名称
@property (strong,nonatomic) NSString *alarmGateway;

///@brife 用户信息
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *mobile;

///@brife 注册时手机号码
@property (strong,nonatomic) NSString *accountMobile;
///@brife 手机验证码
@property (strong, nonatomic) NSString *phoneCode;

///@brife 设备信息页面数据调用
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *groupName;

///@brife 获取设备列表
@property (nonatomic,readonly) NSArray *allDevices;

///@brife 海康监控登录获得的accessToken
@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *deviceSerial;
@property (nonatomic) NSInteger cameraNo;
@property (nonatomic) NSString *cameraName;

///@brife 监控点页面获取设备信息以及监控点信息 （ps：因为设备页面与监控点页面不是父子页面，无法直接通信）
@property (nonatomic,strong) NSDictionary *deviceDic;
@property (nonatomic,strong) NSDictionary *deviceDicOnenet;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *apiKey;
@property (nonatomic,strong) NSString *sn;
@property (nonatomic,strong) NSNumber *auth;
@property (nonatomic,strong) NSNumber *online;
@property (nonatomic,strong) NSString *connectType;

+ (instancetype)shareInstance;
- (void)setuserid:(NSString *)userid;
- (void)getDeviceData:(void(^)())block;
- (void)clearSession;
- (NSString *)getAccessToken;
- (NSString *)getDeviceSerial;
- (NSInteger)getCameraNo;
- (NSString *)getCameraName;
- (void)setAccessToken:(NSString *)accessToken cameraInfo:(EZCameraInfo *)cameraInfo;

@end
