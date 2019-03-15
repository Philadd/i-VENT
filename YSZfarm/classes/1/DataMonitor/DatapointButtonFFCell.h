//
//  DatapointButtonFFCell.h
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/14.
//  Copyright © 2019 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CallBackBlock)(BOOL);

@interface DatapointButtonFFCell : UITableViewCell

@property (strong,nonatomic) UILabel *dataMonitorName;
@property (strong,nonatomic) UIButton *dataMonitorBtn;
@property (nonatomic,strong) CallBackBlock block;

@end

NS_ASSUME_NONNULL_END
