//
//  IuiueOrder.h
//  日租帮
//
//  Created by 赵中良 on 14-9-9.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(nonatomic,strong)NSString *startDate;//入住日期
@property(nonatomic,strong)NSString *roomId;//入住房间
@property(nonatomic,strong)NSString *Price;//单价/间夜
@property(nonatomic,strong)NSString *NumberOfNight;//入住天数

//创建order
-(id)initWithStartDate:(NSString *)startdate
                roomid:(NSString *)roomid
                 price:(NSString *)price
         numberOfNight:(NSString *)numberOfNight;

@end

@interface IuiueOrder : NSObject


@property(nonatomic,strong)NSString *OrderId;//订单编号
@property(nonatomic,strong)NSString *UserName;//房客姓名
@property(nonatomic,strong)NSString *UserMobile;//房客手机号
@property(nonatomic,strong)NSString *NumberOfPeople;//身份证号
@property(nonatomic,strong)NSString *PersonCount;//入住人数
@property(nonatomic,strong)NSString *InType;//房客入住渠道
@property(nonatomic,strong)NSArray *OrderArr;//订单集合
@property(nonatomic,strong)NSString *AllForpaid;//总房费
@property(nonatomic,strong)NSString *paidRent;//支付房费
@property(nonatomic,strong)NSString *paidType;//支付方式
@property(nonatomic,strong)NSString *YJrent;//押金
@property(nonatomic,strong)NSString *YJrentType;//支付方式
@property(nonatomic,strong)NSString *Remarks;//备注信息
@property(nonatomic,strong)NSArray *otherMoney;//其他费用
@property(nonatomic,strong)NSString *OrderColor;//订单颜色
@property(nonatomic,strong)NSString *StartDate;//开始时间
@property(nonatomic,strong)NSString *EndDate;//结束时间
@property(nonatomic,strong)NSString *status;//房间状态
@property(nonatomic,strong)NSString *numberOfDay;//入住天数
/*!
 @method
 @abstract 初始化创建一个订单
 @discussion 根据参数名称依次传递数据，没有数据可以传nil
 @param text 
 OrderId;//订单编号
 UserName;//房客姓名
 UserMobile;//房客手机号
 NumberOfPeople;//身份证号
 PersonCount;//入住人数
 InType;//房客入住渠道
 OrderArr;//订单集合
 paidRent;//支付房费
 paidType;//支付方式
 Remarks;//备注信息
 otherMoney;//其他费用
 AllForpaid;//预付款
 YJrent;//押金
 YJrentType;//支付方式
 OrderColor;//订单颜色
 文字 (这里把这个方法需要的参数列出来)
 @result 返回生成的订单
 */
-(id)initWithUserName:(NSString *)username
              OrderId:(NSString *)orderid
           UserMobile:(NSString *)usermobile
       NumberOfPeople:(NSString *)numberofpeople
          PersonCount:(NSString *)personcount
               InType:(NSString *)intype
             OrderArr:(NSArray *)orderarr
              AllForpaid:(NSString *)allforpaid
             paidRent:(NSString *)paidrent
             paidType:(NSString *)paidtype
              Remarks:(NSString *)remarks
           otherMoney:(NSArray *)othermoney
               YJrent:(NSString *)yjrent
           YJrentType:(NSString *)yjrenttype
           OrderColor:(NSString *)ordercolor;

@end
