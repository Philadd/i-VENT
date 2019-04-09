//
//  SettingItem.h
//  YSZfarm
//
//  Created by Mac on 2017/8/7.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingItem : NSObject

///@brife cell标题
@property (strong,nonatomic) NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title;/**设置cell标题**/

@end
