//
//  DatapointBitCell.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/1/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CallBackBlock)(BOOL);
@interface DatapointBitCell : UITableViewCell
@property (strong,nonatomic) UILabel *dataMonitorName;
@property (strong,nonatomic) UISwitch *dataMonitorSwitch;
@property (nonatomic,strong) CallBackBlock block;
@end
