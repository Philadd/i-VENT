//
//  CellModel.h
//  YSZfarm
//
//  Created by Mac on 2017/12/20.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject
@property (nonatomic,strong) NSString *sn;
@property (nonatomic,strong) NSString *deviceId;
@property (nonatomic,strong) NSString *apiKey;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSDictionary *location;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSNumber *auth;
@property (nonatomic) NSNumber *online;
@end
