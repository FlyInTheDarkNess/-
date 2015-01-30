

#import "CalendarViewController.h"
#import "UIViewController+ADFlipTransition.h"
#import "IuiueOrderOffViewController.h"


@interface CalendarViewController ()<UIScrollViewDelegate>
{
    CalendarView *_sampleView;
    MBProgressHUD *hud;
    UIScrollView *MyScrollView;
    IuiueOrder *MyOrder;//
    NSString *dateStr;//
}

@end

@implementation CalendarViewController
@synthesize OrderList,ThisDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right"] style:UIBarButtonItemStyleBordered target:self action:@selector(swipRight)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStyleBordered target:self action:@selector(swipLeft)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
   
    _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0,0, 300, self.view.bounds.size.height - 80)];
    _sampleView.delegate = self;
    _sampleView.Orderlist = self.OrderList;
    _sampleView.roomid = self.roomid;
    _sampleView.calendarDate = self.ThisDate;
    NSLog(@"%@",_sampleView.calendarDate);
    [_sampleView setBackgroundColor:[UIColor whiteColor]];
    
     MyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
    MyScrollView.delegate = self;
    [self.view addSubview:MyScrollView];
    [MyScrollView setContentSize:CGSizeMake(640, 300)];
    [MyScrollView addSubview:_sampleView];
    MyScrollView.scrollEnabled = NO;
    MyScrollView.bounces = NO;
    MyScrollView.pagingEnabled = YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}
-(void)tappedOnDate:(NSDate *)selectedDate button:(NewButton *)button
{
    [MyScrollView removeAllSubviews];
    [MyScrollView addSubview:_sampleView];
    NSLog(@"tappedOnDate %@(GMT)",selectedDate);
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    dateStr = [[format stringFromDate:selectedDate] uppercaseString];
    self.navigationItem.title = dateStr;
    
    //点击日历一天的操作
    if (!button.OrderId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MyOrder = nil;
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:nil Tag:0];
        });
    }else{
        for (NSDictionary *dic in OrderList) {
            NSString *TheOrderId = [NSString stringWithFormat:@"%@",dic[@"orderid"]];
            if ([TheOrderId isEqualToString:button.OrderId]) {
                NSArray *arr = dic[@"roomlist"];
                MyOrder = [[IuiueOrder alloc]initWithUserName:dic[@"name"] OrderId:dic[@"orderid"] UserMobile:dic[@"tel"] NumberOfPeople:dic[@"shenfen"] PersonCount:dic[@"rennum"] InType:dic[@"source"] OrderArr:arr AllForpaid:dic[@"allprice"] paidRent:dic[@"tprice"] paidType:dic[@"payment"] Remarks:dic[@"remark"] otherMoney:nil YJrent:dic[@"prepay"] YJrentType:dic[@"prepayment"] OrderColor:dic[@"color"]];
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
                MyOrder.status = status;
                MyOrder.numberOfDay = dic[@"daymax"];
                //                    [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder];
                break;
            }
        }
        
    }

    //    [self dismissFlipWithCompletion:nil];;
    [MyScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    MyScrollView.scrollEnabled = YES;
//    self.navigationController.navigationBar.hidden = YES;
    //订单来源
    /* navigationItem设置
    UIBarButtonItem *source =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:nil action:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"房东姓名" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *Moblie = [[UIBarButtonItem alloc]initWithTitle:@"18733107902" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItems = @[source,item,Moblie];
    */
    if (MyOrder) {
        if (MyOrder.OrderArr.count >0) {
            for (NSDictionary *dic in MyOrder.OrderArr) {
                 if ([self.roomid isEqualToString:dic[@"roomid"]]) {
                    UIFont *font = [UIFont systemFontOfSize:12];
                    UILabel *UserNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(330, 30, 30, 30)];
                    UserNameLabel.text = [NSString stringWithFormat:@"👤 %@",MyOrder.UserName];
                     UserNameLabel.font = font;
                     [UserNameLabel sizeToFit];
                     
                     UILabel *MoblieLabel = [[UILabel alloc]initWithFrame:CGRectMake(330, UserNameLabel.bottom + 15, 30, 30)];
                     MoblieLabel.text = [NSString stringWithFormat:@"📱 %@",MyOrder.UserMobile];
                     MoblieLabel.font = font;
                     [MoblieLabel sizeToFit];

                     
                    UILabel *RoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(330, MoblieLabel.bottom + 15, 30, 30)];
                    RoomLabel.text = [NSString stringWithFormat:@"🏡 %@",dic[@"roomtitle"]];
                    RoomLabel.font = font;
                    [RoomLabel sizeToFit];
                                        NSString *statusStr = [NSString stringWithFormat:@"%@",dic[@"status"]];
                    if ([statusStr isEqualToString:@"0"]) {
                        statusStr = @"待入住";
                    }
                    else if([statusStr isEqualToString:@"1"]){
                        statusStr = @"已入住";
                    }else if([statusStr isEqualToString:@"2"]){
                        statusStr = @"已退房";
                    }else if([statusStr isEqualToString:@"3"]){
                        statusStr = @"待退房";
                    }else if([statusStr isEqualToString:@"4"]){
                        statusStr = @"已过期";
                    }
                     self.navigationItem.title = statusStr;
                    UILabel *NightLabel = [[UILabel alloc]initWithFrame:CGRectMake(330, RoomLabel.bottom + 15, 30, 30)];
                    NightLabel.text = [NSString stringWithFormat:@"🌛 共%@晚",dic[@"daynum"]];
                    [NightLabel sizeToFit];
                    
                    UIButton *XuzuBtn = [[UIButton alloc]initWithFrame:CGRectMake(NightLabel.right, NightLabel.top-3, 50, NightLabel.height)];
                    [XuzuBtn setTitle:@"续租" forState:UIControlStateNormal];
                    [XuzuBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
                    XuzuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    XuzuBtn.backgroundColor = COLOR__BLUE;
                    XuzuBtn.layer.cornerRadius = 5.0;
                    
                        if ([statusStr isEqualToString:@"已退房"]||[statusStr isEqualToString:@"待退房"]||[statusStr isEqualToString:@"已过期"]) {
                            XuzuBtn.hidden = YES;
                        }else if([dic[@"daynum"] integerValue]>=30){
                            XuzuBtn.hidden = YES;
                        }
                    
                    NightLabel.font = font;
                    [NightLabel sizeToFit];
                     UILabel *CanlendarLabel = [[UILabel alloc]initWithFrame:CGRectMake(330, NightLabel.bottom + 15, 200, 30)];
                     CanlendarLabel.text = [NSString stringWithFormat:@"📅  %@ 入住\n\n      %@ 退房",dic[@"statime"],dic[@"endtime"]];
                     CanlendarLabel.font = font;
                     CanlendarLabel.numberOfLines = 3;
                     [CanlendarLabel sizeToFit];

                    [MyScrollView addSubviews:@[UserNameLabel,MoblieLabel,RoomLabel,CanlendarLabel,NightLabel,XuzuBtn]];

                }
            }
            UILabel *PriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(470, 50, 135, 20)];
            PriceLabel.text = [NSString stringWithFormat:@"￥%@",MyOrder.AllForpaid];
            PriceLabel.textAlignment = NSTextAlignmentRight;
            PriceLabel.font = [UIFont systemFontOfSize:20];
            PriceLabel.textColor = COLOR__BLUE;
//            [PriceLabel sizeToFit];
            
            UILabel *PrepayLabel = [[UILabel alloc]initWithFrame:CGRectMake(420, PriceLabel.bottom + 10, 180, 20)];
            PrepayLabel.text = [NSString stringWithFormat:@"已付房费：￥%@",MyOrder.paidRent];
            PrepayLabel.textAlignment = NSTextAlignmentRight;
            PrepayLabel.font = [UIFont systemFontOfSize:10];
            PrepayLabel.textColor = [UIColor grayColor];
//            [PrepayLabel sizeToFit];
            NSString *statusStr = [NSString stringWithFormat:@"%@",MyOrder.OrderArr[0][@"status"]];
            if([statusStr isEqualToString:@"2"]||[statusStr isEqualToString:@"4"]){
                PriceLabel.text = [NSString stringWithFormat:@"￥%@",MyOrder.paidRent];
                PrepayLabel.hidden = YES;
            }
            
            UIButton * deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
            [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton * editBtn = [[UIButton alloc]initWithFrame:CGRectMake(deleteBtn.left + 100, 10, 80, 40)];
            [editBtn setTitle:@"编辑订单" forState:UIControlStateNormal];
            [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *ManageBtn = [[UIButton alloc]initWithFrame:CGRectMake(editBtn.left + 100, 10, 80, 40)];
            ManageBtn.layer.cornerRadius = 10.0f;
            [ManageBtn setBackgroundColor:COLOR_SEVEN];
            if ([MyOrder.status isEqualToString:@"0"]) {
                [ManageBtn setTitle:@"办理入住" forState:UIControlStateNormal];
            }else if([MyOrder.status isEqualToString:@"1"]){
                [ManageBtn setTitle:@"办理退房" forState:UIControlStateNormal];
            }
            else{
                ManageBtn.hidden = YES;
            }
            [ManageBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(320, 240, 320, 60)];
            view.backgroundColor = COLOR__BLUE;
            [view addSubviews:@[deleteBtn,editBtn,ManageBtn]];
            [deleteBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            [editBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            [ManageBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            //    UILabel *NightLabel = [[UILabel alloc]initWithFrame:CGRectMake(340, 100, 30, 30)];
            //    NightLabel.text = @"🌛 共1晚";🔀
            [MyScrollView addSubviews:@[PriceLabel,PrepayLabel,view]];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;

        }
        else{
            NSLog(@"订单数据错误，有订单，但是订单中没有订房间");
        }
    }
    else{
        NSLog(@"没有订单");
        [self dismissFlipWithCompletion:nil];

    }
}

-(IBAction)pressBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
     [self dismissFlipWithCompletion:nil];
    if ([btn.titleLabel.text isEqualToString:@"删除订单"]) {
//        [[UIApplication sharedApplication].keyWindow makeToast:@"点击了删除订单键"];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder Tag:1];
        });
    }
    else if([btn.titleLabel.text isEqualToString:@"编辑订单"]){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"点击了编辑订单键"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder Tag:2];
        });
    }
    else if([btn.titleLabel.text isEqualToString:@"办理入住"]){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"点击了入住键"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder Tag:3];
        });
    }
    else if([btn.titleLabel.text isEqualToString:@"办理退房"]){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"点击了退房键"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder Tag:4];
        });
    }
    else if([btn.titleLabel.text isEqualToString:@"续租"]){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"点击了续租键"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.ChangeDelegate saveRoomId:self.roomid StartDate:dateStr Order:MyOrder Tag:5];
        });
    }
}

-(void)swipOnDate:(NSString *)MonthYear{
    self.navigationItem.title = MonthYear;
}

-(void)swipLeft{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]init];
    
    [_sampleView swiperight:swip];
}


-(NSDate *)DateinitWithYear:(NSInteger)Year Month:(NSInteger)Month Day:(NSInteger)Day{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    [calendar setFirstWeekday:1];
    components.day = Day;
    components.month = Month;
    components.year = Year;
    NSDate *clickedDate = [calendar dateFromComponents:components];
    return clickedDate;
}


-(void)swipRight{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]init];
    
    [_sampleView swipeleft:swip];
    
    
}

-(void)GetOrderList:(NSArray *)List{
    self.OrderList = List;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0 ) {
        scrollView.scrollEnabled = NO;
        [_sampleView Refresh];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right"] style:UIBarButtonItemStyleBordered target:self action:@selector(swipRight)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStyleBordered target:self action:@selector(swipLeft)];
    }
}

@end
