//
//  GroupItem.h
//  YSZfarm
//
//  Created by Mac on 2017/8/7.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupItem : NSObject

///@brife 设置表格的头标题
@property (strong,nonatomic) NSString *headerTitle;

///@brife 设置表格的尾标题
@property (strong,nonatomic) NSString *footerTitle;

///@brife section数组
@property (strong,nonatomic) NSArray *items;

@end
