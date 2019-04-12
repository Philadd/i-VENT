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
            _dataMonitorBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 3.0 * 2 + (ScreenWidth / 3.0 - 50)/2.0, (viewHeight - 30)/2.0, 50, 30)];
            [_dataMonitorBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:_dataMonitorBtn];
        }
    }
    return self;
}

- (void)addAction:(id)sender{
    //    UISwitch *switchButton = (UISwitch *)sender;
    //    if (self.block) {
    //        self.block(switchButton.isOn);
    //    }
    NSLog(@"置FF");
}
@end
