//
//  AlertCell.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/2/26.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCell : UITableViewCell
@property (strong,nonatomic) UILabel *deviceName;
@property (strong,nonatomic) UILabel *status;
@property (strong,nonatomic) UILabel *data;
@property (strong,nonatomic) UILabel *time_ymd;//year-month-day
@property (strong,nonatomic) UILabel *time_hms;//hour-minute-second
@end
