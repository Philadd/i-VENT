//
//  SliderTabBarView.h
//  YSZfarm
//
//  Created by Mac on 2017/8/3.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderTabBarView : UIView

///@brife scrollView的总页数
@property (assign) NSInteger tabCount;

///@brife 下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;

///@brife 设备的传感器列表
@property (strong, nonatomic) NSArray *sensorList;

-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;

@end
