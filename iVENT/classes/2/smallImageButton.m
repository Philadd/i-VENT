//
//  smallImageButton.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/4/11.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "smallImageButton.h"

@implementation smallImageButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width * 0.1, (contentRect.size.height - 20) / 2, 20, 20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width * 0.2 + 20, 0, contentRect.size.width * 0.8 - 20, contentRect.size.height);
}
@end
