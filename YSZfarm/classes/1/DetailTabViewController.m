//
//  DetailTabViewController.m
//  YSZfarm
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "DetailTabViewController.h"
#import "DataMonitorView.h"
#import "AlertViewController.h"
#import "DeviceInfoViewController.h"
#import "VideoControlView.h"

@interface DetailTabViewController ()
@property (nonatomic, strong) NSArray *titleData;
@end

@implementation DetailTabViewController
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight);
}

- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"数据监控",@"报警监控",@"基本信息",@"视频控制"];
    }
    return _titleData;
}

#pragma mark 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
        self.menuBGColor = [UIColor whiteColor];
        self.menuHeight = 44;
        //self.progressHeight = 1;//下划线的高度，需要WMMenuViewStyleLine样式
        //self.progressColor = [UIColor blueColor];//设置下划线(或者边框)颜色
        //self.titleColorSelected = [UIColor blueColor];//设置选中文字颜色
    }
    return self;
}

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:{
            DataMonitorView *VC0 = [[DataMonitorView alloc] init];
            return VC0;
        }
            
            break;
        case 1:{
            AlertViewController *VC1 = [[AlertViewController alloc] init];
            return VC1;
            
        }
            break;
            
        case 2:{
            DeviceInfoViewController *VC2 = [[DeviceInfoViewController alloc] init];
            return VC2;
            
        }
            break;
            
        case 3:{
            VideoControlView *VC3 = [[VideoControlView alloc] init];
            if (self.block) {
                VC3.block = ^{
                    self.block();
                };
            }
            return VC3;
            
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
    
    
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

@end
