//
//  IuiueRoomViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-3.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueRoomViewController.h"
#import "IuiueRoomDetailViewController.h"
#import "MJRefresh.h"

@interface IuiueRoomViewController ()<UITableViewDataSource,UITableViewDelegate,SaveRoom,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger pages;
    UITableView *MyTableView;//列表
    NSMutableArray *MyRoomArray;//房间集合
    MBProgressHUD *hud;
    UISegmentedControl *segment;//空房间/所有房间
    __weak ASIFormDataRequest *request;
}

@end

@implementation IuiueRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.navigationItem.title = @"我的房间";
        self.navigationItem.rightBarButtonItem = self.editButtonItem;//使用系统自带方法实现编辑效果
        
        //设置返回键
        UIBarButtonItem *item = [[UIBarButtonItem alloc]init];
//        item.title = @"返回";
        self.navigationItem.backBarButtonItem = item;
    }
    return self;
}

//系统自带编辑功能
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    NSInteger num = [self tableView:MyTableView numberOfRowsInSection:0];
    [super setEditing:editing animated:animated];
    if (editing) {
        if (num == MyRoomArray.count) {
            NSIndexPath *indext = [NSIndexPath indexPathForRow:0 inSection:0];
            [MyTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indext] withRowAnimation:UITableViewRowAnimationFade];
            [MyTableView setEditing:editing animated:animated];
        }
    }else{
        if (num == MyRoomArray.count + 1) {
            NSIndexPath *indext = [NSIndexPath indexPathForRow:0 inSection:0];
            [MyTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indext] withRowAnimation:UITableViewRowAnimationFade];
            [MyTableView setEditing:editing animated:animated];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MyRoomArray = [NSMutableArray arrayWithCapacity:10];
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 108) style:UITableViewStylePlain];
    MyTableView.tableFooterView = [[UIView alloc]init];
    MyTableView.dataSource = self;
    MyTableView.delegate = self;
    MyTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:MyTableView];
    
    
//    //当没有房间时隐藏编辑按钮，并设置为编辑状态
//    if (MyRoomArray.count == 0) {
//        [self setEditing:YES animated:YES];
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    
    segment = [[UISegmentedControl alloc]initWithItems:@[@"空闲房间",@"所有房间"]];
    segment.tintColor = [UIColor whiteColor];
    [segment setFrame:CGRectMake(MY_WIDTH/2 - 80, 8, 160, 30)];
    [segment setSelectedSegmentIndex:0];
    [self.navigationController.navigationBar addSubview:segment];
    [segment addTarget:self action:@selector(SegmValueChange:) forControlEvents:UIControlEventValueChanged];
    
    pages = 1;
    [self setFreshView];//添加下拉刷新
    
    // Do any additional setup after loading the view.
}

#pragma mark - mjfresh
- (void)setFreshView{
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = MyTableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = MyTableView;
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    
    if (_header == refreshView) {
        
        pages = 1;
        [self SendToCheckRoomList:YES];
        
    } else {
        
        [self SendToCheckRoomList:NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_header endRefreshing];
    [_footer endRefreshing];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //当有房间时显示编辑按钮
    if (self.editing) {
        if (MyRoomArray.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        return MyRoomArray.count + 1;
    }
    return MyRoomArray.count;
}

//加载cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *reusedidentify = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedidentify];
        cell.backgroundColor = [UIColor clearColor];
    
        UILabel *Price = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, 80, 10)];
        Price.textAlignment = NSTextAlignmentCenter;
        Price.textColor = [UIColor grayColor];
        Price.text = @"房间价格";
        Price.font = [UIFont systemFontOfSize:10];
        Price.tag = 3;
        
        UILabel *PriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(Price.left, Price.bottom, Price.width, 30)];
        PriceLabel.textAlignment = NSTextAlignmentCenter;
        PriceLabel.tag = 1;
        UILabel *Status = [[UILabel alloc]initWithFrame:CGRectMake(Price.right, Price.top, Price.width, Price.height)];
        Status.textColor = [UIColor grayColor];
        Status.textAlignment = NSTextAlignmentCenter;
        Status.text = @"房间状态";
        Status.font = [UIFont systemFontOfSize:10];
        Status.tag = 4;
        UILabel *StatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(Status.left, Status.bottom, Status.width, PriceLabel.height)];
        StatusLabel.textAlignment = NSTextAlignmentCenter;
        StatusLabel.tag = 2;
        [cell.contentView addSubviews:@[PriceLabel,StatusLabel,Price,Status]];
        
    }
    if (self.editing&&indexPath.row == 0) {
        cell.textLabel.text = @"添加房间";
        cell.detailTextLabel.text = @"";
        UILabel *PriceLabel =(UILabel *)[cell.contentView viewWithTag:1];
        UILabel *StatusLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *Price = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *Status = (UILabel *)[cell.contentView viewWithTag:4];
        Price.hidden = YES;
        Status.hidden = YES;
        PriceLabel.hidden = YES;
        StatusLabel.hidden = YES;
    }
    else if(self.editing){
        UILabel *PriceLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *StasusLabel = (UILabel *)[cell viewWithTag:2];
        PriceLabel.hidden = NO;
        StasusLabel.hidden = NO;
        IuiueRoom *room = (IuiueRoom *)MyRoomArray[indexPath.row - 1];
        if (room.RoomTitle.length <7) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",room.RoomTitle];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@...",[room.RoomTitle substringToIndex:5]];
        }
        if (room.Remarks.length < 7) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"(%@)",room.Remarks];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@...)",[room.Remarks substringToIndex:5]];
        }
        if (cell.detailTextLabel.text.length>2) {
        }else{
            cell.detailTextLabel.text = @"";
        }
        cell.detailTextLabel.textColor = [UIColor grayColor];
        PriceLabel.text = [NSString stringWithFormat:@"￥%@",room.DayPrice];
        
        if (room.Status == 1) {
            StasusLabel.text = [NSString stringWithFormat:@"入住中"];
            StasusLabel.textColor = [UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:51.0/255.0 alpha:1];
        }else{
            StasusLabel.text = [NSString stringWithFormat:@"空闲中"];
            StasusLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:0 alpha:1];
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *Price = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *Stasus = (UILabel *)[cell.contentView viewWithTag:4];
        Price.hidden = NO;
        Stasus.hidden = NO;
    }else{
        IuiueRoom *room = (IuiueRoom *)MyRoomArray[indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@",room.RoomTitle];
//        cell.detailTextLabel.text =[NSString stringWithFormat:@"(%@)",room.Remarks];
        if (room.RoomTitle.length <7) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",room.RoomTitle];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@...",[room.RoomTitle substringToIndex:5]];
        }
        if (room.Remarks.length < 7) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"(%@)",room.Remarks];
        }else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@...)",[room.Remarks substringToIndex:5]];
        }
        if (cell.detailTextLabel.text.length>2) {
        }else{
            cell.detailTextLabel.text = @"";
        }
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *PriceLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *StasusLabel = (UILabel *)[cell viewWithTag:2];
        PriceLabel.hidden = NO;
        StasusLabel.hidden = NO;
        PriceLabel.text = [NSString stringWithFormat:@"￥%@",room.DayPrice];
        if (room.Status == 1) {
            StasusLabel.text = [NSString stringWithFormat:@"入住中"];
            StasusLabel.textColor = [UIColor colorWithRed:204.0/255.0 green:0/255.0 blue:51.0/255.0 alpha:1];
        }else{
            StasusLabel.text = [NSString stringWithFormat:@"空闲中"];
            StasusLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:0 alpha:1];
        }
        UILabel *Price = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *Stasus = (UILabel *)[cell.contentView viewWithTag:4];
        Price.hidden = NO;
        Stasus.hidden = NO;
    }
    return cell;
}

//编辑状态后是否可被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//返回当前cell可删除或添加 与滑动删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPat{

    
    if (!self.editing&&indexPat.row==0) {
        return UITableViewCellEditingStyleDelete;
    }
    else if (indexPat.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete;
}

//
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除房间后续操作
        if (self.editing) {
            IuiueRoom *room = MyRoomArray[indexPath.row - 1];
            [self SendToDeleteRoomId:room.RoomId];
            return;
        }
        else
        {
//        [MyRoomArray removeObjectAtIndex:indexPath.row];
            IuiueRoom *room = MyRoomArray[indexPath.row];
            [self SendToDeleteRoomId:room.RoomId];
//            [self setEditing:YES animated:YES];
            return;
        }
//        [MyTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        if (MyRoomArray.count == 0) {
//            self.navigationItem.rightBarButtonItem = nil;
//        }
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert) {
        //添加房间后续操作
        IuiueRoomDetailViewController *detail = [[IuiueRoomDetailViewController alloc]init];
        detail.Roomdelegate = self;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

//点击查看或修改房间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IuiueRoomDetailViewController *RoomDetail = [[IuiueRoomDetailViewController alloc]init];
    RoomDetail.Room = (IuiueRoom *)MyRoomArray[indexPath.row];
    RoomDetail.Roomdelegate = self;
    [self.navigationController pushViewController:RoomDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


/*!
 @method
 @abstract 保存房间方法
  */
-(void)getRoom:(IuiueRoom *)Room{
    for (int row = 0; row < MyRoomArray.count; row++) {
        IuiueRoom *Oneroom = (IuiueRoom *)MyRoomArray[0];
        if ([Oneroom.RoomTitle isEqualToString:Room.RoomTitle]) {
            [MyRoomArray replaceObjectAtIndex:row withObject:Room];
            [MyTableView reloadData];
            return;
        }
    }
    [MyRoomArray addObject:Room];
    [MyTableView reloadData];
}

-(void)SendToCheckRoomList:(BOOL)IsUpdate{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ROOM]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    NSString *status;
    switch (segment.selectedSegmentIndex) {
        case 0:
            status = @"2";
            break;
        case 1:
            status = @"0";
            break;
        default:
            break;
    }
   
    NSString *page = [NSString stringWithFormat:@"%d",pages];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:page forKey:@"page"];
    [request addPostValue:@"0" forKey:@"type"];//查询操作
    [request addPostValue:status forKey:@"status"];//房间状态
    [request setCompletionBlock:^{
        [hud hide:YES];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
                    
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                    [self.view makeToast:str duration:0.5 position:@"center"];
                    NSArray *arr = resultDict[@"info_list"];
                    if (IsUpdate) {
                        [MyRoomArray removeAllObjects];
                    }
                    for (NSDictionary *dic  in  arr) {
                       
                        IuiueRoom *room = [[IuiueRoom alloc]initWithRoomId:dic[@"roomid"] DayPrice:dic[@"price"] Remarks:dic[@"remark"] RoomTitle:dic[@"title"] Status:[dic[@"status"] integerValue]];
                        [MyRoomArray addObject:room];
                    }
//                    //当没有房间时隐藏编辑按钮，并设置为编辑状态
//                    if (MyRoomArray.count == 0) {
//                        [self setEditing:YES animated:YES];
//                        self.navigationItem.rightBarButtonItem = nil;
//                    }
                    [MyTableView reloadData];
                    if (self.editing) {
                        if (MyRoomArray.count > 0) {
                            [self setEditing:NO animated:YES];
                        }
                    }else{
                        if (MyRoomArray.count > 0) {
                            [self setEditing:NO animated:YES];
                        }else{
                        [self setEditing:YES animated:YES];
                        }
                    }
                    pages++;
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
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];

}

-(void)SendToDeleteRoomId:(NSString *)RoomId{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ROOM]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:RoomId forKey:@"roomid"];
    [request addPostValue:@"2" forKey:@"type"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:0.5 position:@"center"];
//                    NSArray *arr = resultDict[@"info_list"];
//                    [MyRoomArray removeAllObjects];
//                    for (NSDictionary *dic  in  arr) {
//                        IuiueRoom *room = [[IuiueRoom alloc]initWithRoomId:dic[@"roomid"] DayPrice:dic[@"price"] Remarks:dic[@"remark"] RoomTitle:dic[@"title"] Status:[resultDict[@"staus"] integerValue]];
//                        [MyRoomArray addObject:room];
//                    }
//                    [MyTableView reloadData];
//                    if (self.editing) {
//                        if (MyRoomArray.count > 0) {
//                            [self setEditing:NO animated:YES];
//                        }
//                    }else{
//                        if (MyRoomArray.count > 0) {
//                            [self setEditing:NO animated:YES];
//                        }else{
//                            [self setEditing:YES animated:YES];
//                        }
//                    }
                    pages = 1;
                    [self SendToCheckRoomList:YES];

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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    segment.hidden = NO;
    pages = 1;
    [self SendToCheckRoomList:YES];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    segment.hidden = YES;
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
    [_header free];
    [_footer free];
    
}

-(IBAction)SegmValueChange:(id)sender{
    pages = 1;
    [self SendToCheckRoomList:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [request cancel];
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
