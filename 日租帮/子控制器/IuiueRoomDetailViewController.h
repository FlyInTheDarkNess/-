//
//  IuiueRoomDetailViewController.h
//  日租帮
//
//  Created by 赵中良 on 14-9-10.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IuiueRoom.h"
@protocol SaveRoom <NSObject>

-(void)getRoom:(IuiueRoom *)Room;

@end
@interface IuiueRoomDetailViewController : UIViewController

@property(weak,nonatomic) id<SaveRoom>Roomdelegate;
@property(nonatomic,strong) IuiueRoom *Room;//当前房间，添加房间时则为null

@end
