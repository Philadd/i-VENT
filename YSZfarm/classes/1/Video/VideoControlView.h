//
//  VideoControlView.h
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

typedef void(^fatherViewBackBlock)(void);

#import <UIKit/UIKit.h>

@interface VideoControlView : UIViewController

@property (nonatomic, strong) fatherViewBackBlock block;

@end
