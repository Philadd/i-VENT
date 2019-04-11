//
//  NSString+Common.h
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/1/25.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

+ (NSString *)HexByLong:(long)decimalLong;
+ (NSString *)HexByInt:(int)decimalInt;
+ (NSString *)HexByTextFieldDecemal:(NSString *)text;
+ (NSString *)HexByTextFieldFloat:(NSString *)fieldText decimal:(int)decimal;
+ (int)fieldText2long:(NSString *)fieldText decimal:(int)decimal;
+ (int)String2long:(NSString *)text;
+ (NSString *)transform2Hex:(long)decimal;
+ (NSString *)transform4Hex:(long)decimal;
+ (NSString *)lrcFromFrame:(NSString *)frame;
+ (NSString *)crcFromFrame:(NSString *)frame;
+ (int)stringScanToInt:(NSString *)str;
+ (int)hexToDecimal:(NSString *)str;
+ (NSString *)valueFromIntDecUnit:(NSNumber *)N value:(NSNumber *)value unit:(NSString *)unit;
+ (NSString *)valueFromFloat:(NSNumber *)value X1:(float)X1 X2:(float)X2 Y1:(float)Y1 Y2:(float)Y2 unit:(NSString *)unit;
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validatePassword:(NSString *)passWord;
@end
