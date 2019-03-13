//
//  BindDeviceTableViewCell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/9.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "BindDeviceTableViewCell.h"

@implementation BindDeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_nameLabel) {
            _nameLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:17.0] textColor:[UIColor blackColor]];
            _nameLabel.frame = CGRectMake(16, 10, 150, 20.5);
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_nameLabel];
        }
        if (!_typeLabel) {
            _typeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:11.0] textColor:[UIColor blackColor]];
            _typeLabel.frame = CGRectMake(16, 30.5, 150, 14.5);
            _typeLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_typeLabel];
        }
        if (!_comLabel) {
            _comLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13.0] textColor:[UIColor blackColor]];
            _comLabel.frame = CGRectMake(ScreenWidth - 100, 15, 84, 20);
            _comLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_comLabel];
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
