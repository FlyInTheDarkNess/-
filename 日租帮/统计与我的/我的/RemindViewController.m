//
//  RemindViewController.m
//  XXX
//
//  Created by macmini on 14-8-20.
//  Copyright (c) 2014年 macmini. All rights reserved.
//

#import "RemindViewController.h"
#import "MJRefresh.h"
#import "IuiueLoginViewController.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
@interface RemindViewController()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>{
    NSMutableArray *mutableArray;
    NSArray *info;
    UITableView *tableview;

    UITextView *textview;

    NSString *delete_id;
    NSString *type;
    NSString *send;
    

    //刷新调用
    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    MBProgressHUD *hud;
    
    UILabel *lable;
}

@end

@implementation RemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    //消减badage数量
    [self TurnBadageToOut];
    
    self.navigationItem.title = @"提醒事项";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 84)];
    [self.view addSubview:tableview];
    [tableview setSeparatorColor:[UIColor clearColor]];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    
    UIView *view_back = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view_back.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview.backgroundView = view_back;
    [self setFreshView];
    type = @"0";
    
        //notification.fireDate=[now addTimeInterval:period];

    // Do any additional setup after loading the view.
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_footer endRefreshing];
    [_header endRefreshing];
    return mutableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *table = @"table";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:table];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
        CGRect frame = [UIScreen mainScreen].bounds;
        NSDictionary *dic = mutableArray[indexPath.row];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x + 15, frame.origin.y +20, frame.size.width - 30, 160)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 5, frame.origin.y +5, 285, 20)];
        lable.text = @"内容:";
        lable.alpha = 0.5;
        [view addSubview:lable];
        UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 5, 30, 280, 20)];
        [view addSubview:content];
        content.text = dic[@"content"];
        [content setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        content.numberOfLines = 3;
        [content sizeToFit];
        content.alpha = 0.5;
        
        
        UILabel *lable_line = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 5, frame.origin.y +78, 285, 2)];
        lable_line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:lable_line];
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(5, 80, 100, 40)];
        [view addSubview:time];
        time.text = @"时间:";
        time.alpha = 0.5;
        UILabel *time_content = [[UILabel alloc]initWithFrame:CGRectMake(125, 80, 155, 40)];
        [view addSubview:time_content];
        NSString *regtime = [NSString stringWithFormat:@"%@",dic[@"regtime"]];
        NSString *year = [regtime substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [regtime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [regtime substringWithRange:NSMakeRange(8, 2)];
        NSString *watch = [regtime substringFromIndex:11];
        NSString *today_watch = [watch substringWithRange:NSMakeRange(0, 5)];
        time_content.text = [NSString stringWithFormat:@"%@年%@月%@日 %@",year,month,day,today_watch];
        [time_content setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        time_content.alpha = 0.5;
        
        UILabel *lable_line_two = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 5, frame.origin.y +118, 285, 2)];
        [view addSubview:lable_line_two];
        lable_line_two.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        UILabel *lable_remid = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 5, 120, 200, 40)];
//        [lable_remid setFont:[UIFont fontWithName:@"Helvetica" size:15]];
//        [view addSubview:lable_remid];
//        lable_remid.alpha = 0.5;
    
        
//        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(235, 125, 50, 30)];
//        swit.tag = indexPath.row;
//        [swit addTarget:self action:@selector(swit_gai:) forControlEvents:UIControlEventValueChanged];
//        [view addSubview:swit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if([dic[@"send"]integerValue] == 1){
//            [swit setOn:YES];
//            lable_remid.text = @"到提醒时间日租帮会提醒您";
//        }else{
//            lable_remid.text = @"您已经关闭提醒(不会再提醒)";
//            [swit setOn:NO];
//        }

    
    
       return cell;
}
-(IBAction)swit_gai:(id)sender{
    UISwitch *SW = (UISwitch *)sender;
    NSDictionary *dic = mutableArray[SW.tag];
    delete_id = dic[@"nid"];
    if(SW.on){
        type = @"3";
       send = @"1";
        mutableArray = [NSMutableArray array];
        page = 1;
        [self getdata];
        
    }else{
        type = @"3";
        send = @"0";
        mutableArray = [NSMutableArray array];
        page = 1;
        [self getdata];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(editingStyle == UITableViewCellEditingStyleDelete){
//        NSDictionary *dic = mutableArray[indexPath.row];
//        NSString *_id = [NSString stringWithFormat:@"%@",dic[@"nid"]];
//        mutableArray = [NSMutableArray array];
//        page = 1;
//        delete_id = _id;
//        type = @"2";
//        [self getdata];
//    }
//}
//获取提醒的数据  获取提醒的数据
-(void)getdata{ //获取提醒的数据  获取提醒的数据

    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
     __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/notice"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:send forKey:@"send"];
    [request addPostValue:type forKey:@"type"];
    [request addPostValue:delete_id forKey:@"nid"];
    NSString *pageone = [NSString stringWithFormat:@"%d",page];
    [request addPostValue:pageone forKey:@"page"];
    //[request addPostValue:delete_id forKey:@"nid"];
     [request setCompletionBlock:^{
         [hud hide:YES];
         NSLog(@"%@",request.responseString);
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
         
         NSInteger zpage = [dic[@"zpage"]integerValue];

         if([dic[@"all_num"]integerValue] == 0){
             self.navigationItem.title = @"提醒事项(共0项)";
             tableview.hidden = YES;
             lable = [[UILabel alloc]initWithFrame:CGRectMake(0, MY_HEIGHT / 4,MY_WIDTH , MY_HEIGHT / 3)];
             [self.view addSubview:lable];
             lable.text = @"无提醒事项";
             lable.textAlignment = NSTextAlignmentCenter;
             lable.alpha = 0.4;
             [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:35]];
             return;
         }else{
             tableview.hidden = NO;
              self.navigationItem.title = [NSString stringWithFormat:@"提醒事项(共%@项)",dic[@"all_num"]];
         }
         if(page > zpage){
            [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
         }
         info = dic[@"info_list"];
         if(page == 1){
             mutableArray = [NSMutableArray array];
         }
         for (NSDictionary *add_dic in info) {
             [mutableArray addObject:add_dic];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    page =1;
    [self getdata];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textview resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    NSDictionary *dicdata = mutableArray[indexPath.row];
//    NSString *text = [NSString stringWithFormat:@"%@\n"@"%@",dicdata[@"regtime"],dicdata[@"content"]];
//    CGSize constraint = CGSizeMake(320.0f - 20.0f, 4000.0f);
//    UIFont *font = [UIFont systemFontOfSize:14.0];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
//    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//    CGRect rect = [ attributedText
//                   boundingRectWithSize:constraint
//                   options:NSStringDrawingUsesLineFragmentOrigin
//                   context:nil
//                   ];
//    CGSize size = rect.size;
//    CGFloat height = MAX(size.height + 10.0f, 44.0f);
//    
//    return height;
    return 200;

    
}

-(void)TurnBadageToOut{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MESSAGE_COUNT]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    IuiueLoginViewController *login = (IuiueLoginViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:login.Tokens forKey:@"tokens"];
    [request addPostValue:@"0" forKey:@"readnum"];
    [request setCompletionBlock:^{
//        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                    [[self rdv_tabBarItem] setBadgeValue:@""];
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
//    hud =
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
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
