//
//  DetailTableCell.h
//  YSZfarm
//
//  Created by Mac on 2017/7/27.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;

@end
