//
//  SectionView.h
//  YSZfarm
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionModel;
typedef void(^CallBackBlock)(BOOL);
@interface SectionView : UITableViewHeaderFooterView
@property (nonatomic,strong) SectionModel *model;
@property (nonatomic,strong) CallBackBlock block;
@property (nonatomic,strong) UILabel *alarmLabel;
@end
