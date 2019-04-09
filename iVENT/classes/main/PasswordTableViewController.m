//
//  PasswordTableViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/5/11.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "PasswordTableViewController.h"

@interface PasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *PasswordNewTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPwTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (strong, nonatomic) dispatch_source_t timer;
@end

@implementation PasswordTableViewController{
    NSString *verifyCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[FarmDatabase shareInstance].mobile isEqualToString:@""]) {
        _mobileTF.text = [FarmDatabase shareInstance].mobile;
    }
    [_verifyBtn setButtonStyleWithColor:[UIColor blackColor] Width:1.f cornerRadius:5.f];
    [_verifyBtn addTarget:self action:@selector(confirmAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPassword) name:@"modifyPassword" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyPassword" object:nil];
}

//修改密码
- (void)modifyPassword{
    if ([_PasswordNewTF.text isEqualToString:_confirmNewPwTF.text] &&
        ![_PasswordNewTF.text isEqualToString:@""]) {
        if ([_verifyTF.text isEqualToString:verifyCode]) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *parameters = @{@"mobile":_mobileTF.text,@"password":_PasswordNewTF.text};
            [manager PUT:@"http://rijin.thingcom.com:80/dataPlatform/users/password" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
                if ([responseDic[@"errno"] intValue] == 0) {
                    [NSObject showHudTipStr:LocalString(@"修改密码成功")];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyPasswordSucc" object:nil userInfo:nil];
                }else{
                    [NSObject showHudTipStr:LocalString(@"修改密码失败")];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error:%@",error);
            }];
        }else{
            [NSObject showHudTipStr:LocalString(@"验证码错误")];
        }
        
    }else{
        [NSObject showHudTipStr:LocalString(@"两次密码输入不同或密码为空")];
    }
    
}

//弹出确认警告框
- (void)confirmAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalString(@"确认手机号码") message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码：\n%@",_mobileTF.text] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalString(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:LocalString(@"好") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getVeryfyCode];
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#define yHttpTimeoutInterval 6.f
//获取验证码
- (void)getVeryfyCode{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = yHttpTimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat:@"http://rijin.thingcom.com:80/api/v1/util/sms?mobile=%@",self.mobileTF.text];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
        NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"success:%@",daetr);
        
        if ([responseDic[@"errno"] intValue] == 0) {
            NSDictionary *codeDic = [responseDic[@"data"] objectAtIndex:0];
            verifyCode = codeDic[@"code"];
            [FarmDatabase shareInstance].phoneCode = verifyCode;
            [NSObject showHudTipStr:LocalString(@"验证码已经通过短信的形式发到你的手机")];
            [self openCountdown];
        }else if ([responseDic[@"errno"] intValue] == 1){
            [NSObject showHudTipStr:responseDic[@"error"]];
        }else{
            [NSObject showHudTipStr:LocalString(@"请求验证码失败")];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}

//开始倒计时
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [_verifyBtn sizeToFit];
                [self.verifyBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                [_verifyBtn setButtonStyleWithColor:[UIColor blackColor] Width:1.f cornerRadius:5.f];
                self.verifyBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%.2d秒", seconds] forState:UIControlStateNormal];
                [_verifyBtn sizeToFit];
                [self.verifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [_verifyBtn setButtonStyleWithColor:[UIColor lightGrayColor] Width:1.f cornerRadius:5.f];
                self.verifyBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
@end
