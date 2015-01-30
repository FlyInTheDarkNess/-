 //
//  IuiueMainViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-22.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//
//NSString *const MJCollectionViewCellIdentifier = @"Cell";
#define MJCollectionViewCellIdentifier (@"cell")
#define MJRandomColor [UIColor grayColor]

#import "IuiueMainViewController.h"
#import "CalendarViewController.h"
#import "UIViewController+ADFlipTransition.h"
#import "IuiueOrderDetailViewController.h"
#import "IuiueOrderOffViewController.h"
#import "IuiueRoomDetailViewController.h"

@interface IuiueMainViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *YearArr;//年份集合
    NSArray *MonthArr;//月份集合
    UIPickerView *picker;//pickerView选择
    UIView *MyView;//pickerView的上层view
    NSInteger SelectIndexSection;//显示第几列
    NSInteger SelectIndexRow;//显示第几行
    NSString *YearStr;//年
    NSString *MonthStr;//月
    NSString *DateStr;//往接口传得日期
    MBProgressHUD *hud;//透明指示层
    NSArray *RoomList;//房间列表
    NSArray *OrderList;//订单列表
    __weak ASIFormDataRequest *request;
    UIScrollView *MyScrollView;//滑动视图
    UIPageControl *MyPageControl;
    IuiueOrder *MyOrder;//当前订单
    UILabel *MonthLabel;//显示当前月份
}

@end

@implementation IuiueMainViewController
/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"主页";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Canlen"] style:UIBarButtonItemStyleBordered target:self action:@selector(showDatePicker:)];
                                                  
//       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showDatePicker:)];
    }
    return self;
}

//显示并初始化pickerView
-(IBAction)showDatePicker:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (!MyView) {
        MyView = [[UIView alloc]initWithFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
        MyView.backgroundColor = COLOR__BLUE;
        UIButton *leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [leftbtn setTitle:@"取消" forState:UIControlStateNormal];
        leftbtn.tag = btn.tag;
        [leftbtn addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
        [MyView addSubview:leftbtn];
        UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH - 60, 0, 60, 44)];
        rightbtn.tag = btn.tag;
        [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
        [MyView addSubview:rightbtn];
        picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, MY_WIDTH, 216.0f)];
        picker.tag = btn.tag;
        picker.dataSource = self;
        picker.delegate = self;
        picker.backgroundColor = [UIColor whiteColor];
        
        [MyView addSubview:picker];
        [self.view addSubview:MyView];
        [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT - 324.0f, MY_WIDTH, 260.0f) During:0.3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [picker selectRow:SelectIndexSection inComponent:0 animated:YES];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [picker selectRow:SelectIndexRow inComponent:1 animated:YES];
        });
        
    }
    else{
        
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MyView removeFromSuperview];
            [picker removeFromSuperview];
            picker = nil;
            MyView = nil;
        });
        [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260) During:0.3];
    }
}

//收起并隐藏pickerView
-(IBAction)hidePickerView:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MyView removeFromSuperview];
                        [picker removeFromSuperview];
                        picker = nil;
                        MyView = nil;
            
        });
                [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260) During:0.3];
    }
    else if([btn.titleLabel.text isEqualToString:@"确定"]){
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MyView removeFromSuperview];
            [picker removeFromSuperview];
            picker = nil;
            MyView = nil;
        });
        DateStr =[NSString stringWithFormat:@"%@-%@",YearStr,MonthStr];
        [self SendToGetCanlendarArr];

        [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260) During:0.3];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return 5*2*100;
        //        return 5;
    }
    return 12*2*100;
    //    return 12;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    switch (component) {
        case 0:
            str = [NSString stringWithFormat:@"%@年",YearArr[row%5]];
            break;
        case 1:
            str = [NSString stringWithFormat:@"%@月",MonthArr[row%12]];
            break;
        default:
            return @"数据加载错误";
            break;
    }
    
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            YearStr = [NSString stringWithFormat:@"%@",YearArr[row%5]];
            SelectIndexSection = row;
            break;
        case 1:
            MonthStr = [NSString stringWithFormat:@"%@",MonthArr[row%12]];
            SelectIndexRow = row;
            break;
        default:
            [self.view makeToast:@"日期列表有误"];
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 44)];
    MyScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    MyScrollView.delegate = self;
    MyScrollView.bounces = NO;
    MyScrollView.pagingEnabled = YES;
    [self.view addSubview:MyScrollView];
    
    YearArr = [NSMutableArray arrayWithCapacity:5];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    YearStr = [[format stringFromDate:[NSDate date]] uppercaseString];
    for (NSInteger num = [YearStr integerValue] - 2; num < [YearStr integerValue] + 3; num++) {
        NSString *str = [NSString stringWithFormat:@"%d",num];
        [YearArr addObject:str];
    }
    MonthArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    [format setDateFormat:@"MM"];
    MonthStr = [[format stringFromDate:[NSDate date]] uppercaseString];
    
    DateStr =[NSString stringWithFormat:@"%@-%@",YearStr,MonthStr];
    //    SelectIndexSection = 5*100000 + 2;
    //    SelectIndexRow = 12*100000+[MonthStr integerValue]-1;
    SelectIndexSection = 2 + 5 * 100;
    SelectIndexRow = [MonthStr integerValue]-1 + 12 *100;
    
    NSArray *dateArr = [DateStr componentsSeparatedByString:@"-"];
    NSString *MonStr = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
    MonthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 30)];
    MonthLabel.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];
    MonthLabel.text = MonStr;
    MonthLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:MonthLabel];
    
    MyPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, MY_HEIGHT - 140, MY_WIDTH, 20)];
    MyPageControl.currentPageIndicatorTintColor = COLOR__BLUE;
    MyPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:MyPageControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.translucent = YES;
    [self SendToGetCanlendarArr];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
}
#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (RoomList.count == 0) {
//        return 0;
//    }
//    switch (collectionView.tag) {
//        case 0:
//            return 4;
//            break;
//        case 1:
//            return 4;
//            break;
//        case 2:
//            return 4;
//            break;
//
//        default:
//            break;
//    }
//    NSLog(@"%d",collectionView.tag);
//    int num = RoomList.count - collectionView.tag * 4;
//    if (num > 4) {
//        return 4;
//    }
//    return num;
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
//    cell.contentView.layer.cornerRadius = 20.0f;
    if (cell.subviews.count <= 1) {
        if (RoomList.count>indexPath.row + collectionView.tag * 4) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
            NSDictionary *room = RoomList[indexPath.row + collectionView.tag * 4];
            NSString *roomTitle = [NSString stringWithFormat:@"%@",room[@"roomtitle"]];
            label.text = roomTitle;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [cell addSubview:label];
            CalendarView *_sampleView; //每个 collection
            _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0 , 30, 140, 130)];
            NSArray *dateArr = [DateStr componentsSeparatedByString:@"-"];
            NSDate *date = [self DateinitWithYear:[dateArr[0] integerValue] Month:[dateArr[1] integerValue] Day:1];
            _sampleView.Orderlist = room[@"orderlist"];
            
            
            //    _sampleView.delegate = self;
            
            [_sampleView setBackgroundColor:[UIColor whiteColor]];
            _sampleView.calendarDate = date;
            _sampleView.userInteractionEnabled = NO;//锁定不可点击
            
            [cell addSubview:_sampleView];
            //        cell.contentView.backgroundColor =self.fakeColors[indexPath.row];
            cell.contentView.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:231.0/255.0 alpha:1];
            cell.backgroundColor = [UIColor clearColor];
        }else if(indexPath.row + collectionView.tag * 4==RoomList.count){
//            cell.contentView.backgroundColor = [UIColor redColor];
            UIImageView *imV =[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 100, 100)];
            imV.image= [UIImage imageNamed:@"+"];
            [cell.contentView addSubview:imV];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    //    cell.backgroundColor = self.fakeColors[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (RoomList.count>indexPath.row + collectionView.tag * 4) {
        NSDictionary *room = RoomList[indexPath.row + collectionView.tag * 4];
    
    //翻转弹出子控制器
    
        CalendarViewController *second = [[CalendarViewController alloc]init];
        CGPoint point = collectionView.contentOffset;
        UINavigationController *sec = [[UINavigationController alloc]initWithRootViewController:second];
        self.modalTransitionStyle = UIModalPresentationCurrentContext;
        UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
        
        CGRect frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - point.y+64 + 30, cell.frame.size.width, cell.frame.size.height);
        [cell setFrame:frame];
        NSArray *dateArr = [DateStr componentsSeparatedByString:@"-"];
        NSDate *date = [self DateinitWithYear:[dateArr[0] integerValue] Month:[dateArr[1] integerValue] Day:1];

        second.OrderList = room[@"orderlist"];
        second.roomid = room[@"roomid"];
        second.ThisDate = date;
        NSLog(@"cell:%.1f:%.1f:%.1f:%.1f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        second.ChangeDelegate = self;
        [self flipToViewController:sec fromView:cell asChildWithSize:CGSizeMake(300, 350) withCompletion:nil];
        
    }else if(indexPath.row + collectionView.tag * 4==RoomList.count){
        IuiueRoomDetailViewController *room = [[IuiueRoomDetailViewController alloc]init];
        [self.navigationController pushViewController:room animated:YES];
    }
    
    //    CGPoint point = self.collectionView.contentOffset;
    //    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    //
    //    CGRect frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - point.y, cell.frame.size.width, cell.frame.size.height);
    //
    //   CalendarView *_sampleView= [[CalendarView alloc]initWithFrame:frame];
    ////    _sampleView.delegate = self;
    //    [_sampleView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //    _sampleView.calendarDate = [NSDate date];
    //
    //    [self.view addSubview:_sampleView];
    //    [self.view MoveView:_sampleView To:CGRectMake(10, 150, 300, 300) During:5];
}

-(void)saveRoomId:(NSString *)roomId StartDate:(NSString *)StartDate Order:(IuiueOrder *)Order Tag:(NSInteger)tag{
    if (Order) {
        MyOrder = Order;
        switch (tag) {
            case 3:
            case 4:
            case 5:
                //            [self SendToTurnOffOrder:MyOrder.OrderId];
            {
                IuiueOrderOffViewController *OrderOff = [[IuiueOrderOffViewController alloc]init];
                OrderOff.MyOrder = MyOrder;
                if (tag == 3) {
                    OrderOff.title = @"办理入住";
                }else if(tag == 4){
                    OrderOff.title = @"办理退房";
                }else if(tag == 5){
                    OrderOff.title = @"办理续租";
                }
                [self.navigationController pushViewController:OrderOff animated:YES];
            }
                break;
            case 2:
            {
                IuiueOrderDetailViewController *orderDetail = [[IuiueOrderDetailViewController alloc]init];
                orderDetail.Order = MyOrder;
                [self.navigationController pushViewController:orderDetail animated:YES];
            }
                break;
            case 1:
            {
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"删除该订单将丢失与其关联的所有信息，可能导致数据统计出现遗漏，是否继续删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"继续删除" otherButtonTitles:nil, nil];
                [sheet showInView:self.view];
            }
                break;
                
            default:
            {
                //            CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initWithFrame:CGRectMake(50, 300, 220, 200)];
                //            [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
                //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
                //            view.backgroundColor = [UIColor redColor];
                //            [alert setContainerView:[[UIView alloc]init]];
                ////            [alertView show];
                //            [alert show];
            }
                break;
        }

//        NSString *str = [NSString stringWithFormat:@"%@",Order];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Order.UserName message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退房",@"编辑订单",@"删除订单", nil];
//        [alert show];
    }else{
        IuiueOrderDetailViewController *OrderDetail = [[IuiueOrderDetailViewController alloc]init];
        OrderDetail.StartDate = StartDate;
        OrderDetail.RoomId = roomId;
        [self.navigationController pushViewController:OrderDetail animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self SendToDeleteOrderId:MyOrder.OrderId];
            break;
            
        default:
            [self.view makeToast:@"取消"];
            break;
    }
}

-(void)SendToGetCanlendarArr{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MAIN_CANLENDAR]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:DateStr forKey:@"statime"];
    
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
                    NSArray *dateArr = [DateStr componentsSeparatedByString:@"-"];
                    NSString *MonStr = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
                    MonthLabel.text = MonStr;
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                    [self.view makeToast:str duration:1.5 position:@"center"];
                    RoomList = resultDict[@"info_list"];
                    // UICollectionViewFlowLayout的初始化（与刷新控件无关)
                    NSInteger MyPage;
//                    if (RoomList.count == 0) {
//                        return;
//                    }
                    if ((RoomList.count + 1)%4 > 0) {
                        MyPage = (RoomList.count + 1)/4 + 1;
                    }
                    else{
                        MyPage = (RoomList.count + 1)/4;
                    }
//                    [MyScrollView setFrame:CGRectMake(0, 64, MY_WIDTH, MY_HEIGHT - 44)];
                    [MyScrollView removeAllSubviews];
                    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH * MyPage,MY_HEIGHT-100 )];
                    MyPageControl.numberOfPages = MyPage;
                    MyPageControl.userInteractionEnabled = NO;
                    int page = MyScrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
                    MyPageControl.currentPage = page;
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.itemSize = CGSizeMake(140, 155);
                    layout.sectionInset = UIEdgeInsetsMake(10, MY_WIDTH/4 - 70, 0, MY_WIDTH/4 - 70);
                    layout.minimumInteritemSpacing = 20;
                    layout.minimumLineSpacing = 15;
                    for (int num = 0;num < MyPage; num ++) {
                        UICollectionView *Collection = [[UICollectionView alloc]initWithFrame:CGRectMake(MY_WIDTH * num, 30, MY_WIDTH, MY_HEIGHT - 44 - 30 - 64) collectionViewLayout:layout];
                        Collection.bounces = NO;
                        Collection.scrollEnabled = NO;
                        Collection.delegate = self;
                        Collection.dataSource = self;
                        
                        Collection.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        Collection.alwaysBounceVertical = YES;
                        [Collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
                        Collection.tag = num;
                        [MyScrollView addSubview:Collection];
                    }
                    
                }
                    break;
                case 90:{
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.0 position:@"center"];
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        [hud hide:YES];
        NSLog(@"%@",[request.error localizedDescription]);
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    
    MyPageControl.currentPage = page;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
//            [self SendToTurnOffOrder:MyOrder.OrderId];
        {
            IuiueOrderOffViewController *OrderOff = [[IuiueOrderOffViewController alloc]init];
            OrderOff.MyOrder = MyOrder;
            [self.navigationController pushViewController:OrderOff animated:YES];
        }
            break;
        case 2:
        {
            IuiueOrderDetailViewController *orderDetail = [[IuiueOrderDetailViewController alloc]init];
            orderDetail.Order = MyOrder;
            [self.navigationController pushViewController:orderDetail animated:YES];
        }
            break;
        case 3:
            [self SendToDeleteOrderId:MyOrder.OrderId];
            break;
            
        default:
        {
//            CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc]initWithFrame:CGRectMake(50, 300, 220, 200)];
//            [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//            view.backgroundColor = [UIColor redColor];
//            [alert setContainerView:[[UIView alloc]init]];
////            [alertView show];
//            [alert show];
        }
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)SendToDeleteOrderId:(NSString *)OrderId{
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ORDER]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:OrderId forKey:@"orderid"];
    [request addPostValue:@"2" forKey:@"type"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
                    //                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    //                    [self.view makeToast:str duration:0.5 position:@"center"];
                    //                    for (int num = 0; num < MyArr.count; num++) {
                    //                        IuiueOrder *order = (IuiueOrder *)MyArr[num];
                    //                        if ([order.OrderId isEqualToString:OrderId]) {
                    //                            [MyArr removeObjectAtIndex:num];
                    //                        }
                    //                    }
                    ////                    for (IuiueOrder *order  in  MyArr) {
                    ////                        if ([order.OrderId isEqualToString:OrderId]) {
                    ////                            [MyArr removeObject:order];
                    ////                        }
                    ////                    }
                    //                    [MyTableView reloadData];
                    //                    if (self.editing) {
                    //                        if (MyArr.count > 0) {
                    //                            [self setEditing:NO animated:YES];
                    //                        }
                    //                    }else{
                    //                        if (MyArr.count > 0) {
                    //                            [self setEditing:NO animated:YES];
                    //                        }else{
                    //                            [self setEditing:YES animated:YES];
                    //                        }
                    //                    }
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:0.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self SendToGetCanlendarArr];
                    });
                    
                }
                    
                    break;
                case 90:{
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.0 position:@"center"];
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
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        //        }
        //        isCancel = NO;
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    
    [request startAsynchronous];
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [request cancel];
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

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    // 处理推送消息
//    
//    NSLog(@"userinfo:%@",userInfo);
//    
//    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//}
//
//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    NSLog(@"userinfo:%@",notification);
//}



@end
