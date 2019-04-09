//
//  NickNameViewController.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/2.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *nickName;
@end
