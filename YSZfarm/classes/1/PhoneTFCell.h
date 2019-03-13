//
//  PhoneTFCell.h
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TFBlock)(NSString *text);

@interface PhoneTFCell : UITableViewCell

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic) TFBlock TFBlock;

@end

NS_ASSUME_NONNULL_END
