

#import <UIKit/UIKit.h>
#import "NewButton.h"
@protocol CalendarDelegate <NSObject>

-(void)tappedOnDate:(NSDate *)selectedDate button:(NewButton*)button;
-(void)swipOnDate:(NSString *)MonthYear;
-(void)GetOrderList:(NSArray *)List;
@end

@interface CalendarView : UIView
{
    NSInteger _selectedDate;
    NSArray *_weekNames;
}

@property (nonatomic,strong) NSDate *calendarDate;

@property (nonatomic,weak) id<CalendarDelegate> delegate;

@property (nonatomic,strong) NSArray *Orderlist;

@property (nonatomic,strong) NSString *roomid;//房间id

//日历页向右滑动
-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer;
//日历页向左滑动
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer;

-(void)Refresh;//重绘

@end
