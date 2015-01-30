//
//  IuiueRoom.m
//  日租帮
//
//  Created by 赵中良 on 14-9-10.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueRoom.h"

@implementation IuiueRoom

@synthesize RoomId,RoomTitle,Remarks,DayPrice,Status;

-(id)initWithRoomId:(NSString *)roomid DayPrice:(NSString *)dayprice Remarks:(NSString *)remarks RoomTitle:(NSString *)roomtitle Status:(NSInteger)status{
    if (self = [super init]) {
        DayPrice = dayprice;
        RoomId = roomid;
        RoomTitle = roomtitle;
        Remarks = remarks;
        Status = status;
    }
    return self;
}

@end
