//
//  LoginViewController.h
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (strong, nonatomic)  UITextField *userNameTF;
@property (strong, nonatomic)  UITextField *passwordTF;
@property (strong, nonatomic)  UIButton *loginBtn;
@property (strong, nonatomic)  UIButton *accountBtn;

@end

NS_ASSUME_NONNULL_END
