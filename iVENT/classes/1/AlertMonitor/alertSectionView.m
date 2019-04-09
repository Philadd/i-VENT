//
//  alertSectionView.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/3.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "alertSectionView.h"


@interface alertSectionView ()

@end

@implementation alertSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        if (!_deviceName) {
            _deviceName = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_deviceName];
            [_deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0, 30));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left);
            }];
            _deviceName.text = LocalString(@"名称");
        }
        if (!_status) {
            _status = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            _status.text = LocalString(@"状态");
            [self.contentView addSubview:_status];
            [_status mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0, 30));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.deviceName.mas_right);
            }];
            
        }
        if (!_data) {
            _data = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_data];
            [_data mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0 - 40, 30));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.status.mas_right);
            }];
            _data.text = LocalString(@"数值");
        }
        if (!_time) {
            _time = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_time];
            [_time mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0 + 40, 30));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.data.mas_right);
            }];
            _time.text = LocalString(@"时间");
        }
        _deviceName.textAlignment = NSTextAlignmentCenter;
        _status.textAlignment = NSTextAlignmentCenter;
        _data.textAlignment = NSTextAlignmentCenter;
        _time.textAlignment = NSTextAlignmentCenter;
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(self.contentView.mas_left);
        }];
    }
    return self;
}

@end
