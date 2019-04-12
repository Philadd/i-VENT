//
//  DevieceCell.m
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "DevieceDataCell.h"
#define viewWidth self.contentView.frame.size.width
#define viewHeight self.contentView.frame.size.height

@implementation DevieceDataCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.accessoryType = UITableViewCellAccessoryDetailButton;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_deviceName) {
            _deviceName = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            _deviceName.textAlignment = NSTextAlignmentCenter;
            _deviceName.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:self.deviceName];
            [_deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(80.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(20.f));
            }];
        }
        if (!_monitorData) {
            _monitorData = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            _monitorData.textAlignment = NSTextAlignmentCenter;
            _monitorData.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:self.monitorData];
            [_monitorData mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(80.f),yAutoFit(15.f)));
                make.centerY.equalTo(self.contentView.mas_centerY);
                make.right.equalTo(self.contentView.mas_right).offset(yAutoFit(-10.f));
            }];
        }
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
