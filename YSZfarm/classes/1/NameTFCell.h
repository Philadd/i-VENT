//
//  NameTFCell.h
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TFBlock)(NSString *text);

@interface NameTFCell : UITableViewCell

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic) TFBlock TFBlock;

@end

NS_ASSUME_NONNULL_END
