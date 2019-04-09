//
//  RegisterViewController.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"
#import "NameTFCell.h"
#import "PasswordTFCell.h"
#import "PhoneTFCell.h"
#import "PhoneVerityCell.h"
#import "MMDrawerController.h"
#import "LeftDrawerViewController.h"

NSString *const CellIdentifier_RegisterName = @"CellID_RegisterName";
NSString *const CellIdentifier_RegisterPhone = @"CellID_RegisterPhone";
NSString *const CellIdentifier_RegisterPhoneVerify = @"CellID_RegisterPhoneVerify";
NSString *const CellIdentifier_RegisterPassword = @"CellID_RegisterPassword";

@interface RegisterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *registerTable;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *pwText;
@property (nonatomic, strong) NSString *pwConText;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    //self.view.alpha = 0.9;
    [self setNavItem];
    
    _registerTable = [self registerTable];
    _nickname = @"";
    _phone = @"";
    _code = @"";
    _pwText = @"";
    _pwConText = @"";
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

#pragma mark - LazyLoad
static float HEIGHT_CELL = 50.f;

- (void)setNavItem{
    self.navigationItem.title = LocalString(@"注册新用户");
}

- (UITableView *)registerTable{
    if (!_registerTable) {
        _registerTable = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - getRectNavAndStatusHight)];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.dataSource = self;
            tableView.delegate = self;
             [tableView registerClass:[NameTFCell class] forCellReuseIdentifier:CellIdentifier_RegisterName];
             [tableView registerClass:[PhoneTFCell class] forCellReuseIdentifier:CellIdentifier_RegisterPhone];
            [tableView registerClass:[PhoneVerityCell class] forCellReuseIdentifier:CellIdentifier_RegisterPhoneVerify];
            [tableView registerClass:[PasswordTFCell class] forCellReuseIdentifier:CellIdentifier_RegisterPassword];
          
            tableView.separatorColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.08];
            
            [self.view addSubview:tableView];
            tableView.scrollEnabled = NO;
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
            footView.backgroundColor = [UIColor clearColor];
            _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_registerBtn setTitle:LocalString(@"注册") forState:UIControlStateNormal];
            _registerBtn.frame = CGRectMake(0, yAutoFit(30.f), yAutoFit(345.f), 50);
            [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_registerBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
            [_registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
            _registerBtn.center = footView.center;
            _registerBtn.layer.borderWidth = 0.5;
            _registerBtn.layer.borderColor = [UIColor colorWithHexString:@"4778CC"].CGColor;
            _registerBtn.layer.cornerRadius = _registerBtn.bounds.size.height / 2.f;
            [footView addSubview:_registerBtn];
            
            tableView.tableFooterView = footView;
            
            tableView;
        });
    }
    return _registerTable;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NameTFCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegisterName];;
        if (cell == nil) {
            cell = [[NameTFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegisterName];
        }
        cell.nameTF.placeholder = LocalString(@"请输入用户名");
        cell.nameLabel.text = LocalString(@"用户名");
        cell.TFBlock = ^(NSString *text) {
            self.nickname = text;
            [self textFieldChange];
        };
        return cell;
    }
    else if (indexPath.row == 1) {
        PhoneTFCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegisterPhone];;
        if (cell == nil) {
            cell = [[PhoneTFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegisterPhone];
        }
        cell.phoneLabel.text = LocalString(@"手机号");
        cell.TFBlock = ^(NSString *text) {
            self.phone = text;
            [self textFieldChange];
        };
        return cell;
    }
    else if (indexPath.row == 2) {
        PasswordTFCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegisterPassword];
        if (cell == nil) {
            cell = [[PasswordTFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegisterPassword];
            
        }
        cell.passwordTF.secureTextEntry = YES;
        cell.passwordLabel.text = LocalString(@"密码");
        cell.passwordTF.placeholder = LocalString(@"请输入密码（6位以上字符）");
        cell.TFBlock = ^(NSString *text) {
            self.pwText = text;
            [self textFieldChange];
        };
        return cell;
    }
    else if (indexPath.row == 3) {
        PasswordTFCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegisterPassword];
        if (cell == nil) {
            cell = [[PasswordTFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegisterPassword];
            
        }
        cell.passwordTF.secureTextEntry = YES;
        cell.passwordLabel.text = LocalString(@"确认密码");
        cell.passwordTF.placeholder = LocalString(@"请再次输入密码");
        cell.TFBlock = ^(NSString *text) {
            self.pwConText = text;
            [self textFieldChange];
        };
        return cell;
        
    }else{
        PhoneVerityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_RegisterPhoneVerify];
        if (cell == nil) {
            cell = [[PhoneVerityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier_RegisterPhoneVerify];
        }
        cell.TFBlock = ^(NSString *text) {
            self.code = text;
            [self textFieldChange];
        };
        cell.BtnBlock = ^BOOL{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            //设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = yHttpTimeoutInterval;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            NSString *url;
            if ([NSString validateMobile:self.phone]){
                url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/util/sms?mobile=%@",self.phone];
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
            }else {
                [NSObject showHudTipStr:LocalString(@"手机号码不正确")];
                return NO;
            }
            
            [manager GET:url parameters:nil progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                     NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
                     NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                     NSLog(@"success:%@",daetr);
                     if ([[responseDic objectForKey:@"errno"] intValue] == 0) {
                         [NSObject showHudTipStr:LocalString(@"已向您的手机发送验证码")];
                     }else{
                         [NSObject showHudTipStr:[responseDic objectForKey:@"error"]];
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"Error:%@",error);
                     [NSObject showHudTipStr:LocalString(@"操作失败")];
                     
                 }
             ];
            return YES;
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_CELL;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

#pragma mark - Actions
- (void)registerUser{
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = yHttpTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = [[NSDictionary alloc] init];
    if ([NSString validateMobile:_phone] && _code.length == 6 && _pwText.length >= 6 && [_pwText isEqualToString:_pwConText]){
        parameters = @{@"name":_nickname,@"mobile":_phone,@"code":_code,@"password":_pwText,@"company":@"aa"};
        NSLog(@"%@",parameters);
    }else{
        [NSObject showHudTipStr:LocalString(@"注册用户失败，请检查您填写的信息")];
        [SVProgressHUD dismiss];
        return;
    }
    
    [manager POST:@"http://rijin.thingcom.com/api/v1/user" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
        NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"success:%@",daetr);
              if ([[responseDic objectForKey:@"errno"] intValue] == 0) {

                  //保存数据 用户信息；用户名；用户密码
                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                  [userDefaults setObject:self.phone forKey:@"mobile"];
                  [userDefaults setObject:self.pwText forKey:@"passWord"];
                  [userDefaults synchronize];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                  });
                
                  [self.navigationController popToRootViewControllerAnimated:YES];
                  [NSObject showHudTipStr:LocalString(@"注册成功")];
                  
              }else if ([responseDic[@"errno"] intValue] == 1){
                  [NSObject showHudTipStr:responseDic[@"error"]];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                  });
              }else{
                  [NSObject showHudTipStr:LocalString(@"注册用户失败，请检查验证码和密码是否填写错误")];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [SVProgressHUD dismiss];
                  });
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error:%@",error);
              if (error.code == -1001) {
                  [NSObject showHudTipStr:LocalString(@"当前网络状况不佳")];
              }
              dispatch_async(dispatch_get_main_queue(), ^{
                  [SVProgressHUD dismiss];
              });
          }
     ];
}

- (void)textFieldChange{
    if (![_code isEqualToString:@""] && ![_phone isEqualToString:@""] && ![_pwText isEqualToString:@""] && ![_pwConText isEqualToString:@""]) {
        [_registerBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:1]];
    }else{
        [_registerBtn setBackgroundColor:[UIColor colorWithRed:71/255.0 green:120/255.0 blue:204/255.0 alpha:0.4]];
    }
}

@end
