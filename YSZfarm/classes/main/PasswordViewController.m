//
//  PasswordViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/5/10.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    //取消按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:LocalString(@"取消") forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:LocalString(@"完成") forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView) name:@"modifyPasswordSucc" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifyPasswordSucc" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)done{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyPassword" object:nil userInfo:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
