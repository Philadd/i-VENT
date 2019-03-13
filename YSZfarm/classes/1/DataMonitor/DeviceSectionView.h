//
//  DeviceSectionView.h
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceSectionModel;
typedef void(^CallBackBlock)(BOOL);
@interface DeviceSectionView : UITableViewHeaderFooterView
@property (nonatomic,strong) DeviceSectionModel *model;
@property (nonatomic,strong) CallBackBlock block;
@end
