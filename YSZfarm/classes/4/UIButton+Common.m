//
//  UIButton+Common.m
//  MOWOX
//
//  Created by Mac on 2017/11/28.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "UIButton+Common.h"
#import "userButton.h"

@implementation UIButton (Common)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn.titleLabel setMinimumScaleFactor:0.5];
    
    //CGFloat titleWidth = [title getWidthWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreen_Width, 30)] +20;
    //btn.frame = CGRectMake(0, 0, titleWidth, 30);
    
    [btn setTitle:title forState:UIControlStateNormal];
    //btn.titleLabel.text = title;
    return btn;
}

+ (UIButton *)userButton:(NSString *)title batteryImage:(UIImage *)image{
    UIButton *btn = [[userButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn.titleLabel setMinimumScaleFactor:0.5];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

- (void)setButtonStyle1{
    self.layer.borderColor = [UIColor colorWithHexString:yColor_back].CGColor;
    self.layer.borderWidth = 1.5;
    self.layer.cornerRadius = ScreenHeight * 0.033;
}

- (void)setButtonStyleWithColor:(UIColor *)color Width:(float)width cornerRadius:(float)radius{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

@end
