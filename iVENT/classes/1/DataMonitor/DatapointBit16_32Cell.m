//
//  DatapointBit16_32Cell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/1/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "DatapointBit16_32Cell.h"
#import "IQUIView+IQKeyboardToolbar.h"

#define viewWidth self.contentView.frame.size.width
#define viewHeight self.contentView.frame.size.height

@interface DatapointBit16_32Cell () <UITextFieldDelegate>
@end

@implementation DatapointBit16_32Cell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done) name:@"dataMonitorDataTFDone" object:nil];
        if (!_dataMonitorName) {
            _dataMonitorName = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            _dataMonitorName.textAlignment = NSTextAlignmentCenter;
            _dataMonitorName.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:self.dataMonitorName];
            [_dataMonitorName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(80.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(20.f));
            }];
        }
        if (!_dataMonitorDataTF) {
            _dataMonitorDataTF = [[UITextField alloc] init];
            _dataMonitorDataTF.textAlignment = NSTextAlignmentCenter;
            _dataMonitorDataTF.keyboardType = UIKeyboardTypeDecimalPad;
            _dataMonitorDataTF.font = [UIFont systemFontOfSize:13.0];
            _dataMonitorDataTF.delegate = self;
            _dataMonitorDataTF.adjustsFontSizeToFitWidth = YES;
            [_dataMonitorDataTF addDoneOnKeyboardWithTarget:self action:@selector(doneAction)];
            [_dataMonitorDataTF addTarget:self action:@selector(TFchange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_dataMonitorDataTF];
            [_dataMonitorDataTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(80.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.right.equalTo(self.contentView.mas_right).offset(yAutoFit(-10.f));
            }];
        }
        if (!_uintData) {
            _uintData = [[UILabel alloc] init];
            _uintData = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:self.uintData];
            
            [_uintData mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(15.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.right.equalTo(self.contentView.mas_right).offset(yAutoFit(-10.f));
            }];
        }
        
    }
    return self;
}

- (void)doneAction{
    if ([NSString String2long:_dataMonitorDataTF.text] > 90) {
        if (self.block) {
            self.block([NSString stringWithFormat:@"90"]);
            _dataMonitorDataTF.text = [NSString stringWithFormat:@"90"];
            [NSObject showHudTipStr:LocalString(@"Input number more than limit")];
        }
    }else{
        if (self.block) {
            NSString *data = [NSString stringWithFormat:@"%d", [_dataMonitorDataTF.text intValue] *4095/90];
            self.block(data);
        }
    }
    //开始刷新数据
    if (self.block_timerstart) {
        self.block_timerstart();
    }
    [_dataMonitorDataTF resignFirstResponder];
}

- (void)done {
    [_dataMonitorDataTF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}
//停止刷新
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.block_timerpause) {
        self.block_timerpause();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block_timerpause) {
        self.block_timerpause();
    }
}

- (void)TFchange:(UITextField *)textField{
    if (_dataMonitorDataTF.text.length >4) {
        _dataMonitorDataTF.text = [_dataMonitorDataTF.text substringWithRange:NSMakeRange(0, 4)];
    }

}

@end
