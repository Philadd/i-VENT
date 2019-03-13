//
//  TableCell.h
//  YSZfarm
//
//  Created by Mac on 2017/7/28.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *farmImageView;
@property (weak, nonatomic) IBOutlet UILabel *farmNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;

@end
