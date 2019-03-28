//
//  AlertCell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/2/26.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "AlertCell.h"

#define viewWidth self.contentView.frame.size.width
#define viewHeight self.contentView.frame.size.height

@implementation AlertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_deviceName) {
            _deviceName = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_deviceName];
            _data.adjustsFontSizeToFitWidth = YES;
            [_deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0, viewHeight));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left);
            }];
        }
        if (!_status) {
            _status = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_status];
            _data.adjustsFontSizeToFitWidth = YES;
            [_status mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0, viewHeight));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.deviceName.mas_right);
            }];
        }
        if (!_data) {
            _data = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_data];
            _data.adjustsFontSizeToFitWidth = YES;
            [_data mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0 - 40, viewHeight));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.status.mas_right);
            }];
        }
        if (!_time_ymd) {
            _time_ymd = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_time_ymd];
            [_time_ymd mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0 + 40, viewHeight / 2.0));
                make.top.equalTo(self.data.mas_top);
                make.left.equalTo(self.data.mas_right);
            }];
        }
        if (!_time_hms) {
            _time_hms = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            [self.contentView addSubview:_time_hms];
            [_time_hms mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth / 4.0 + 40, viewHeight / 2.0));
                make.bottom.equalTo(self.data.mas_bottom);
                make.left.equalTo(self.data.mas_right);
            }];
        }
        _deviceName.textAlignment = NSTextAlignmentCenter;
        _deviceName.lineBreakMode = NSLineBreakByWordWrapping;
        _deviceName.numberOfLines = 0;
        _status.textAlignment = NSTextAlignmentCenter;
        _status.lineBreakMode = NSLineBreakByWordWrapping;
        _data.textAlignment = NSTextAlignmentCenter;
        _data.lineBreakMode = NSLineBreakByWordWrapping;
        _data.numberOfLines = 0;
        _time_ymd.textAlignment = NSTextAlignmentCenter;
        _time_ymd.numberOfLines = 0;
        _time_hms.textAlignment = NSTextAlignmentCenter;
        _time_hms.numberOfLines = 0;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
