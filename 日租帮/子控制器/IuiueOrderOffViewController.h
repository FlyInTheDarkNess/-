//
//  IuiueOrderOffViewController.h
//  日租帮
//
//  Created by 赵中良 on 14/10/24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Iuiueorder.h"

@interface IuiueOrderOffViewController : UIViewController

@property(nonatomic,strong)IuiueOrder *MyOrder;
@property(nonatomic,strong)NSString *SelectDate;//选择日期

@end
