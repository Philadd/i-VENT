//
//  FarmDetailViewController.h
//  YSZfarm
//
//  Created by Mac on 2017/7/26.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FarmDetailViewController : UITableViewController

///@brife TLink设备的传感器Array
@property (nonatomic) NSArray *sensorList;

///@brife 当前选中设备表格的indexPath
@property (nonatomic) NSIndexPath *indexPath;

///@brife TLink设备ID
@property (nonatomic) NSString *deviceNo;

- (void)setNavigationTitle:(NSString *)title;


@end
