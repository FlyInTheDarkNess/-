//
//  IuiueOrder.m
//  日租帮
//
//  Created by 赵中良 on 14-9-9.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueOrder.h"

@implementation Order

@synthesize startDate,roomId,Price,NumberOfNight;

-(id)initWithStartDate:(NSString *)startdate
                roomid:(NSString *)roomid
                 price:(NSString *)price
         numberOfNight:(NSString *)numberOfNight{
    if (self = [super init]) {
        startDate = startdate;
        roomId = roomid;
        Price = price;
        NumberOfNight = numberOfNight;
    }
    return self;
}

-(NSString *)description{
    NSString *str = [NSString stringWithFormat:@"\"statime\":\"%@\",\"roomid\":\"%@\",\"price\":\"%@\",\"daynum\":\"%@\"",self.startDate,self.roomId,self.Price,self.NumberOfNight];
    return str;
}

@end


@implementation IuiueOrder
@synthesize OrderId,UserName,UserMobile,NumberOfPeople,PersonCount,InType,AllForpaid,OrderArr,paidRent,paidType,Remarks,otherMoney,OrderColor,YJrent,YJrentType,status,numberOfDay;

-(id)initWithUserName:(NSString *)username OrderId:(NSString *)orderid UserMobile:(NSString *)usermobile NumberOfPeople:(NSString *)numberofpeople PersonCount:(NSString *)personcount InType:(NSString *)intype OrderArr:(NSArray *)orderarr AllForpaid:(NSString *)allforpaid paidRent:(NSString *)paidrent paidType:(NSString *)paidtype Remarks:(NSString *)remarks otherMoney:(NSArray *)othermoney YJrent:(NSString *)yjrent YJrentType:(NSString *)yjrenttype OrderColor:(NSString *)ordercolor{
    if (self = [super init]) {
        UserName = username;
        OrderId = orderid;
        UserMobile = usermobile;
        NumberOfPeople = numberofpeople;
        PersonCount = personcount;
        InType = intype;
        OrderArr = orderarr;
        AllForpaid = allforpaid;
        paidType = paidtype;
        paidRent = paidrent;
        Remarks = remarks;
        otherMoney = othermoney;
        OrderColor = ordercolor;
        YJrent = yjrent;
        YJrentType = yjrenttype;
    }
    return self;
}

-(NSString *)description{
    NSString *thring = [NSString stringWithFormat:@"👤：%@\t📱：%@\t🏡：dsfasdf\t🌛：共%d晚\t",UserName,UserMobile,12];
    return thring;
}

@end
