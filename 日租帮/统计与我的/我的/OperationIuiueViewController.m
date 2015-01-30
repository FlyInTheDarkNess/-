//
//  OperationIuiueViewController.m
//  日租帮
//
//  Created by macmini on 14-9-11.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "OperationIuiueViewController.h"

@interface OperationIuiueViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>{
    UITableView *tableview;
    
    NSArray *info;
    NSMutableArray *mutablearray;
    MBProgressHUD *hud;
    
    
    UIDatePicker *datePicker;
    UIView *datepicker_view;//datepicker 所在页面
    
    
    NSDate *date;//获取系统当前的时间
    UITextField *textfile;//承载datepicker所选中的时间
    NSString *selfday; //截取到得系统当前的时间
    
    //刷新调用
    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    
    UILabel *lable;
}

@end

@implementation OperationIuiueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"操作记录";
        
       
    }
    return self;
}
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = tableview;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = tableview;
}
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
    [_header free];
    [_footer free];
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
        page = 1;
        [self getdata];
        
    } else {
        
        [self getdata];
    }
}

- (void)viewDidLoad
{
    

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    date = [NSDate date];
    NSLog(@"%@",date);
    NSString *textfiled = [NSString stringWithFormat:@"%@",date];
    selfday = [textfiled substringWithRange:NSMakeRange(0,10)];
    //tableview 的创建
    CGRect frame = [UIScreen mainScreen].bounds;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - 108)];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    UIView *viewback = [[UIView alloc]initWithFrame:frame];
    viewback.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview.backgroundView =viewback;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.separatorStyle = UITableViewCellAccessoryNone;
    
    
    //textfile的创建 
    textfile = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    textfile.text = [NSString stringWithFormat:@"%@",selfday];
    textfile.layer.borderWidth = 2;
    textfile.layer.borderColor = [UIColor whiteColor].CGColor;
    textfile.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 40)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, 20, 40)];
    [view addSubview:image];
    image.image = [UIImage imageNamed:@"10x40"];
    textfile.leftView = view;
    textfile.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *right_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48, 40)];
    textfile.rightView = right_view;
    textfile.rightViewMode = UITextFieldViewModeAlways;
    UIImageView *image_right = [[UIImageView alloc]initWithFrame:CGRectMake(16.5, 12.5, 15, 15)];
    image_right.image = [UIImage imageNamed:@"15x15"];
    [right_view addSubview:image_right];
    [self.view addSubview:textfile];
   
    UIButton *chose_time = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    [chose_time setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:chose_time];
    [chose_time addTarget:self action:@selector(geton) forControlEvents:UIControlEventTouchUpInside];
    chose_time.backgroundColor = [UIColor clearColor];
    
    
    
    datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,40,0.0,0.0)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    datepicker_view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height +310, frame.size.width, 310)];
    datepicker_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datepicker_view];
    [datepicker_view addSubview:datePicker];
    
    UIView *button_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    [datepicker_view addSubview:button_view];
    button_view.backgroundColor = [UIColor brownColor];// 承载button的view
    
    UIButton *cancle_button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];// datapicker 下去的button
    [cancle_button setTitle:@"取消" forState:UIControlStateNormal];
    [button_view addSubview:cancle_button];
    
    UIButton *sure_button = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 70, 0, 60, 40)];//datapicker 下去的button并且选中时间
    [sure_button setTitle:@"确定" forState:UIControlStateNormal];
    
    [button_view addSubview:sure_button];
    [sure_button addTarget:self action:@selector(sure_button_date) forControlEvents:UIControlEventTouchUpInside];
    [cancle_button addTarget:self action:@selector(cancle_button_date) forControlEvents:UIControlEventTouchUpInside];
    [sure_button addTarget:self action:@selector(sure_button_date) forControlEvents:UIControlEventTouchUpInside];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setFreshView];
    // Do any additional setup after loading the view.
}
-(void)cancle_button_date{
    CGRect frame = [UIScreen mainScreen].bounds;
    [self.view MoveView:datepicker_view To:CGRectMake(0, frame.size.height + 310, frame.size.width, 310) During:0.8];
}

-(void)geton{
    CGRect frame = [UIScreen mainScreen].bounds;
    [self.view MoveView:datepicker_view To:CGRectMake(0, frame.size.height - 310, frame.size.width, 310) During:0.8];
}
//pickerview  加载时间   选择时间  选择时间
-(void)sure_button_date{ //pickerview  加载时间   选择时间  选择时间
    NSLog(@"%@",datePicker.date);
    CGRect frame = [UIScreen mainScreen].bounds;
    NSString *datepicker_date = [NSString stringWithFormat:@"%@",datePicker.date];
    NSString *yearpickerdate = [datepicker_date substringWithRange:NSMakeRange(0, 10)];
    textfile.text = [NSString stringWithFormat:@"%@",yearpickerdate];
    [self.view MoveView:datepicker_view To:CGRectMake(0, frame.size.height + 250, frame.size.width, 250) During:0.8];
    page = 1;
    [self getdata];
}
-(void)getdata{
    
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/Api/userlog"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    NSString *pageone = [NSString stringWithFormat:@"%d",page];
    [request addPostValue:pageone forKey:@"page"];
    [request addPostValue:textfile.text forKey:@"statime"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        info = dic[@"info_list"];
        [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
        if([dic[@"all_num"]integerValue] == 0){
            self.navigationItem.title = @"操作记录(共0项)";
        }else{
            self.navigationItem.title = [NSString stringWithFormat:@"操作记录(共%@项)",dic[@"all_num"]];
        }
       
        if(page == 1){
             mutablearray = [NSMutableArray array];
        }
        for (NSDictionary *dic_info in info) {
            [mutablearray addObject:dic_info];
        }
        if(mutablearray.count == 0){
            CATransition *animation = [CATransition animation]; animation.duration = 0.5f; animation.timingFunction =UIViewAnimationCurveEaseInOut; animation.fillMode =kCAFillModeForwards; //基本型
            animation.type =kCATransitionPush; //私有API，字符串型
            animation.type = @"rippleEffect";
            [self.view.layer addAnimation:animation forKey:@"animation"];
            
            tableview.hidden = YES;
            CGRect frame = [UIScreen mainScreen].bounds;
            lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 40)];
            [self.view addSubview:lable];
            lable.text = @"您选择的日期范围内没有操作记录";
            [lable setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.backgroundColor = [UIColor whiteColor];
            return;
        }else{
            [lable removeFromSuperview];
            tableview.hidden = NO;
        }
        [tableview reloadData];
        page ++;
        
    }];
    [request setFailedBlock:^{
        [hud hide:YES];
        [self.view makeToast:@"网络连接异常..." duration:1 position:@"center"];
    }];
    [request startAsynchronous];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    //return 2;
//    
//    
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_footer endRefreshing];
    [_header endRefreshing];
        return mutablearray.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *table = @"table";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:table];
    //cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        NSDictionary *dic = mutablearray[indexPath.row];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 260, 30)];
        lab.text = dic[@"utel"];
        [cell addSubview:lab];
        [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    lab.alpha = 0.5;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(45, 42, 260, 100)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.1;
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        

        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 240, 10)];
        [view addSubview:lable1];
        lable1.text = dic[@"content"];
        [lable1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        lable1.numberOfLines = 4;
        [lable1 sizeToFit];
    lable1.alpha = 0.5;
        
        
        
        
      //        [lable1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 260, 10)];
        lable2.text = @"........................................................................";
        //lable2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:lable2];
        [lable2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    lable2.alpha = 0.5;
    
        UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 70, 20)];
        lable3.text = dic[@"uname"];
        [view addSubview:lable3];
        [lable3 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    lable3.alpha = 0.5;
        
        UILabel *lable4 = [[UILabel alloc]initWithFrame:CGRectMake(170, 4, 80, 20)];
        NSString *date = dic[@"regtime"];
        NSString *jie_date = [date substringWithRange:NSMakeRange(5, 11)];
        lable4.text = jie_date;
        [view addSubview:lable4];
        [lable4 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    lable4.alpha = 0.5;
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, 20, 145)];
        image.image = [UIImage imageNamed:@"10x"];
        [cell addSubview:image];


    


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    NSDictionary *dicload = info[indexPath.row];
//    NSString *contentText = [NSString stringWithFormat:@"%@",dicload[@"pingyu"]];
//    CGSize contentSize = [contentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:CGSizeMake(250, MAXFLOAT)];
//    return contentSize.height;
//    UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
//    NSDictionary *dicload = info[indexPath.row];
//    NSString *contentText = [NSString stringWithFormat:@"%@",dicload[@"pingyu"]];
//    CGSize contentSize = [contentText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13] constrainedToSize:CGSizeMake(250, MAXFLOAT)];
//    return  contentSize.height+50;

    return 160;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    page = 1;
    [self getdata];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
-(void)viewWillDisappear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
