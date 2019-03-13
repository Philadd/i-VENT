//
//  DeviceSectionModel.h
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceSectionModel : NSObject
@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *deviceGroupName;
@property (nonatomic,strong) NSString *datapointGroupUid;
@property (nonatomic,strong) NSNumber *datapointGroupId;
@property (nonatomic,strong) NSArray *cellArray;
@end
