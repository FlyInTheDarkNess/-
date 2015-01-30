//
//  IuiueRoomDetailViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-10.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueRoomDetailViewController.h"

@interface IuiueRoomDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    UITableView *MyTableView;//列表
    UITextField *TitleField;//房间标题
    UITextField *PriceField;//房间价格
    UITextField *Remarks;//备注信息
    UILabel *Status;//房间状态
    MBProgressHUD *hud;//透明指示层
}

@end

@implementation IuiueRoomDetailViewController
@synthesize Room;

/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"房间详情";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveRoom:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left"] style:UIBarButtonItemStyleBordered target:self action:@selector(popToLeftViewController:)];
    }
    return self;
}

-(IBAction)popToLeftViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.Room) {
        self.navigationItem.title = @"添加房间";
    }
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //初始化
    TitleField = [[UITextField alloc]initWithFrame:CGRectMake(100, 2, 150, 40)];
    PriceField = [[UITextField alloc]initWithFrame:TitleField.frame];
    Remarks = [[UITextField alloc]initWithFrame:TitleField.frame];
    Status = [[UILabel alloc]initWithFrame:TitleField.frame];
    TitleField.placeholder = @"请填写房间名称";
    PriceField.placeholder = @"请填写房间价格";
    Remarks.placeholder = @"请填写备注信息";
    TitleField.returnKeyType = UIReturnKeyDone;
    PriceField.returnKeyType = UIReturnKeyDone;
    Remarks.returnKeyType = UIReturnKeyDone;
    TitleField.delegate = self;
    PriceField.delegate = self;
    Remarks.delegate = self;
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT-64) style:UITableViewStyleGrouped];
    MyTableView.dataSource = self;
    MyTableView.delegate = self;
    
    [self.view addSubview:MyTableView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 @method
 @abstract 保存房间
 */
-(IBAction)saveRoom:(id)sender{
    if(TitleField.text.length == 0){
        [self showAlertView:@"房间标题不可为空"];
        return;
    }
    if(PriceField.text.length == 0){
        [self showAlertView:@"房间价格不可为空"];
        return;
    }
    [TitleField resignFirstResponder];
    [PriceField resignFirstResponder];
    [self SendToSaveRoom];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //根据Room是否为空来判断是添加房间还是查看房间
    if (Room == nil) {
        return 3;
    }
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//加载cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reusedidentify = [NSString stringWithFormat:@"%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusedidentify];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (Room) {
            switch (indexPath.section) {
                case 0:{
                    cell.textLabel.text = @"房间名称：";
                    [cell.contentView addSubview:TitleField];
                    TitleField.text = Room.RoomTitle;
                }
                    break;
                case 1:{
                    cell.textLabel.text = @"房间价格：";
                    [cell.contentView addSubview:PriceField];
                    PriceField.text = [NSString stringWithFormat:@"%@",Room.DayPrice];
                }
                    break;
                case 2:{
                    cell.textLabel.text = @"备注信息：";
                    [cell.contentView addSubview:Remarks];
                    Remarks.text = Room.Remarks;
                }
                    break;
                case 3:{
                    cell.textLabel.text = @"房屋状态：";
                    [cell.contentView addSubview:Status];
                    if (Room.Status == 0) {
                        Status.text = @"空闲中";
                        Status.textColor = [UIColor greenColor];
                    }else if(Room.Status == 1){
                        Status.text = @"已入住";
                        Status.textColor = [UIColor redColor];
                    }
                    else{
                        Status.text = @"已预订";
                        Status.textColor = [UIColor purpleColor];
                    }
                }
                    break;
                case 4:
                {
                    UILabel *TextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
                    
                    TextLabel.text = @"删除房间";
                    TextLabel.textAlignment = NSTextAlignmentCenter;
                    TextLabel.textColor = [UIColor redColor];
                    [cell.contentView addSubview:TextLabel];
                }

                default:
                    break;
            }
        }
            else{
                switch (indexPath.section) {
                    case 0:{
                        cell.textLabel.text = @"房间标题：";
                        [cell.contentView addSubview:TitleField];
                    }
                        break;
                    case 1:{
                        cell.textLabel.text = @"房间价格：";
                        [cell.contentView addSubview:PriceField];
                    }
                        break;
                    case 2:{
                        cell.textLabel.text = @"备注信息：";
                        [cell.contentView addSubview:Remarks];
                    }
                        break;
                        
                    default:
                        break;
                }
        }
    }
       return cell;
}

/*!
 @method
 @abstract 回车收起键盘
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [TitleField resignFirstResponder];
    [PriceField resignFirstResponder];
    [Remarks resignFirstResponder];
    
    return YES;
}

/*!
 @method
 @abstract 保存信息有误提醒
*/
-(void)showAlertView:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)SendToSaveRoom{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ROOM]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:TitleField.text forKey:@"title"];
    [request addPostValue:PriceField.text forKey:@"price"];
    [request addPostValue:Remarks.text forKey:@"remark"];
    
    //编辑操作
    if (Room) {
        [request addPostValue:@"3" forKey:@"type"];
        [request addPostValue:Room.RoomId forKey:@"roomid"];
    }
    else{
        [request addPostValue:@"1" forKey:@"type"];
    }
    
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
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        IuiueRoom *oneRoom = [[IuiueRoom alloc]initWithRoomId:@"" DayPrice:PriceField.text Remarks:Remarks.text RoomTitle:TitleField.text Status:[Status.text integerValue]];
//                        [_Roomdelegate getRoom:oneRoom];
                        [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)SendToDeleteRoom{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ROOM]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:@"2" forKey:@"type"];
    [request addPostValue:Room.RoomId forKey:@"roomid"];
    
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
                    [self.navigationController popViewControllerAnimated:YES];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        [self ShowActionSheet];
    }
}

-(void)ShowActionSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"删除该房间将失去有关的所有信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"继续删除" otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self SendToDeleteRoom];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
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
