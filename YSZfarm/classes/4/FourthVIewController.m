//
//  FourthVIewController.m
//  YSZfarm
//
//  Created by Mac on 2017/7/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "FourthVIewController.h"
#import "SettingItem.h"
#import "GroupItem.h"
#import "FarmDatabase.h"
#import "EZOpenSDK.h"

NSString *const FourCellIdentifier = @"cellIDsixth";

@interface FourthVIewController()

///@brife 组数，即section个数
@property (strong,nonatomic) NSMutableArray *groups;

@end

@implementation FourthVIewController

- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setGroup1];
    [self setGroup2];
    self.navigationItem.title = @"设置中心";
}

- (void)setGroup1{
    GroupItem *group = [[GroupItem alloc] init];
    
    SettingItem *item = [SettingItem itemWithTitle:@"我的账户"];
    SettingItem *item1 = [SettingItem itemWithTitle:@"添加设备"];
    
    group.items = @[item,item1];
    [self.groups addObject:group];
}

- (void)setGroup2{
    GroupItem *group = [[GroupItem alloc] init];
    
    SettingItem *item = [SettingItem itemWithTitle:@"清除缓存"];
    group.items = @[item];
    [self.groups addObject:group];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GroupItem *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FourCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FourCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    GroupItem *group = self.groups[indexPath.section];
    SettingItem *item = group.items[indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [[FarmDatabase shareInstance] clearSession];
        NSLog(@"清理成功");
        /*[EZOpenSDK logout:^(NSError *error) {
            if (error == nil) {
                NSLog(@"退出成功");
            }
        }];*/
    }
}

@end
