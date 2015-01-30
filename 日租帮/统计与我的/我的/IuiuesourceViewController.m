//
//  IuiuesourceViewController.m
//  日租帮
//
//  Created by macmini on 14-9-24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiuesourceViewController.h"
#import "DropDownListView.h"
@interface IuiuesourceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *MyTableView;//列表
    
    NSInteger page;
    NSArray *info;
    NSMutableArray *mutablearray;
    
    NSString *nid;
    NSString *type;
    
    UIColor *color;//viewone 上的颜色
    UILabel *line_lable;

    UIButton *sure_btn;//确认添加
    
    UIView *viewone;//点击添加跳出来的viewone
    
    
    UITextField *textfile;//来源名称
    NSString *color_num;//颜色的数值（1——9）
    NSString *color_num2;//接受color
    
    MBProgressHUD *hud;//指示透明层
    
    UIBarButtonItem *right;
    
    UIButton *button;
}

@end

@implementation IuiuesourceViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"房客来源";
          }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT-64) style:UITableViewStylePlain];
    MyTableView.tableFooterView = [[UIView alloc]init];
    MyTableView.dataSource = self;
    MyTableView.delegate = self;
    [self.view addSubview:MyTableView];
    [self setEditing:YES animated:YES];
    right = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = right;
    
    color = COLOR__FIVE;
    color_num2 = @"5";
    // Do any additional setup after loading the view.
}
-(void)add{
    //添加动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction =UIViewAnimationCurveEaseInOut;
    animation.fillMode =kCAFillModeForwards; //基本型
    animation.type =kCATransitionPush; //私有API，字符串型
    animation.type = @"rippleEffect";
    [self.view.layer addAnimation:animation forKey:@"animation"];
    /////////////////////////////////
    
    self.navigationController.navigationBar.hidden = YES;
    CGRect frame = [UIScreen mainScreen].bounds;
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    button.backgroundColor = COLOR_back;
    [button addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    
    viewone = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x + 15, frame.origin.y + 80, frame.size.width - 30, 230)];
    viewone.backgroundColor = [UIColor whiteColor];
    viewone.layer.masksToBounds = YES;
    viewone.layer.cornerRadius = 8;
    [self.view addSubview:viewone];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 70, 40)];
    lable.text = @"来源名称:";
    [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    lable.alpha = 0.5;
    [viewone addSubview:lable];
    textfile = [[UITextField alloc]initWithFrame:CGRectMake(80, 20, 200, 40)];
    textfile.delegate = self;
    textfile.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [viewone addSubview:textfile];
    line_lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 270, 20)];
    line_lable.layer.masksToBounds = YES;
    line_lable.layer.cornerRadius = 3;
    line_lable.text = @"请选择您将要生成的颜色(默认为绿)";
    line_lable.backgroundColor = color;
    [line_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    line_lable.textAlignment = UITextAlignmentCenter;
    line_lable.alpha = 0.5;
    [viewone addSubview:line_lable];
    
    for(int i = 0;i < 9;i++){
        UIButton *button_color = [[UIButton alloc]initWithFrame:CGRectMake(30*i+11, 120, 24, 24)];
        [button_color setTag:i+1];
        [button_color addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
        button_color.layer.masksToBounds = YES;
        button_color.layer.cornerRadius = 12;
        
        if(button_color.tag == 1){
            [button_color setBackgroundColor:COLOR_ONE];
        }
        if(button_color.tag == 2){
            [button_color setBackgroundColor:COLOR_TWO];
        }
        if(button_color.tag == 3){
            [button_color setBackgroundColor:COLOR_THREE];
        }
        if(button_color.tag == 4){
            [button_color setBackgroundColor:COLOR_FOUR];
        }
        if(button_color.tag == 5){
            [button_color setBackgroundColor:COLOR_FIVE];
        }
        if(button_color.tag == 6){
            [button_color setBackgroundColor:COLOR_SIX];
        }
        if(button_color.tag == 7){
            [button_color setBackgroundColor:COLOR_SEVEN];
        }
        if(button_color.tag == 8){
            [button_color setBackgroundColor:COLOR_EIGHT];
        }
        if(button_color.tag == 9){
            [button_color setBackgroundColor:COLOR_NINE];
        }
        [viewone addSubview:button_color];
    }
    sure_btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 160, 270, 50)];
    [sure_btn setBackgroundColor:color];
    [sure_btn setTitle:@"确定" forState:UIControlStateNormal];
    sure_btn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [sure_btn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    sure_btn.layer.masksToBounds = YES;
    sure_btn.layer.cornerRadius = 6;
    [viewone addSubview:sure_btn];
    sure_btn.alpha = 0.6;
}
-(void)delete{
    //添加动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction =UIViewAnimationCurveEaseInOut;
    animation.fillMode =kCAFillModeForwards; //基本型
    animation.type =kCATransitionPush; //私有API，字符串型
    animation.type = @"rippleEffect";
    [self.view.layer addAnimation:animation forKey:@"animation"];
    /////////////////////////////////
    [button removeFromSuperview];
    [viewone removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
}
-(IBAction)sure:(id)sender{
    UIButton *click = (UIButton *)sender;
    if([click.titleLabel.text isEqualToString:@"修改"]){
        type = @"3";
        color_num = color_num2;
        [self getdata];
        [button removeFromSuperview];
        [viewone removeFromSuperview];
        self.navigationController.navigationBar.hidden = NO;
    }else{
        if(textfile.text.length == 0){
            [textfile resignFirstResponder];
            [self.view makeToast:@"来源名称不能为空" duration:1 position:@"center"];
            return;
        }
        NSString *text = [textfile.text substringWithRange:NSMakeRange(0, 1)];
        if(textfile.text.length >0 && ![text isEqual: @" "]){
            type = @"1";
            nid = @"";
            color_num = color_num2;
            [self getdata];
            [button removeFromSuperview];
            [viewone removeFromSuperview];
            self.navigationController.navigationBar.hidden = NO;
        
        }else{
            [textfile resignFirstResponder];
            [self.view makeToast:@"第一位不能为空格" duration:1 position:@"center"];
        }
    }
}
-(IBAction)chose:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1){
        line_lable.backgroundColor = COLOR_ONE;
        [sure_btn setBackgroundColor:COLOR_ONE];
        sure_btn.alpha = 0.6;
        color_num2 = @"1";
    }
    if(btn.tag == 2){
        line_lable.backgroundColor = COLOR_TWO;
        [sure_btn setBackgroundColor:COLOR_TWO];
        sure_btn.alpha = 0.6;
        color_num2 = @"2";
    }
    if(btn.tag == 3){
        line_lable.backgroundColor = COLOR_THREE;
        [sure_btn setBackgroundColor:COLOR_THREE];
        sure_btn.alpha = 0.6;
        color_num2 = @"3";
    }
    if(btn.tag == 4){
        line_lable.backgroundColor = COLOR_FOUR;
        [sure_btn setBackgroundColor:COLOR_FOUR];
        sure_btn.alpha = 0.6;
        color_num2 = @"4";
    }
    if(btn.tag == 5){
        line_lable.backgroundColor = COLOR_FIVE;
        [sure_btn setBackgroundColor:COLOR_FIVE];
        sure_btn.alpha = 0.6;
        color_num2 = @"5";
    }
    if(btn.tag == 6){
        line_lable.backgroundColor = COLOR_SIX;
        [sure_btn setBackgroundColor:COLOR_SIX];
        sure_btn.alpha = 0.6;
        color_num2 = @"6";
    }
    if(btn.tag == 7){
        line_lable.backgroundColor = COLOR_SEVEN;
        [sure_btn setBackgroundColor:COLOR_SEVEN];
        sure_btn.alpha = 0.6;
        color_num2 = @"7";
    }
    if(btn.tag == 8){
        line_lable.backgroundColor = COLOR_EIGHT;
        [sure_btn setBackgroundColor:COLOR_EIGHT];
        sure_btn.alpha = 0.6;
        color_num2 = @"8";
    }
    if(btn.tag == 9){
        line_lable.backgroundColor = COLOR_NINE;
        [sure_btn setBackgroundColor:COLOR_NINE];
        sure_btn.alpha = 0.6;
        color_num2 = @"9";
    }
    
}
//cell的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutablearray.count;
    NSLog(@"%@",mutablearray);
}
//cell的加载
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *table = @"table";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic_info = mutablearray[indexPath.row];
    UIButton *button_bak = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    button_bak.layer.masksToBounds = YES;
    button_bak.layer.cornerRadius = 15;
    if([dic_info[@"color"]integerValue] == 1){
        [button_bak setBackgroundColor:COLOR_ONE];
    }
        if ([dic_info[@"color"]integerValue] == 2){
        [button_bak setBackgroundColor:COLOR_TWO];
    }
        if ([dic_info[@"color"]integerValue] == 3){
        [button_bak setBackgroundColor:COLOR_THREE];
    }
        if ([dic_info[@"color"]integerValue] == 4){
         [button_bak setBackgroundColor:COLOR_FOUR];
    }
         if ([dic_info[@"color"]integerValue] == 5){
        [button_bak setBackgroundColor:COLOR_FIVE];
    }
         if ([dic_info[@"color"]integerValue] == 6){
        [button_bak setBackgroundColor:COLOR_SIX];
    }
        if ([dic_info[@"color"]integerValue] == 7){
        [button_bak setBackgroundColor:COLOR_SEVEN];
    }
        if ([dic_info[@"color"]integerValue] == 8){
       [button_bak setBackgroundColor:COLOR_EIGHT];
   }
        if([dic_info[@"color"]integerValue] == 9){
        [button_bak setBackgroundColor:COLOR_NINE];
   }
    
    [cell.contentView addSubview:button_bak];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 100, 30)];
    [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    lable.alpha = 0.5;
    [cell addSubview:lable];
    lable.text = dic_info[@"webname"];
    return cell;
}
//cell的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = mutablearray[indexPath.row];
    color_num2 = [NSString stringWithFormat:@"%@",dic[@"color"]];
    nid = [NSString stringWithFormat:@"%@",dic[@"nid"]];
    NSString *name = [NSString stringWithFormat:@"%@",dic[@"webname"]];
    self.navigationController.navigationBar.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textfile becomeFirstResponder];
});
    CGRect frame = [UIScreen mainScreen].bounds;
    button = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    //button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    button.backgroundColor = COLOR_back;
    [button addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    viewone = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x + 15, frame.origin.y + 80, frame.size.width - 30, 230)];
    viewone.backgroundColor = [UIColor whiteColor];
    viewone.layer.masksToBounds = YES;
    viewone.layer.cornerRadius = 8;
    [self.view addSubview:viewone];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 70, 40)];
    lable.text = @"来源名称:";
    [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    lable.alpha = 0.5;
    [viewone addSubview:lable];
    textfile = [[UITextField alloc]initWithFrame:CGRectMake(80, 20, 200, 40)];
    textfile.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textfile.text = name;
    [viewone addSubview:textfile];
    line_lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 270, 20)];
    line_lable.layer.masksToBounds = YES;
    line_lable.layer.cornerRadius = 3;
    line_lable.text = @"此颜色为当前的颜色";
    
    
    sure_btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 160, 270, 50)];
    [sure_btn setTitle:@"修改" forState:UIControlStateNormal];
    sure_btn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:17];
    [sure_btn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    sure_btn.layer.masksToBounds = YES;
    sure_btn.layer.cornerRadius = 6;
    [viewone addSubview:sure_btn];
    sure_btn.alpha = 0.6;
    if([dic[@"color"]integerValue] == 1){
        [line_lable setBackgroundColor:COLOR_ONE];
        [sure_btn setBackgroundColor:COLOR_ONE];
    }
    if([dic[@"color"]integerValue] == 2){
        [line_lable setBackgroundColor:COLOR_TWO];
        [sure_btn setBackgroundColor:COLOR_TWO];
    }
    if([dic[@"color"]integerValue] == 3){
        [line_lable setBackgroundColor:COLOR_THREE];
        [sure_btn setBackgroundColor:COLOR_THREE];
    }
    if([dic[@"color"]integerValue] == 4){
        [line_lable setBackgroundColor:COLOR_FOUR];
        [sure_btn setBackgroundColor:COLOR_FOUR];
    }
    if([dic[@"color"]integerValue] == 5){
        [line_lable setBackgroundColor:COLOR_FIVE];
        [sure_btn setBackgroundColor:COLOR_FIVE];
    }
    if([dic[@"color"]integerValue] == 6){
        [line_lable setBackgroundColor:COLOR_SIX];
        [sure_btn setBackgroundColor:COLOR_SIX];
    }
    if([dic[@"color"]integerValue] == 7){
        [line_lable setBackgroundColor:COLOR_SEVEN];
        [sure_btn setBackgroundColor:COLOR_SEVEN];
    }
    if([dic[@"color"]integerValue] == 8){
        [line_lable setBackgroundColor:COLOR_EIGHT];
        [sure_btn setBackgroundColor:COLOR_EIGHT];
    }
    if([dic[@"color"]integerValue] == 9){
        [line_lable setBackgroundColor:COLOR_NINE];
        [sure_btn setBackgroundColor:COLOR_NINE];
    }
    [line_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    line_lable.textAlignment = UITextAlignmentCenter;
    line_lable.alpha = 0.5;
    [viewone addSubview:line_lable];
    
    for(int i = 0;i < 9;i++){
        UIButton *button_color = [[UIButton alloc]initWithFrame:CGRectMake(30*i+11, 120, 24, 24)];
        [button_color setTag:i+1];
        [button_color addTarget:self action:@selector(chose:) forControlEvents:UIControlEventTouchUpInside];
        button_color.layer.masksToBounds = YES;
        button_color.layer.cornerRadius = 12;
        
        if(button_color.tag == 1){
            [button_color setBackgroundColor:COLOR_ONE];
        }
        if(button_color.tag == 2){
            [button_color setBackgroundColor:COLOR_TWO];
        }
        if(button_color.tag == 3){
            [button_color setBackgroundColor:COLOR_THREE];
        }
        if(button_color.tag == 4){
            [button_color setBackgroundColor:COLOR_FOUR];
        }
        if(button_color.tag == 5){
            [button_color setBackgroundColor:COLOR_FIVE];
        }
        if(button_color.tag == 6){
            [button_color setBackgroundColor:COLOR_SIX];
        }
        if(button_color.tag == 7){
            [button_color setBackgroundColor:COLOR_SEVEN];
        }
        if(button_color.tag == 8){
            [button_color setBackgroundColor:COLOR_EIGHT];
        }
        if(button_color.tag == 9){
            [button_color setBackgroundColor:COLOR_NINE];
        }
        [viewone addSubview:button_color];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//滑动删除cell
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *dic = mutablearray[indexPath.row];
        nid = dic[@"nid"];
        type = @"2";
        page = 1;
        [self getdata];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//通过接口获取数据
-(void)getdata{
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/source"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:nid forKey:@"nid"];
    [request addPostValue:type forKey:@"type"];
    [request addPostValue:textfile.text forKey:@"webname"];
    [request addPostValue:color_num forKey:@"color"];
    [request setCompletionBlock:^{
        self.navigationItem.rightBarButtonItem = right;
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        info = dic[@"info_list"];
        if([dic[@"code"]integerValue] == 0){
            [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
            [MyTableView reloadData];
            return;
        }
        mutablearray = [NSMutableArray array];
        for (NSDictionary *dic_info in info) {
            [mutablearray addObject:dic_info];
        }
        [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
        [MyTableView reloadData];
    }];
    [request setFailedBlock:^{
        self.navigationItem.rightBarButtonItem = right;
        [hud hide:YES];
        [self.view makeToast:@"网络链接异常..." duration:1 position:@"center"];
    }];
    [request startAsynchronous];
    self.navigationItem.rightBarButtonItem = nil;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBar.translucent = YES;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    type = @"0";
    [self getdata];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textfile resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >=6)
        return NO; // return NO to not change text
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
