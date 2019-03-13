//
//  LeftDrawerViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/2.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "UIViewController+MMDrawerController.h"
#import "PasswordViewController.h"


NSString *const kCellIdentifier_leftDrawer = @"leftDrawerCell";

@interface LeftDrawerViewController ()
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation LeftDrawerViewController
{
    NSString *userName;
    NSString *company;
    NSString *email;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalString(@"用户信息");
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    UIColor *barColor = [UIColor colorWithRed:161.0/255.0
                                        green:164.0/255.0
                                         blue:166.0/255.0
                                        alpha:1.0];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    [self getUserInformation];
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        UIColor *tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                                            green:113.0/255.0
                                                             blue:115.0/255.0
                                                            alpha:1.0];
        [tableView setBackgroundColor:tableViewBackgroundColor];
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier_leftDrawer];
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView;
    });
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn.layer setBorderWidth:1.0];
    [logoutBtn.layer setCornerRadius:15.0];
    [logoutBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [logoutBtn setTitle:LocalString(@"退出登录") forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor redColor];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _myTableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInformation{
    [SVProgressHUD show];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    FarmDatabase *db = [FarmDatabase shareInstance];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 6.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/user"];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:db.userId forHTTPHeaderField:@"userId"];
    
    [manager GET: url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        //获取用户信息
        NSDictionary *infoDic = responseDic[@"data"];
        userName = infoDic[@"name"];
        company = infoDic[@"company"];
        [[FarmDatabase shareInstance] setMobile:infoDic[@"mobile"]];
        
        [_myTableView reloadData];
                                                                                                                                
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

#pragma mark - Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case UserName:
            return 1;
            break;
            
        case Information:
            if (company != nil && email != nil) {
                return 2;
            }else{
                return 1;
            }
            break;
            
        case Setting:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_leftDrawer];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case UserName:
            if (indexPath.row == 0) {
                cell.textLabel.text = userName;
            }
            break;
            
        case Information:
            if (indexPath.row == 0) {
                if (company != nil) {
                    cell.textLabel.text = company;
                }else{
                    cell.textLabel.text = LocalString(@"信息");
                }
            }else if (indexPath.row == 1){
                if (email != nil) {
                    cell.textLabel.text = email;
                }
            }
            break;
            
        case Setting:
            if (indexPath.row == 0) {
                cell.textLabel.text = LocalString(@"修改密码");
            }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case Setting:
            if (indexPath.row == 0) {
                PasswordViewController *pwVc = [[UIStoryboard storyboardWithName:@"Password" bundle:nil] instantiateViewControllerWithIdentifier:@"PasswordViewController"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pwVc];
                [self presentViewController:nav animated:YES completion:nil];
            }
            break;
            
        default:
            break;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case UserName:
            return LocalString(@"UserName");
        case Information:
            return LocalString(@"Information");
        case Setting:
            return LocalString(@"Setting");
        default:
            return nil;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMSideDrawerSectionHeaderView * headerView;
    headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

#pragma mark - action
- (void)logout{
    [self.mm_drawerController dismissViewControllerAnimated:YES completion:nil];
}

@end
