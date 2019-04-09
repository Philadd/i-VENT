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
            _dataMonitorName.frame = CGRectMake(0, 15, ScreenWidth / 3.0, viewHeight - 30);
            [self.contentView addSubview:_dataMonitorName];
        }
        if (!_dataMonitorDataTF) {
            _dataMonitorDataTF = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth / 3.0 * 2 + (ScreenWidth / 3.0 - 90)/2.0, 5, 90, viewHeight - 10)];
            _dataMonitorDataTF.textAlignment = NSTextAlignmentCenter;
            _dataMonitorDataTF.keyboardType = UIKeyboardTypeDecimalPad;
            _dataMonitorDataTF.font = [UIFont systemFontOfSize:13.0];
            _dataMonitorDataTF.delegate = self;
            [_dataMonitorDataTF addDoneOnKeyboardWithTarget:self action:@selector(doneAction)];
            [_dataMonitorDataTF addTarget:self action:@selector(TFchange:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_dataMonitorDataTF];
        }
        if (!_uintData) {
            _uintData = [[UILabel alloc] init];
            _uintData = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:self.uintData];
            
            [_uintData mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(viewHeight - 10),yAutoFit(viewHeight - 10)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.right.equalTo(self.dataMonitorDataTF.mas_right).offset(5);
            }];
        }
        
    }
    return self;
}

- (void)doneAction{
    if ([NSString String2long:_dataMonitorDataTF.text] > 4095) {
        if (self.block) {
            self.block([NSString stringWithFormat:@"4095"]);
            _dataMonitorDataTF.text = [NSString stringWithFormat:@"4095"];
            [NSObject showHudTipStr:LocalString(@"Input number more than limit")];
        }
    }else{
        if (self.block) {
            self.block(_dataMonitorDataTF.text);
        }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[_timer setFireDate:[NSDate distantFuture]];
    if (self.block_timerpause) {
        self.block_timerpause();
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //[_timer setFireDate:[NSDate date]];
    if (self.block_timerstart) {
        self.block_timerstart();
    }
    
}

- (void)TFchange:(UITextField *)textField{
    if (_dataMonitorDataTF.text.length >4) {
        _dataMonitorDataTF.text = [_dataMonitorDataTF.text substringWithRange:NSMakeRange(0, 4)];
    }

}

@end
