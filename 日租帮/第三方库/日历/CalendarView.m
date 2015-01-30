
#import "CalendarView.h"
UIColor *MyColor;
@interface CalendarView()

{
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    MBProgressHUD *hud;
    NSArray *Quan_arr;
    NSArray *Quan_little;
}

@end
@implementation CalendarView
@synthesize Orderlist;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",self.calendarDate);
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        Quan_arr = @[@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",@"eleven",@"twelve"];
        Quan_little = @[@"first",@"second",@"third",@"forth",@"fifth",@"sixth",@"seventh",@"eighth",@"ninth",@"tenth",@"eleventh",@"twelfth"];
//        UILabel *label = [[UILabel alloc]iinitWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-100, self.bounds.size.width, 44)];
//        [label setBackgroundColor:[UIColor brownColor]];
//        [label setTextColor:[UIColor whiteColor]];
//        [label setText:@"swipe to change months"];
//        label.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:label];
//        [UILabel beginAnimations:NULL context:nil];
//        [UILabel setAnimationDuration:2.0];
//        [label setAlpha:0];
//        [UILabel commitAnimations];

    }
    return self;
}

-(void)setCalendarDate:(NSDate *)calendarDate{
    _calendarDate = calendarDate;
}
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%@",self.calendarDate);
    MyColor = [UIColor brownColor];
    [self setCalendarParameters];
    _weekNames = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
//    _selectedDate  =components.day;
    
    components.day = 1;
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    NSInteger weekday = [comps weekday];
//      NSLog(@"components%d %d %d",_selectedDate,_selectedMonth,_selectedYear);
    //决定星期的开始
    weekday  = weekday - 1;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = 40;
    float hight = 40.0f;
    if (rect.size.width < MY_WIDTH / 2) {
        width = 17;
        hight = 20.0f;
    }
    
    NSInteger originX = 10;
    NSInteger originY = 0;
    NSInteger monthLength = days.length;
    

    
//    UILabel *titleText = [[UILabel alloc]initWithFrame:CGRectMake(0,20, self.bounds.size.width, 40)];
//    titleText.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    NSString *dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    [_delegate swipOnDate:dateString];
    
//    [titleText setText:dateString];
//    [titleText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
//    [titleText setTextColor:[UIColor brownColor]];
//    [self addSubview:titleText];
    [format setDateFormat:@"yyyy-MM"];
    NSString *ThisDateString = [[format stringFromDate:self.calendarDate] uppercaseString];

    //一周标识
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), originY + 3, width, width)];
        [weekNameLabel setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        if (rect.size.width < MY_WIDTH / 2) {
            [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
        }
        else{
            [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        }
        
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
    }
    
    
    
    for (NSInteger i= 0; i<monthLength; i++)
    {
//        NewButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NewButton *button = [[NewButton alloc]init];
        button.tag = i+1;
        button.titleLabel.text = [NSString stringWithFormat:@"%d",i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        if (rect.size.width < MY_WIDTH / 2) {
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];
        }
        else{
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        }
        [button addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+hight+offsetY, width, width)];
//        [button.layer setBorderColor:[MyColor CGColor]];
//        [button.layer setBorderWidth:1.0];
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = MyColor;
//        if(((i+weekday)/columns)==0)
//        {
//            [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
//            [button addSubview:lineView];
//        }
//
//        if(((i+weekday)/columns)==((monthLength+weekday-1)/columns))
//        {
//            [lineView setFrame:CGRectMake(0, button.frame.size.width-1, button.frame.size.width, 1)];
//            [button addSubview:lineView];
//        }
        
//        UIView *columnView = [[UIView alloc]init];
//        [columnView setBackgroundColor:[UIColor brownColor]];
//        if((i+weekday)%7==0)
//        {
//            [columnView setFrame:CGRectMake(0, 0, 1, button.frame.size.width)];
//            [button addSubview:columnView];
//        }
//        else if((i+weekday)%7==6)
//        {
//            [columnView setFrame:CGRectMake(button.frame.size.width-1, 0, 1, button.frame.size.width)];
//            [button addSubview:columnView];
//        }
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear)
        {
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.text = [NSString stringWithFormat:@"今"];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"今"] forState:UIControlStateNormal];
        }
        //        else{
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        if (self.Orderlist) {
            for (NSDictionary *orderDic in self.Orderlist) {
                //计算订单的时间有待进一步处理
                NSString *starttime = [NSString stringWithFormat:@"%@",orderDic[@"statime"]];
                if (starttime.length > 8) {
                    
                }else{
//                    [self makeToast:@"订单数据错误"];
                }
                NSString *endTime = [NSString stringWithFormat:@"%@",orderDic[@"endtime"]];
                if (endTime.length > 8) {
                    
                }else{
//                    [self makeToast:@"订单数据错误"];
                }
                NSArray *stadateArr = [starttime componentsSeparatedByString:@"-"];
                NSArray *enddatearr = [endTime componentsSeparatedByString:@"-"];
                NSString *dateStr;
                if (button.tag>9) {
                    dateStr = [NSString stringWithFormat:@"%@-%d",ThisDateString,button.tag];
                }else{
                    dateStr = [NSString stringWithFormat:@"%@-0%d",ThisDateString,button.tag];
                }
                NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
                NSString *startStr = [stadateArr componentsJoinedByString:@""];
                NSString *endStr = [enddatearr componentsJoinedByString:@""];
                NSString *thisStr = [dateArr componentsJoinedByString:@""];
                NSString *ColorNumber = [NSString stringWithFormat:@"%@",orderDic[@"color"]];
                if ([startStr integerValue]<=[thisStr integerValue]&&[endStr integerValue]>[thisStr integerValue]) {
                    button.OrderId = [NSString stringWithFormat:@"%@",orderDic[@"orderid"]];
                    if ([orderDic[@"status"] integerValue]==2||[orderDic[@"status"] integerValue]==4) {
//                        [button setBackgroundColor:[UIColor grayColor]];
//                        [button setImage:[UIImage imageNamed:@"Order_color_blue"] forState:UIControlStateNormal];
                        if (rect.size.width < MY_WIDTH / 2) {
                            [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:Quan_little[11]]]];
                        }else{
                            [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:Quan_arr[11]]]];
                        }
                    }else{
                        if (rect.size.width < MY_WIDTH / 2) {
                            [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:Quan_little[[ColorNumber integerValue]]]]];
                        }else{
                            [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:Quan_arr[[ColorNumber integerValue]]]]];
                        }
                    }
                    [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                }else if ([startStr integerValue]>[endStr integerValue]){
                    [[UIApplication sharedApplication].keyWindow makeToast:@"订单数据错误"];
                }
                else{
//                    [button setBackgroundColor:[UIColor whiteColor]];
//                    [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                }
            }
        }else{
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        
        if(i+1 ==_selectedDate && components.month == _selectedMonth && components.year == _selectedYear)
        {
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            button.titleLabel.text = [NSString stringWithFormat:@"今"];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [button setTitle:[NSString stringWithFormat:@"今"] forState:UIControlStateNormal];
        }

        
        //        }
        [self addSubview:button];
    }
    
    NSDateComponents *previousMonthComponents = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [c rangeOfUnit:NSDayCalendarUnit
                   inUnit:NSMonthCalendarUnit
                  forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
    
    
    for (int i=0; i<weekday; i++) {
        NewButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text = [NSString stringWithFormat:@"%d",maxDate+i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",maxDate+i+1] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width *(i/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+hight+offsetY, width, width)];
//        [button.layer setBorderWidth:1.0];
//        [button.layer setBorderColor:[MyColor CGColor]];
//        UIView *columnView = [[UIView alloc]init];
//        [columnView setBackgroundColor:MyColor];
//        if(i==0)
//        {
//            [columnView setFrame:CGRectMake(0, 0, 1, button.frame.size.width)];
//            [button addSubview:columnView];
//        }

//        UIView *lineView = [[UIView alloc]init];
//        [lineView setBackgroundColor:MyColor];
//        [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 1)];
//        [button addSubview:lineView];
        [button setTitleColor:[UIColor colorWithRed:229.0/255.0 green:231.0/255.0 blue:233.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
        if (rect.size.width < MY_WIDTH / 2) {
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];
        }
        else{
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        }
        [button setEnabled:NO];
        [self addSubview:button];
    }
    
    
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays >0){
        for (int i=remainingDays; i<columns; i++) {
            NewButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.text = [NSString stringWithFormat:@"%d",(i+1)-remainingDays];
            [button setTitle:[NSString stringWithFormat:@"%d",(i+1)-remainingDays] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [button setFrame:CGRectMake(originX+offsetX, originY+hight+offsetY, width, width)];
//            [button.layer setBorderWidth:1.0];
//            [button.layer setBorderColor:[MyColor CGColor]];
//            UIView *columnView = [[UIView alloc]init];
//            [columnView setBackgroundColor:MyColor];
//            if(i==columns - 1)
//            {
//                [columnView setFrame:CGRectMake(button.frame.size.width-1, 0, 1, button.frame.size.width)];
//                [button addSubview:columnView];
//            }
//            UIView *lineView = [[UIView alloc]init];
//            [lineView setBackgroundColor:MyColor];
//            [lineView setFrame:CGRectMake(0, button.frame.size.width-1, button.frame.size.width, 1)];
//            [button addSubview:lineView];
            [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            if (rect.size.width < MY_WIDTH / 2) {
                [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0f]];
            }
            else{
                [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
            }
            [button setEnabled:NO];
            [self addSubview:button];

        }
    }

}
-(IBAction)tappedDate:(UIButton *)sender
{
    NewButton *button = (NewButton *)sender;
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
//    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year]))
//    {
//        if(_selectedDate != -1)
//        {
//            UIButton *previousSelected =(UIButton *) [self viewWithTag:_selectedDate];
//            [previousSelected setBackgroundColor:[UIColor clearColor]];
//            [previousSelected setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//            
//        }
    //去掉点击效果
//    if (!button.OrderId) {
//        [sender setBackgroundColor:[UIColor brownColor]];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }else{
//        [sender setBackgroundColor:[UIColor brownColor]];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
    
    
//        _selectedDate = sender.tag;
      NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
        components.day = sender.tag;
//        _selectedMonth = components.month;
//        components.month = _selectedMonth;
//        _selectedYear = components.year;
        NSDate *clickedDate = [gregorian dateFromComponents:components];
//        NSDate *clickeDate = [NSDate dateWithTimeInterval:24*3600 sinceDate:clickedDate];
        [self.delegate tappedOnDate:clickedDate button:button];
//    }
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month += 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM "];
    NSString *dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    [self SendToCanlendar:dateString];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.calendarDate];
    components.day = 1;
    components.month -= 1;
    self.calendarDate = [gregorian dateFromComponents:components];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM "];
    NSString *dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    [self SendToCanlendar:dateString];

}
-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [gregorian setFirstWeekday:1];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
    }
}

-(void)Refresh{
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}

-(void)SendToCanlendar:(NSString *)dateStr{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MONTH_LIST]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:self.roomid forKey:@"roomid"];
    [request addPostValue:dateStr forKey:@"statime"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                    [self.superview makeToast:str duration:0.5 position:@"center"];
                    NSArray *list = resultDict[@"info_list"];
                    self.Orderlist = list;
//                    self.OrderList = list;
                    [_delegate GetOrderList:list];
                    [UIView transitionWithView:self
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^ { [self setNeedsDisplay]; }
                                    completion:nil];
                }
                    
                    break;
                case 90:{
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.superview makeToast:str duration:1.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.superview makeToast:str duration:1.0 position:@"center"];
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        //        if (!isCancel) {
        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        [self.superview makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        //        }
        //        isCancel = NO;
        
    }];
//    hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow]
    hud =
    [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    
    [request startAsynchronous];
}

@end
