//
//  userButton.m
//  YSZfarm
//
//  Created by Mac on 2017/12/14.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "userButton.h"

@implementation userButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width * 0.05, (contentRect.size.height - 30) / 2, 30, 30);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width * 0.05 + 30, 0, contentRect.size.width * 0.8 - 30, contentRect.size.height);
}

@end
