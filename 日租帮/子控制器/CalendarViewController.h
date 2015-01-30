
#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "iuiueorder.h"
@protocol CalendarChangeDelegate <NSObject>

-(void)saveRoomId:(NSString *)roomId StartDate:(NSString *) StartDate Order:(IuiueOrder *)Order Tag:(NSInteger)tag;//第一次使用

@end

@interface CalendarViewController : UIViewController<CalendarDelegate>

@property(weak,nonatomic)id <CalendarChangeDelegate>ChangeDelegate;//delegate对象

@property(nonatomic,strong)NSArray *OrderList;//订单集合

@property(nonatomic,strong)NSString *roomid;//房间编号

@property(nonatomic,strong)NSString *roomtitle;//房间标题

@property(nonatomic,strong)NSDate *ThisDate;

@end
