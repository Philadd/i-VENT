//
//  SectionView.m
//  YSZfarm
//
//  Created by Mac on 2017/12/19.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "SectionView.h"
#import "SectionModel.h"

#define alarmLabelWidth 60

@interface SectionView ()
@property (nonatomic,strong) UIImageView *arrowImage;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation SectionView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, (SectionViewHeight - 25) / 2, 25, 25)];
        self.arrowImage.image = [UIImage imageNamed:@"箭头"];
        [self.contentView addSubview:_arrowImage];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, (SectionViewHeight - 20) / 2, ScreenWidth - 35 - alarmLabelWidth, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        self.alarmLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - alarmLabelWidth, (SectionViewHeight - 20) / 2, alarmLabelWidth, 20)];
        self.alarmLabel.font = [UIFont systemFontOfSize:17];
        self.alarmLabel.textColor = [UIColor redColor];
        _alarmLabel.text = LocalString(@"报警");
        _alarmLabel.hidden = YES;
        [self.contentView addSubview:_alarmLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SectionViewHeight - 1, ScreenWidth, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setModel:(SectionModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.titleLabel.text = model.groupName;
    if (model.isExpand) {
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }else{
        self.arrowImage.transform = CGAffineTransformIdentity;
    }
}

- (void)btnClick:(UIButton *)sender{
    self.model.isExpand = !self.model.isExpand;
    if (self.model.isExpand) {
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }else{
        self.arrowImage.transform = CGAffineTransformIdentity;
    }
    if (self.block) {
        self.block(self.model.isExpand);
    }
}

@end