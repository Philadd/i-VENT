//
//  SwitcherTableViewCell.h
//  YSZfarm
//
//  Created by Mac on 2017/8/2.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitcherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end
