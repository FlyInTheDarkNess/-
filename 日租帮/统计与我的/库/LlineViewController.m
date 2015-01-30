//
//  LlineViewController.m
//  XXX
//
//  Created by macmini on 14-9-5.
//  Copyright (c) 2014年 macmini. All rights reserved.
//

#import "LlineViewController.h"
#import "PNLineChartView.h"
#import "HPieChartView.h"
#import "PNPlot.h"
@interface LlineViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITableView *tableview;
    HPieChartView * pieview;//折线图
    
    NSArray *info;//解析json的数组 折线图的数组
    NSArray *cake_info;//解析得到圆形图的数组
    NSString *type;
    
    NSDictionary *dic_json;//解析得到的字典
    
    NSMutableArray *array_x;//xzhou
    NSMutableArray *array_y;//y zhou
    NSInteger max_number; //zui  da  zhi
    
    NSArray *picker_array;//pickerview 使用
    UIView *picker_view;//选择时间移动出来的view
    UIPickerView *pickerview;//选择器  选择器
    
    NSString *title_section;//第一个section的title根据选取的时间获得
  
    MBProgressHUD *hud;///透明指示层  透明指示层

}

@end

@implementation LlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"统计";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        CGRect frame = [UIScreen mainScreen].bounds;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Canlen"] style:UIBarButtonItemStylePlain target:self action:@selector(chose)];
    self.navigationItem.rightBarButtonItem = right;
   
    
    picker_array = [NSArray arrayWithObjects:@"本周(以本周一到周日)",@"本月(本月一号到今天)",@"上周(上周一到周日)",@"上月(上月初到上月底)", nil];

    //tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    //tableview = [[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 44)];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 108) style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(chose)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView *button_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 40)];
    button_view.backgroundColor = COLOR__BLUE;
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    UIButton *sure = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH - 70, 0, 70, 40)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [button_view addSubview:cancle];
    [button_view addSubview:sure];
    [cancle addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [sure addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pickerview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, MY_WIDTH, 216)];
    picker_view = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height + 256, MY_WIDTH, 256)];
    [picker_view addSubview:pickerview];
    [picker_view addSubview:button_view];
    pickerview.delegate = self;
    pickerview.dataSource = self;
    picker_view.backgroundColor = [UIColor whiteColor];
    [pickerview selectRow:1 inComponent:0 animated:YES];
    [self.view addSubview:picker_view];
    
    // Do any additional setup after loading the view.
}
-(void)chose{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
     CGRect frame = [UIScreen mainScreen].bounds;
     [self.view MoveView:picker_view To:CGRectMake(0, frame.size.height - 320, frame.size.width, 320) During:1];
}
-(IBAction)done:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CGRect frame = [UIScreen mainScreen].bounds;
    if([btn.titleLabel.text isEqualToString:@"取消"]){
        [self.view MoveView:picker_view To:CGRectMake(0, frame.size.height + 256, frame.size.width, 256) During:1];
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }else{
        NSInteger row = [pickerview selectedRowInComponent:0];
        NSString *selected = [picker_array objectAtIndex:row];
        if(row == 0){
            type = @"1";
            [self getdata];
            title_section = [NSString stringWithFormat:@"  %@运营总额",selected];
        }
        if(row == 1){
            type = @"2";
            [self getdata];
            title_section = [NSString stringWithFormat:@"  %@运营总额",selected];
        }
        if(row == 2){
            type = @"3";
            [self getdata];
            title_section = [NSString stringWithFormat:@"  %@运营总额",selected];
        }
        if(row == 3){
            type = @"4";
            [self getdata];
            title_section = [NSString stringWithFormat:@"  %@运营总额",selected];
        }
        [self.view MoveView:picker_view To:CGRectMake(0, frame.size.height + 256, frame.size.width, 256) During:1];
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self getdata];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    type = @"2";
     title_section = @"  本月(以本月一号到今天)运营总额";
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [picker_array count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [picker_array objectAtIndex:row];
}

-(void)getdata{
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/datacount"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:type forKey:@"type"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *err;
        dic_json = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        info = dic_json[@"linelist"];//折线图的数组
        cake_info = dic_json[@"cakelist"]; //圆形图数组；
        max_number = [dic_json[@"maxprice"]integerValue]; //Y轴的最大值
        
        array_x = [NSMutableArray array];
        for (NSDictionary *dic in info) {
            NSString *xx = dic[@"time"];
            [array_x addObject:xx];
        }
        array_y = [NSMutableArray array];
        for (NSDictionary *dic in info) {
            NSString *yy = dic[@"tprice"];
            [array_y addObject:yy];
        }
        [tableview reloadData];
        
    }];
     [request setFailedBlock:^{
         [self.view makeToast:@"网络连接异常......" duration:1 position:@"center"];
     }];
    [request startAsynchronous];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    if(section == 1){
        return 1;
    }
    if(section == 2){
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    static NSString *table = @"table";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:table];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(section == 0){
       // NSDictionary *dic = info[indexPath.row];
        PNLineChartView *lineChartView = [[PNLineChartView alloc]initWithFrame:CGRectMake(0, 5, 320, 240)];
        lineChartView.backgroundColor = [UIColor clearColor];
        [cell addSubview:lineChartView];
         //NSArray* plottingDataValues1 =@[@22, @33, @12, @23,@43, @32,@53, @33, @54,@55, @43]; //Y轴要显示的数据  即是Y点
        lineChartView.max = max_number; //Y轴的最大值
        lineChartView.min = 0;  //Y轴的最小值
        lineChartView.interval = (lineChartView.max-lineChartView.min)/5;//这是一个数值 用来计算Y轴的点 

       NSMutableArray *yAxisValues = [@[] mutableCopy];
        for (int i=0; i<6; i++) {
            NSString* str = [NSString stringWithFormat:@"%.2f", lineChartView.min+lineChartView.interval*i];
            [yAxisValues addObject:str];
        
        }
        

        lineChartView.xAxisValues = array_x;//@[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11"]; //X轴要显示的数据 即是X点
        lineChartView.yAxisValues = yAxisValues;
        lineChartView.axisLeftLineWidth = 39;//y轴数值 空间的大小  y轴数值 空间的大小
        
        PNPlot *plot1 = [[PNPlot alloc] init];
        BOOL IsAll = YES;
        for (NSString *str in array_y) {
            if ([str integerValue]!=0) {
                IsAll = NO;
                plot1.plottingValues = array_y;
                break;
            }else{
                plot1.plottingValues = nil;
            }
            
        }
        plot1.lineColor =[UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
        plot1.lineWidth = 2.0;
        [lineChartView addPlot:plot1];
    }
    if(section == 1){
        UILabel *line_lable = [[UILabel alloc]initWithFrame:CGRectMake(155, 5, 0.7, 80)];
        [cell addSubview:line_lable];
        line_lable.backgroundColor = [UIColor blackColor];
        line_lable.alpha = 0.5;
        
        UILabel *lable =[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 70, 30)];
        [cell addSubview:lable];
        lable.text = @"营业收入:";
        lable.alpha = 0.5;
        [lable setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        UILabel *lable_sumprice = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, 90, 30)];
        [cell addSubview:lable_sumprice];
        [lable_sumprice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        lable_sumprice.textColor = [UIColor colorWithRed:34.0/255 green:118.0/255 blue:238.0/255 alpha:1];
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(170, 0, 70, 30)];
        [cell addSubview:lable1];
        lable1.text = @"入住人数:";
        lable1.alpha = 0.5;
        [lable1 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        UILabel *lable_sumpeopel = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 70, 30)];
        [cell addSubview:lable_sumpeopel];
        [lable_sumpeopel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        lable_sumpeopel.textColor = [UIColor colorWithRed:34.0/255 green:118.0/255 blue:238.0/255 alpha:1];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(170, 30, 70, 30)];
        [cell addSubview:lable2];
        lable2.text = @"实住间数:";
        lable2.alpha = 0.5;
        [lable2 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        UILabel *lable_jian = [[UILabel alloc]initWithFrame:CGRectMake(240, 30, 70, 30)];
        [cell addSubview:lable_jian];
        [lable_jian setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        lable_jian.textColor = [UIColor colorWithRed:34.0/255 green:118.0/255 blue:238.0/255 alpha:1];
        
        UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 60, 70, 30)];
        [cell addSubview:lable3];
        lable3.text = @"人住率:";
        lable3.alpha = 0.5;
        [lable3 setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        UILabel *lable_people = [[UILabel alloc]initWithFrame:CGRectMake(240, 60, 70, 30)];
        [cell addSubview:lable_people];
        [lable_people setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        lable_people.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
        
        if(dic_json == nil){
            lable_sumprice.text = @"0";
            lable_sumpeopel.text = @"0人";
            lable_jian.text = @"0间";
            lable_people.text = @"0%";

        }else{
            lable_sumprice.text = [NSString stringWithFormat:@"￥%@",dic_json[@"sumprice"]];
            lable_sumpeopel.text =[NSString stringWithFormat:@"%@人",dic_json[@"sumren"]];
            lable_jian.text =[NSString stringWithFormat:@"%@间",dic_json[@"sumroom"]];
            lable_people.text =[NSString stringWithFormat:@"%@",dic_json[@"rzl"]];
        }

        
        
    }
    if(section == 2){
        
      //  NSMutableArray * floatarray = [[NSMutableArray alloc] initWithCapacity:1];

//        NSMutableArray *floatarray = [NSMutableArray array];
//        floatarray = cake_info;

        NSMutableArray *price = [NSMutableArray array];
        NSMutableArray *name = [NSMutableArray array];
        for (NSDictionary *dic in cake_info) {
            NSString *pri = [NSString stringWithFormat:@"%@",dic[@"percent"]];
            NSString *nam = [NSString stringWithFormat:@"%@",dic[@"source"]];
            [price addObject:pri];
            [name addObject:nam];
        }
        int price_all = [dic_json[@"iostprice"]integerValue];
        if(cake_info.count == 0 || price_all == 0){
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(35, 50, 250, 100)];
            image.image = [UIImage imageNamed:@"250x100"];
            [cell addSubview:image];
        }else{
           
            pieview = [[HPieChartView alloc] initWithFrame:CGRectMake(0.0, 15.0, 200.0, 200.0)  withNum:[cake_info count] withArray:cake_info];
            pieview.center = CGPointMake(160, 120);
            [cell addSubview:pieview];
            
            
            
//            for(int i = 0;i < cake_info.count; i ++){
//                UILabel *textfiled = [[UILabel alloc]initWithFrame:CGRectMake(12 + 50*i, 280, 45, 30)];
//                textfiled.text = [NSString stringWithFormat:@"●%@",name[i]];
//                textfiled.layer.masksToBounds = YES;
////                textfiled.layer.borderWidth = 2;
//                textfiled.layer.cornerRadius = 4;
//                [textfiled setFont:[UIFont fontWithName:@"Helvetica" size:10]];
//                textfiled.textAlignment = UITextAlignmentCenter;
//                if(i == 0){
//                    textfiled.textColor = [UIColor colorWithRed:215.0/255 green:38.0/255 blue:50.0/255 alpha:1];
//                }
//                if(i == 1){
//                    textfiled.textColor = [UIColor colorWithRed:253.0/255 green:148.0/255 blue:9.0/255 alpha:1];
//                }
//                if(i == 2){
//                    textfiled.textColor = [UIColor colorWithRed:47.0/255 green:199.0/255 blue:38.0/255 alpha:1];
//                }
//                if(i == 3){
//                    textfiled.textColor = [UIColor colorWithRed:56.0/255 green:90.0/255 blue:255.0/255 alpha:1];
//                }
//                if(i == 4){
//                    textfiled.textColor = [UIColor colorWithRed:25.0/255 green:197.0/255 blue:199.0/255 alpha:1];
//                }
//                if (i == 5) {
//                    textfiled.textColor = [UIColor colorWithRed:133.0/255 green:17.0/255 blue:192.0/255 alpha:1];
//                }
//                 [cell addSubview:textfiled];
//            }
//
            NSInteger hang = cake_info.count/3;
            if (cake_info.count%3>0) {
                hang = hang + 1;
            }
            for (int i = 0; i< hang; i++) {
                for (int j = 0; j<3; j++) {
                    if (cake_info.count > i*3+j) {
                        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/3 * j+15, 280 + i * 50, 20, 20)];
                        label1.layer.masksToBounds = YES;
                        label1.layer.cornerRadius = 10;
                        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.right + 10, label1.top, 57, 20)];
                        label1.backgroundColor = COLOR__ARRAY[i*3+j];
                        label2.text = name[i*3+j];
                        [label2 setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                        //label2.backgroundColor = COLOR__ARRAY[i*3+j];
                        [cell addSubview:label1];
                        [cell addSubviews:@[label1,label2]];
                    }
                    
                }
            }

        }
       
        
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int price_all = [dic_json[@"iostprice"]integerValue];
    if(indexPath.section == 0 ){
        return 250;
    }else if (indexPath.section == 1){
        return 90;
    }else{
        if(cake_info.count == 0|| price_all == 0){
            return 200;
        }else{
        return 370;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = [UIScreen mainScreen].bounds;
   
    if(section == 0){
         UIView *view_title_one = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        UILabel *lable_one = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [view_title_one addSubview:lable_one];
        lable_one.text = title_section;
    [lable_one setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        lable_one.alpha = 0.6;
        return view_title_one;
    }
    if(section == 1){
        UIView *view_title_two = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        UILabel *lable_two = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [view_title_two addSubview:lable_two];
        lable_two.text = @"  各项数据显示";
        [lable_two setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        lable_two.alpha = 0.6;
        return view_title_two;
    }
    if(section == 2){
         UIView *view_title_three = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        UILabel *lable_three = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [view_title_three addSubview:lable_three];
        lable_three.text = @"  订单来源概览";
        [lable_three setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        lable_three.alpha = 0.6;
        return view_title_three;
    }
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
