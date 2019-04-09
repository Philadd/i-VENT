//
//  UnusualTableViewCell.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/17.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "UnusualTableViewCell.h"

#define viewHeight self.contentView.frame.size.height

@implementation UnusualTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_dataMonitorName) {
            _dataMonitorName = [UILabel labelWithFont:[UIFont systemFontOfSize:15.0] textColor:[UIColor blackColor]];
            _dataMonitorName.frame = CGRectMake(0, 15, ScreenWidth / 3.0, viewHeight - 30);
            [self.contentView addSubview:_dataMonitorName];
        }
        if (!_unusualView) {
            _unusualView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth / 3.0 * 2 + (ScreenWidth / 3.0 - 30)/2.0, (viewHeight - 30)/2.0, 30, 30)];
            [_unusualView setImage:[UIImage imageNamed:@"unusual"]];
            [self.contentView addSubview:_unusualView];
        }
    }
    return self;
}

@end
