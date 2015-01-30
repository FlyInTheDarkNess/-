//
//  IuiueOrderDetailViewController.h
//  日租帮
//
//  Created by 赵中良 on 14-9-11.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IuiueOrder.h"

@protocol SaveOrder <NSObject>

-(void)getOrder:(IuiueOrder *)Order;
@end

@interface IuiueOrderDetailViewController : UIViewController

@property(weak,nonatomic) id<SaveOrder>OrderDelegate;//设置代理
@property(nonatomic,strong) IuiueOrder *Order;//当前订单，添加订单时则为null
@property(nonatomic,strong) NSString *StartDate;//订单日期
@property(nonatomic,strong) NSString *RoomId;//房间编号


@end
