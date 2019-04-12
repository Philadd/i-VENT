//
//  DatapointBitCell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/1/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "DatapointBitCell.h"

#define viewWidth self.contentView.frame.size.width
#define viewHeight self.contentView.frame.size.height

@implementation DatapointBitCell
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
        if (!_dataMonitorSwitch) {
            _dataMonitorSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth / 3.0 * 2 + (ScreenWidth / 3.0 - 50)/2.0, (viewHeight - 30)/2.0, 50, 30)];
            [_dataMonitorSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:_dataMonitorSwitch];
        }
    }
    return self;
}

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    if (self.block) {
        self.block(switchButton.isOn);
    }
}

@end
