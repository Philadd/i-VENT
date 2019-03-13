//
//  NameTFCell.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "NameTFCell.h"

@implementation NameTFCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.font = [UIFont systemFontOfSize:15.f];
            //[_nameLabel setBackgroundColor:[UIColor colorWithRed:108/255.0 green:113/255.0 blue:118/255.0 alpha:1.f]];
            _nameLabel.textColor = [UIColor blackColor];
            _nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(70.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left).offset(20.f);
                
            }];
        }
        if (!_nameTF) {
            _nameTF = [[UITextField alloc] init];
            _nameTF.backgroundColor = [UIColor clearColor];
            _nameTF.font = [UIFont fontWithName:@"Arial" size:15.0f];
            //_nameTF.textColor = [UIColor colorWithHexString:@"222222"];
            //__nameTF.borderStyle = UITextBorderStyleRoundedRect;
            _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            _nameTF.autocorrectionType = UITextAutocorrectionTypeNo;
            _nameTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
            _nameTF.adjustsFontSizeToFitWidth = YES;
            //设置自动缩小显示的最小字体大小
            _nameTF.minimumFontSize = 11.f;
            [_nameTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_nameTF];
            
            [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(230.f), yAutoFit(30.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.nameLabel.mas_right).offset(20.f);
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
