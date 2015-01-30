//
//  IuiueRoom.h
//  日租帮
//
//  Created by 赵中良 on 14-9-10.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IuiueRoom : NSObject

@property(nonatomic,strong)NSString *RoomId;//房间编号
@property(nonatomic,strong)NSString *DayPrice;//房间单价/间夜
@property(nonatomic,strong)NSString *Remarks;//备注信息
@property(nonatomic,strong)NSString *RoomTitle;//房间名称
@property(nonatomic,assign)NSInteger Status;//房间状态 0，空房 1，已入住 2 预订


//初始化方法
-(id)initWithRoomId:(NSString *)roomid
           DayPrice:(NSString *)dayprice
            Remarks:(NSString *)remarks
          RoomTitle:(NSString *)roomtitle
             Status:(NSInteger)status;

@end
