//
//  AppDelegate.h
//  YSZfarm
//
//  Created by Mac on 2017/7/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@end

