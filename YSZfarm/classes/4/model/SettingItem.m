//
//  SettingItem.m
//  YSZfarm
//
//  Created by Mac on 2017/8/7.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

+ (instancetype)itemWithTitle:(NSString *)title{
    SettingItem *item = [[SettingItem alloc] init];
    item.title = title;
    return item;
}

@end
