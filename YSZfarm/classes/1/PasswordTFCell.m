//
//  PasswordTFCell.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "PasswordTFCell.h"

@implementation PasswordTFCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        if (!_passwordLabel) {
            _passwordLabel = [[UILabel alloc] init];
            _passwordLabel.font = [UIFont systemFontOfSize:15.f];
            //[_passwordLabel setBackgroundColor:[UIColor colorWithRed:108/255.0 green:113/255.0 blue:118/255.0 alpha:1.f]];
            _passwordLabel.textColor = [UIColor blackColor];
            _passwordLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_passwordLabel];
            [_passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(70.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left).offset(20.f);
                
            }];
        }
        if (!_passwordTF) {
            _passwordTF = [[UITextField alloc] init];
            _passwordTF.backgroundColor = [UIColor clearColor];
            _passwordTF.font = [UIFont fontWithName:@"Arial" size:15.0f];
            //_passwordTF.textColor = [UIColor colorWithHexString:@"222222"];
            //_passwordTF.borderStyle = UITextBorderStyleRoundedRect;
            _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            _passwordTF.autocorrectionType = UITextAutocorrectionTypeNo;
            _passwordTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
            _passwordTF.adjustsFontSizeToFitWidth = YES;
            //设置自动缩小显示的最小字体大小
            _passwordTF.minimumFontSize = 11.f;
            [_passwordTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_passwordTF];
            
            [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(230.f), yAutoFit(30.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.passwordLabel.mas_right).offset(20.f);
            }];
        }
    }
    return self;
}

-(void)textFieldTextChange:(UITextField *)textField{
    if (self.TFBlock) {
        self.TFBlock(textField.text);
    }
}

@end
