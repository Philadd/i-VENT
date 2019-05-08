//
//  LoginViewController.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AFHTTPSessionManager.h"
#import "FarmDatabase.h"
#import "MMDrawerController.h"
#import "LeftDrawerViewController.h"
#import "inputTextField.h"
#import "RegisterViewController.h"

#define login_backColor @"B45B3E"
#define TFwidth (250.0 / 375) * ScreenWidth

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    self.view.alpha = 0.9;
    [self viewLayout];
    [self autoLogin];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewLayout{
    _userNameTF = [[inputTextField alloc] init];
    _userNameTF.borderStyle = UITextBorderStyleNone;
    _userNameTF.backgroundColor = [UIColor clearColor];
    _userNameTF.placeholder = LocalString(@"Phone");
    _userNameTF.font = [UIFont fontWithName:@"Arial" size:17.0];
    _userNameTF.textColor = [UIColor whiteColor];
    _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTF.returnKeyType = UIReturnKeyDone;
    _userNameTF.keyboardType = UIKeyboardTypePhonePad;
    _userNameTF.keyboardType = UIKeyboardTypeTwitter;
    _userNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userNameTF.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.userNameTF];
    
    _passwordTF = [[inputTextField alloc] init];
    _passwordTF.borderStyle = UITextBorderStyleNone;
    _passwordTF.backgroundColor = [UIColor clearColor];
    _passwordTF.font = [UIFont fontWithName:@"Arial" size:17.0];
    _passwordTF.textColor = [UIColor whiteColor];
    _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    _passwordTF.keyboardType = UIKeyboardTypeTwitter;
    _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.passwordTF];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //_loginBtn.backgroundColor = [UIColor colorWithHexString:@"A2CB3A"];
    _loginBtn.backgroundColor = [UIColor colorWithHexString:@"51a938"];
    [_loginBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:17.0]];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:LocalString(@"登录") forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn.layer setCornerRadius:15];
    [self.view addSubview:_loginBtn];
    
    _accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _accountBtn.backgroundColor = [UIColor colorWithHexString:@"42C1DE"];
    [_accountBtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:17.0]];
    [_accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_accountBtn setTitle:LocalString(@"注册") forState:UIControlStateNormal];
    [_accountBtn.layer setCornerRadius:15];
    [_accountBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_accountBtn];
    
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    [self.view addSubview:userImage];
    [self.view addSubview:passwordImage];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    
    UILabel *appTitle = [[UILabel alloc] init];
    appTitle.text = LocalString(@"Industrial Gateway");
    appTitle.textColor = [UIColor whiteColor];
    appTitle.font = [UIFont fontWithName:@"Arial" size:30.0];
    appTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appTitle];
    
    [appTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50));
        make.top.equalTo(self.view.mas_top).offset(ScreenHeight * 120.0 / 667);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth, 30));
        make.bottom.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX).offset(15);
    }];
    
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.userNameTF.mas_top);
        make.right.equalTo(self.userNameTF.mas_left);
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth, 30));
        make.top.equalTo(self.userNameTF.mas_bottom).offset(30);
        make.centerX.equalTo(self.view.mas_centerX).offset(15);
    }];
    
    [passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.passwordTF.mas_top);
        make.right.equalTo(self.passwordTF.mas_left);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth + 30, 40));
        make.top.equalTo(self.passwordTF.mas_bottom).offset(50);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth + 30, 40));
        make.top.equalTo(self.loginBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth + 30, 1));
        make.top.equalTo(self.userNameTF.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TFwidth + 30, 1));
        make.top.equalTo(self.passwordTF.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - 用户登录
//加载用户信息
- (void)loadUserInfo{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _userNameTF.text = [userDefaults objectForKey:@"userName"];
    _passwordTF.text = [userDefaults objectForKey:@"passWord"];
}

- (void)login{
    
    if (![NSString validateMobile:self.userNameTF.text] || self.passwordTF.text.length < 6){
        [NSObject showHudTipStr:LocalString(@"请输入正确的账号密码")];
        return;
    }
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    FarmDatabase *db = [FarmDatabase shareInstance];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = yHttpTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    if ([NSString validateMobile:_userNameTF.text]){
        parameters = @{@"mobile":self.userNameTF.text,@"password":self.passwordTF.text};
        NSLog(@"%@",parameters);
    }else {
        [NSObject showHudTipStr:LocalString(@"用户名或者密码长度不正确")];
        return;
    }
    
    [manager POST:@"http://rijin.thingcom.com:80/api/v1/user/login" parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
              NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
              
              NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
              if ([[responseDic objectForKey:@"errno"] intValue] == 0){
                  if ([responseDic objectForKey:@"data"]) {
                      NSLog(@"success:%@",daetr);
                      
                      NSDictionary *userinfoDic = [responseDic objectForKey:@"data"];
                      db.userId = [userinfoDic objectForKey:@"userId"];
                      
                  }
                  
                  [self saveUserInfo];
                  LeftDrawerViewController *leftSideDrawerViewController = [[LeftDrawerViewController alloc] init];
                  leftSideDrawerViewController.userId = [FarmDatabase shareInstance].userId;
                  
                  MainViewController *mainVC = [[MainViewController alloc] init];
                  
                  UINavigationController *leftNAV = [[UINavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
                  UINavigationController *centerNAV = [[UINavigationController alloc] initWithRootViewController:mainVC];
                  
                  [leftNAV setRestorationIdentifier:@"leftNavigationControllerRestorationKey"];
                  [centerNAV setRestorationIdentifier:@"centerNavigationControllerRestorationKey"];
                  
                  MMDrawerController *drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNAV leftDrawerViewController:leftNAV];
                  [drawerController setShowsShadow:YES];
                  [drawerController setRestorationIdentifier:@"MMDrawer"];
                  [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                  [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                  [drawerController setMaximumLeftDrawerWidth:250.0];
                  
                  [self presentViewController:drawerController animated:NO completion:nil];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                  });
                  /*直接跳到MainViewController
                   MainViewController *mainVC = [[MainViewController alloc] init];
                   UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:mainVC];
                   [self presentViewController:NAV animated:NO completion:nil];
                   */
              }else{
                  [NSObject showHudTipStr:LocalString(@"用户名或密码错误")];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                  });
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error:%@",error);
              if (error.code == -1001) {
                  [NSObject showHudTipStr:LocalString(@"当前网络状况不佳") withTime:2.5];
              }
              dispatch_async(dispatch_get_main_queue(), ^{
                  [SVProgressHUD dismiss];
              });
          }];
    
}

#pragma mark - 注册
- (void)registerAccount{
    RegisterViewController *registVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - 缓存用户信息
- (void)saveUserInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userNameTF.text forKey:@"userName"];
    [userDefaults setObject:self.passwordTF.text forKey:@"passWord"];
    [userDefaults synchronize];
    NSLog(@"用户信息已保存");
}

#pragma mark - 自动登录功能
- (void)autoLogin{
    [SVProgressHUD show];
    
    [self loadUserInfo];
    
    if (![NSString validateMobile:self.userNameTF.text] || self.passwordTF.text.length < 6){
        [NSObject showHudTipStr:LocalString(@"自动登录失败")];
        [SVProgressHUD dismiss];
        return;
    }
    [self login];
    
}

@end
