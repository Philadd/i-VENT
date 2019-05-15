//
//  DatapointButtonFFCell.m
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/14.
//  Copyright © 2019 yusz. All rights reserved.
//

#import "DatapointButtonFFCell.h"

@implementation DatapointButtonFFCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        if (!_dataMonitorBtn) {
            _dataMonitorBtn = [[UIButton alloc] init];
            [_dataMonitorBtn setImage:[UIImage imageNamed:@"zhiFFOFF"] forState:UIControlStateNormal];
            [_dataMonitorBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
            _dataMonitorBtn.tag = yUnselect;//默认隐藏，选择后显示
            [self.contentView addSubview:_dataMonitorBtn];
            [_dataMonitorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(35.f),yAutoFit(35.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.right.equalTo(self.contentView.mas_right).offset(yAutoFit(-30.f));
            }];
        }
    }
    return self;
}

- (void)addAction{
    if (self.block) {
        NSString *data = [NSString stringWithFormat:@"%d",255];
        self.block(data);
        NSLog(@"发送置FF信号.....%@",data);
    }
    if (_dataMonitorBtn.tag == yUnselect) {
        _dataMonitorBtn.tag = ySelect;
        [_dataMonitorBtn setImage:[UIImage imageNamed:@"zhiFFON"] forState:UIControlStateNormal];
        
    }else{
        _dataMonitorBtn.tag = yUnselect;
        [_dataMonitorBtn setImage:[UIImage imageNamed:@"zhiFFOFF"] forState:UIControlStateNormal];
    }
}
@end
