//
//  SectionModel.h
//  YSZfarm
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *deviceGroupId;
@property (nonatomic,strong) NSArray *cellArray;
@end
