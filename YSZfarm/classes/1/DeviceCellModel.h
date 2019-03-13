//
//  DeviceCellModel.h
//  YSZfarm
//
//  Created by Mac on 2017/12/25.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceCellModel : NSObject
@property (nonatomic) BOOL isUnusual;

@property (nonatomic,strong) NSString *sn;
@property (nonatomic,strong) NSString *dataType;
@property (nonatomic,strong) NSString *unit;
@property (nonatomic,strong) NSString *addressType;
@property (nonatomic,strong) NSString *streamId;
@property (nonatomic,strong) NSString *streamUid;
@property (nonatomic,strong) NSString *streamName;
@property (nonatomic,strong) NSString *writeRead;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSNumber *state;
@property (nonatomic,strong) NSNumber *value;
@property (nonatomic,strong) NSNumber *intBit;
@property (nonatomic,strong) NSNumber *decimalBit;



///@brife modbus、plc、local设备信息
@property (nonatomic,strong) NSNumber *slaveAdr;//modbus从地址
@property (nonatomic,strong) NSNumber *address;//plc寄存器
@property (nonatomic,strong) NSNumber *modbusRegisterAdd;//modbus寄存器地址
@property (nonatomic,strong) NSNumber *modbusCode;//modbus功能码
@property (nonatomic,strong) NSString *bindDeviceName;//判断是哪种设备
@property (nonatomic,strong) NSString *bindDeviceType;//判断local、modbus、还是plc的名字
@property (nonatomic,strong) NSString *protocol;
@end
