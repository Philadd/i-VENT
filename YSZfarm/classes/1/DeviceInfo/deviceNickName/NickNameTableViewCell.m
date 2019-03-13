//
//  NickNameTableViewCell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/2.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "NickNameTableViewCell.h"

@implementation NickNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - resign keyboard control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_nickNameTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
