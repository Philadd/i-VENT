//
//  DetailTabViewController.h
//  YSZfarm
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 yusz. All rights reserved.
//

typedef void(^fatherViewBackBlock)(void);

#import "WMPageController.h"

@interface DetailTabViewController : WMPageController

@property (nonatomic, strong) fatherViewBackBlock block;

@end
