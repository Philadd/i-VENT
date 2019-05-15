//
//  YSZTabBarController.m
//  YSZfarm
//
//  Created by Mac on 2017/7/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewController.h"
#import "MapViewController.h"
#import "UIViewController+MMDrawerController.h"
#import <RMQClient/RMQClient.h>
#import <UserNotifications/UserNotifications.h>

@interface MainViewController () <UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSArray *titleData;
@end

@implementation MainViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self subscribe];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

#pragma mark - 标题数组
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"地图", @"网关"];
    }
    return _titleData;
}

#pragma mark - 初始化代码
- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 18;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
        self.menuBGColor = [UIColor whiteColor];
        self.menuHeight = 44;
        //self.progressHeight = 1;//下划线的高度，需要WMMenuViewStyleLine样式
        //self.progressColor = [UIColor blueColor];//设置下划线(或者边框)颜色
        //self.titleColorSelected = [UIColor blueColor];//设置选中文字颜色
        
        self.scrollEnable = NO;
        
        UIButton *userBtn = [UIButton userButton:LocalString(@"") batteryImage:[UIImage imageNamed:@"user_man"]];
        userBtn.frame = CGRectMake(0, 0, 100, 30);
        [userBtn addTarget:self action:@selector(leftDrawer) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:userBtn];
        UIButton *scanButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
        [scanButton setImage:[UIImage imageNamed:@"二维码"] forState:UIControlStateNormal];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:scanButton];
        //self.navigationItem.rightBarButtonItem= rightItem;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    return self;
}

#pragma mark - 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark - 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:{
            
            MapViewController *mapVC = [[MapViewController alloc] init];
            return mapVC;
        }
            
            break;
        case 1:{
            MainTableViewController *firstVC = [[MainTableViewController alloc] init];
            return firstVC;
            
            
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
    
    
}

#pragma mark - 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

#pragma mark - 左侧抽屉
- (void)leftDrawer{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - RMQClient
- (void)subscribe{
    RMQConnection *conn = [[RMQConnection alloc] initWithUri:@"amqp://thingcom:106ling106@121.40.142.221:5672" delegate:[RMQConnectionDelegateLogger new]];
    [conn start];
    
    id<RMQChannel> ch = [conn createChannel];
    RMQExchange *exchange = [ch fanout:[FarmDatabase shareInstance].userId options:RMQExchangeDeclareDurable];
    RMQQueue *q = [ch queue:@"" options:RMQQueueDeclareExclusive | RMQQueueDeclareDurable];
    
    [q bind:exchange];
    
    [q subscribe:^(RMQMessage * _Nonnull message) {
        
        //NSLog(@"Received %@",[[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding]);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:message.body options:NSJSONReadingMutableContainers error:&err];
        
        if (dic[@"title"] != NULL) {
            [FarmDatabase shareInstance].alarmGateway = dic[@"title"];
        }
        //通知网关列表显示该网关报警
        [[NSNotificationCenter defaultCenter] postNotificationName:@"datapointAlarm" object:nil userInfo:nil];
        
        
        NSLog(@"Received %@",[NSJSONSerialization JSONObjectWithData:message.body options:NSJSONReadingMutableContainers error:&err]);
        if (err) {
            NSLog(@"json解析失败%@",err);
        }
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:dic[@"title"] arguments:nil];
        content.subtitle = dic[@"streamName"];
        content.body = dic[@"content"];
        content.sound = [UNNotificationSound defaultSound];
        
        //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:alertTime repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"O1Notification" content:content trigger:nil];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
        
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", body);
        
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置

}

@end

