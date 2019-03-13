//
//  PhoneVerityCell.h
//  YSZfarm
//
//  Created by 安建伟 on 2019/3/7.
//  Copyright © 2019 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TFBlock)(NSString *text);
typedef BOOL(^BtnBlock)(void);

@interface PhoneVerityCell : UITableViewCell

@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UIImageView *verifyimage;
@property (nonatomic) TFBlock TFBlock;
@property (nonatomic) BtnBlock BtnBlock;

@property (strong, nonatomic) dispatch_source_t timer;

-(void)openCountdown;

@end

NS_ASSUME_NONNULL_END
