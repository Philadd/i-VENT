//
//  FarmDatabase.m
//  YSZfarm
//
//  Created by Mac on 2017/7/26.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "FarmDatabase.h"
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
}

- (void)getDeviceData:(void(^)())block{
    
    if (_userId != nil) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager.requestSerializer setValue:_userId forHTTPHeaderField:@"userId"];
        [manager GET:@"http://rijin.thingcom.com:80/api/v1/relation/user/netgates" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            if (block) {
                block(responseDic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error:%@",error);
        }];
        
    }
}

@end
