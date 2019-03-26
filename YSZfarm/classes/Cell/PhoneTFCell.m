//
//  PhoneTFCell.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "PhoneTFCell.h"

@implementation PhoneTFCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:15.f];
        //[_phoneLabel setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.f]];
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(yAutoFit(70.f),yAutoFit(15.f)));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20.f);
            
        }];
        
    }
        if (!_phoneTF) {
            _phoneTF = [[UITextField alloc] init];
            _phoneTF.backgroundColor = [UIColor clearColor];
            _phoneTF.placeholder = LocalString(@"请输入手机号");
            _phoneTF.font = [UIFont fontWithName:@"Arial" size:15.f];
            //_phoneTF.textColor = [UIColor colorWithHexString:@"222222"];
            //_phoneTF.borderStyle = UITextBorderStyleRoundedRect;
            _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            _phoneTF.autocorrectionType = UITextAutocorrectionTypeNo;
            _phoneTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
            _phoneTF.adjustsFontSizeToFitWidth = YES;
            //设置自动缩小显示的最小字体大小
            _phoneTF.minimumFontSize = 11.f;
            [_phoneTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_phoneTF];
            
            [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(230.f), yAutoFit(30.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.phoneLabel.mas_right).offset(20.f);
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
