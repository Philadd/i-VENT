//
//  controledMonitorModel.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/21.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface controledMonitorModel : NSObject

@property (nonatomic,strong) NSString *streamId;

///@brife 用于判断监控点操作后值是否已经改变，未改变则重新查询三次
@property (nonatomic,strong) NSNumber *modifyValue;
@property (nonatomic) int judgeNum;
@property (nonatomic) int resendTime;
@property (nonatomic) int timeInterval;//重发间隔时间计数
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSString *url;

@end
