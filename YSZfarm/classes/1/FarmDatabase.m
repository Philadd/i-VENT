//
//  FarmDatabase.m
//  YSZfarm
//
//  Created by Mac on 2017/7/26.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "FarmDatabase.h"
#import "EZCameraInfo.h"
#import "LCMD5Tool.h"

@interface FarmDatabase()



@property (strong,nonatomic) NSDictionary *parameters;

///@brife TLink获取的设备Array
@property (nonatomic) NSMutableArray *privateDataList;

@end

@implementation FarmDatabase

static FarmDatabase* _instance = nil;

#pragma mark - 实现单例
+ (instancetype)shareInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[super allocWithZone:NULL] initPrivate];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [FarmDatabase shareInstance];
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"用单例" userInfo:nil];
}

- (instancetype)initPrivate{
    self = [super init];
    if (self) {
        
    }
    return self;
}



#pragma mark -后台获取数据
- (void)setuserid:(NSString *)userid
{
    self.userId = userid;
    //NSLog(@"%d",userid);
}

- (void)getDeviceData:(void(^)())block{
    __weak typeof(self) weakSelf = self;
    
    if (_userId != nil) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager.requestSerializer setValue:_userId forHTTPHeaderField:@"userId"];
        NSLog(@"%@",self.userId);
        [manager GET:@"http://rijin.thingcom.com:80/api/v1/relation/user/netgates" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            if (block) {
                block(responseDic);
            }
            NSLog(@"fans%@",responseDic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    }
}



#pragma mark -视频accessToken以及cameraInfo本地化处理

- (void)setAccessToken:(NSString *)accessToken cameraInfo:(EZCameraInfo *)cameraInfo{
    _accessToken = accessToken;
    _deviceSerial = cameraInfo.deviceSerial;
    _cameraNo = cameraInfo.cameraNo;
    _cameraName = cameraInfo.cameraName;
    NSLog(@"设备信息Data：%@",accessToken);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:accessToken?:@"" forKey:@"EZOpenSDKAccessToken"];
    [user setObject:_deviceSerial?:@"" forKey:@"EZOpenSDKDeviceSerial"];
    [user setObject:_cameraName?:@"" forKey:@"EZOpenSDKCameraName"];
    [user setInteger:_cameraNo forKey:@"EZOpenSDKCameraNo"];
    [user synchronize];
}

- (NSString *)getAccessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"EZOpenSDKAccessToken"];
}

- (NSString *)getDeviceSerial{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"EZOpenSDKDeviceSerial"];
}

- (NSString *)getCameraName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"EZOpenSDKCameraName"];
}

- (NSInteger)getCameraNo{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"EZOpenSDKCameraNo"];
}

- (void)clearSession{
    _accessToken = nil;
    _deviceSerial = nil;
    _cameraName = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"EZOpenSDKAccessToken"];
    [user removeObjectForKey:@"EZOpenSDKDeviceSerial"];
    [user removeObjectForKey:@"EZOpenSDKCameraName"];
    [user removeObjectForKey:@"EZOpenSDKCameraNo"];
    [user synchronize];
}

@end
