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
            _deviceName.frame = CGRectMake(0, 15, ScreenWidth / 3.0, viewHeight - 30);
            [self.contentView addSubview:self.deviceName];
        }
        if (!_monitorData) {
            _monitorData = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            _monitorData.frame = CGRectMake(ScreenWidth / 3.0 * 2, 15, ScreenWidth / 3.0, viewHeight - 30);
            [self.contentView addSubview:self.monitorData];
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
