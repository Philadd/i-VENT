//
//  DatapointBit16_32Cell.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/1/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CallBackBlock_16)(NSString *);
typedef void(^nstimerBlock)(void);

@interface DatapointBit16_32Cell : UITableViewCell
@property (strong,nonatomic) UILabel *dataMonitorName;
@property (strong,nonatomic) UITextField *dataMonitorDataTF;
@property (nonatomic,strong) CallBackBlock_16 block;
@property (nonatomic,strong) nstimerBlock block_timerpause;
@property (nonatomic,strong) nstimerBlock block_timerstart;
@end
