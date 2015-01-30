 //
//  The_memoViewController.m
//  XXX
//
//  Created by macmini on 14-8-22.
//  Copyright (c) 2014年 macmini. All rights reserved.
//

#import "The_memoViewController.h"
#import "AddmemoViewController.h"
@interface The_memoViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>{
    UITableView *tableview;
    
    NSArray *json_info;
    NSMutableArray *info;
    NSString *nid;
    NSString *type;

    UITextView *textview;
    
    //刷新调用
    NSInteger page;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    MBProgressHUD *hud;//指示透明层
    
    UIBarButtonItem *rightButton;
    
    UILabel *lable;// 没有数据时显示的lable

    
}

@end

@implementation The_memoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.backBarButtonItem = back;
        self.navigationItem.title = @"备忘录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height -20)];
    [self.view addSubview:tableview];
//    tableview.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memo"]];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, MY_HEIGHT / 4,MY_WIDTH , MY_HEIGHT / 3)];
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self setFreshView];
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
        //点击删除操作以后 type会改成2 然后点击cell的时候会获得nid 然后下拉刷新的时候会传进去 所以刷新也就成为了删除 为了避免这个 所以下拉刷新的时候传type 0 和nid为空
        type = @"0";
        nid = @"";
        [self getdate];
        
    } else {
        
        [self getdate];
    }
}
-(void)getdate{
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/book"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:type forKey:@"type"];
    NSString *page_add = [NSString stringWithFormat:@"%d",page];
    [request addPostValue:page_add forKey:@"page"];
    [request addPostValue:nid forKey:@"nid"];
    [request addPostValue:textview.text forKey:@"content"];
    [request setCompletionBlock:^{
        self.navigationItem.rightBarButtonItem = rightButton;
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        json_info = dic[@"info_list"];
        //[self.view makeToast:dic[@"message"] duration:1 position:@"center"];
        if([dic[@"all_num"]integerValue] == 0){
            self.navigationItem.title = @"备忘录(共0项)";
        }else{
            self.navigationItem.title = [NSString stringWithFormat:@"备忘录(共%@项)",dic[@"all_num"]];
        }
        if(page == 1){
            info = [NSMutableArray array];
        }
        for (NSDictionary *dic_info in json_info) {
            [info addObject:dic_info];
        }
        if(info.count == 0){
            tableview.hidden = YES;
            [self.view addSubview:lable];
            lable.text = @"无备忘录";
            lable.textAlignment = UITextAlignmentCenter;
            lable.alpha = 0.4;
            [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
            return;
        }
        else{
            [lable removeFromSuperview];
            tableview.hidden = NO;
            
        }
        [tableview reloadData];
        page ++;
    }];
    [request setFailedBlock:^{
        [hud hide:YES];
        [self.view makeToast:@"网络连接异常......" duration:1 position:@"center"];
    }];
    [request startAsynchronous];
    self.navigationItem.rightBarButtonItem = nil;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
}
-(void)add{
    AddmemoViewController *addmemo = [[AddmemoViewController alloc]init];
    [self.navigationController pushViewController:addmemo animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     type = @"0";
    nid = @"";
     page =1;
    [self getdate];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
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

/////////////////..............///////////////删除单条数据  删除单条数据  ，，，，，，，，删除单条数据   删除单条数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *dic = info[indexPath.row];
        NSLog(@"%d",indexPath.row);
        NSString *nid_info = [NSString stringWithFormat:@"%@",dic[@"nid"]];
        type = @"2";
        nid = nid_info;
        page = 1;
        [self getdate];
    }
    
}
//返回cell的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_footer endRefreshing];
    [_header endRefreshing];
    return info.count;
}
//加载cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //读取NSString类型的数据
    static NSString *table = @"table";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic_info = info[indexPath.row];
    NSString *time_date = [NSString stringWithFormat:@"%@",dic_info[@"regtime"]];
    NSMutableString *wath = [time_date substringFromIndex:11];
    NSString *date = [wath substringWithRange:NSMakeRange(0, 5)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *centent = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 220, 30)];
    [cell addSubview:centent];
    [centent setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    centent.text = dic_info[@"content"];
    
    
    UILabel *lable_date = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 50, 30)];
    [cell addSubview:lable_date];
    lable_date.text = date;
    [lable_date setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    return cell;
}
// cell的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Memo_detailViewController *memo = [[Memo_detailViewController alloc]init];
    [self.navigationController pushViewController:memo animated:YES];
    NSDictionary *dic = json_info[indexPath.row];
    memo.date = dic[@"regtime"];
    memo.content = dic[@"content"];
    memo.nid = [NSString stringWithFormat:@"%@",dic[@"nid"]];
}
//返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    cell.backgroundColor = [UIColor clearColor];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
