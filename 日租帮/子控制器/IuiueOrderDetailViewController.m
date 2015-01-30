//
//  IuiueOrderDetailViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-11.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueOrderDetailViewController.h"
#import "RDVTabBarController.h"

@interface IuiueOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate>{
    
    UITableView *MyTableView;//列表
    UITextField *UserNameTF;//房客姓名
    UITextField *UserMoblieTF;//手机号
    UITextField *NumberOfPeopleTF;//入住人数
    NSMutableArray *OrderArr;//订单集合
    UITextField *AllforPaidTF;//应付总金额
    UITextField *TotalPriceTF;//付款总金额
    UITextField *PaidRent;//押金
    UITextField *Remarks;//备注信息
    UITextField *ShenFenTF;//身份证号
    NSMutableArray *OtherMoney;//其他费用
    
    //接口传的值
    NSString *startDateStr;//入住时间
    NSString *roomIdStr;//入住房间
    NSString *SourceStr;//房客来源
    NSString *NumberOfPeopleStr;//入住人数
    NSString *numberOfNightStr;//入住天数
    NSString *paidTypeStr1;//支付方式
    NSString *paidTypeStr2;//支付方式
    
    NSArray *inTyPeArr;//渠道arr；
    NSArray *DateArr;//时间arr
    NSArray *roomArr;//房间arr
    NSArray *timeArr;//入住天数arr
    NSArray *PaidTypeArr;//付款方式arr
    NSArray *NumberOfPeopleArr;//入住人数arr
    
    UILabel *InTypeLabel;//房客来源渠道
    UILabel *DateLabel;//入住时间label
    UILabel *RoomLabel;//入住房间
    UILabel *timeLabel;//入住天数
    UILabel *NumberOfPeopleLabel;//入住人数
    UILabel *paidTypeLabel1;//支付方式
    UILabel *paidTypeLabel2;//支付方式
    
    UIPickerView *picker;//pickerView选择
    UIView *MyView;//pickerView的上层view
    MBProgressHUD *hud;//透明指示层
    NSInteger ColorNumber;//当前颜色
    NSArray *OnImageArr;//对勾图片集合
    NSArray *OffImageArr;//颜色图片集合
    NSArray *DateRoomArr;//房间时间列表
    NSArray *SourcelistArr;//来源列表
    NSInteger SelectIndex;//显示第几行
    
    
}

@end

@implementation IuiueOrderDetailViewController
@synthesize StartDate,RoomId,Order;
/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"订单详情";
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(SaveOrder:)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(SaveOrder:)];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.Order) {
        self.navigationItem.title = @"添加订单";
    }
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //初始化
    
    DateArr = @[@"9月16日",@"9月17日",@"9月18日",@"9月19日",@"9月20日",@"9月21日",@"9月22日",@"9月23日",@"9月24日",@"9月25日",@"9月26日",@"9月27日",@"9月28日",@"9月29日",@"9月30日",@"10月1日",@"10月2日",@"10月3日",@"10月4日",@"10月5日",@"10月6日",@"10月7日",@"10月8日",@"10月9日"];
    roomArr = @[@"一号房",@"二号房",@"三号房",@"四号房",@"五号房"];
    timeArr = @[@"入住1晚",@"入住2晚",@"入住3晚",@"入住4晚",@"入住5晚",@"入住6晚",@"入住7晚",@"入住8晚",@"入住9晚",@"入住10晚",@"入住11晚",@"入住12晚",@"入住13晚",@"入住14晚",@"入住15晚",@"入住16晚",@"入住17晚",@"入住18晚",@"入住19晚",@"入住20晚",@"入住21晚",@"入住22晚",@"入住23晚",@"入住24晚",@"入住25晚"];
    PaidTypeArr = @[@"现金",@"刷卡"];
    NumberOfPeopleArr = @[@"入住1人",@"入住2人",@"入住3人",@"入住4人",@"入住5人",@"入住6人",@"入住7人",@"入住8人",@"入住9人"];
    OnImageArr = @[[UIImage imageNamed:@"orderbox1_select"],[UIImage imageNamed:@"orderbox2_select"],[UIImage imageNamed:@"orderbox3_select"],[UIImage imageNamed:@"orderbox4_select"],[UIImage imageNamed:@"orderbox5_select"],[UIImage imageNamed:@"orderbox6_select"],[UIImage imageNamed:@"orderbox7_select"],[UIImage imageNamed:@"orderbox8_select"],[UIImage imageNamed:@"orderbox9_select"],[UIImage imageNamed:@"orderbox10_select"],[UIImage imageNamed:@"orderbox11_select"]];
    OffImageArr = @[[UIImage imageNamed:@"orderbox1_nomal"],[UIImage imageNamed:@"orderbox2_nomal"],[UIImage imageNamed:@"orderbox3_nomal"],[UIImage imageNamed:@"orderbox4_nomal"],[UIImage imageNamed:@"orderbox5_nomal"],[UIImage imageNamed:@"orderbox6_nomal"],[UIImage imageNamed:@"orderbox7_nomal"],[UIImage imageNamed:@"orderbox8_nomal"],[UIImage imageNamed:@"orderbox9_nomal"],[UIImage imageNamed:@"orderbox10_nomal"],[UIImage imageNamed:@"orderbox11_nomal"]];
    
    Remarks = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 34)];
    Remarks.placeholder = @"请填写备注信息";
    Remarks.returnKeyType = UIReturnKeyDone;
    Remarks.keyboardType = UIKeyboardTypeNamePhonePad;

    Remarks.delegate = self;
    
    DateLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 105, 34)];
    DateLabel.textAlignment = NSTextAlignmentLeft;
    DateLabel.text = @"请选择";
    
    RoomLabel = [[UILabel alloc]initWithFrame:DateLabel.frame];
    RoomLabel.textAlignment = NSTextAlignmentLeft;
    RoomLabel.text = @"请选择";
    
    timeLabel = [[UILabel alloc]initWithFrame:DateLabel.frame];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.text = @"请选择";
    
    paidTypeLabel1 = [[UILabel alloc]initWithFrame:DateLabel.frame];
    paidTypeLabel1.textAlignment = NSTextAlignmentLeft;
    paidTypeLabel1.text = @"请选择";
    
    paidTypeLabel2 = [[UILabel alloc]initWithFrame:DateLabel.frame];
    paidTypeLabel2.textAlignment = NSTextAlignmentLeft;
    paidTypeLabel2.text = @"请选择";
    
    NumberOfPeopleLabel = [[UILabel alloc]initWithFrame:DateLabel.frame];
    NumberOfPeopleLabel.textAlignment = NSTextAlignmentLeft;
    NumberOfPeopleLabel.text = @"请选择";
    
    ColorNumber = 0;
    if (self.Order) {
        ColorNumber = [self.Order.OrderColor integerValue];
//        NSLog(@"%d,%@",ColorNumber,self.Order.UserName);
    }
    
    inTyPeArr = @[@"木鸟",@"艺龙",@"携程",@"途牛",@"自来客"];
    
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 64) style:UITableViewStyleGrouped];
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
/*
-(IBAction)SaveOrder:(id)sender{
    if(UserNameTF.text.length == 0){
        [self showAlertView:@"房客姓名不可为空"];
        return;
    }
    if(UserMoblieTF.text.length != 11){
        [self showAlertView:@"请输入11位合法手机号"];
        return;
    }
    Order *order = [[Order alloc]initWithStartDate:@"2014-01-12" roomid:@"70" price:@"100" numberOfNight:@"1"];
    IuiueOrder *oneOrder = [[IuiueOrder alloc]initWithUserName:@"王迪" OrderId:@"123" UserMobile:@"123423543534" NumberOfPeople:@"1222343454252452" PersonCount:@"t12" InType:@"1" OrderArr:nil AllForpaid:@"100" paidRent:@"20" paidType:@"1" Remarks:@"房客2" otherMoney:nil YJrent:@"12" YJrentType:@"0" OrderColor:@"1"];
    [_OrderDelegate getOrder:oneOrder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //根据Room是否为空来判断是添加房间还是查看房间
    if (Order == nil) {
        return 5;
    }
    return 5;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return 1;
    }
    else if(section == 0){
        return 3;
    }
    return 2;
}

//加载cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reusedidentify = [NSString stringWithFormat:@"%d:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusedidentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!Order) {
            //第一组
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            UserNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, 130, 34)];
                            UserMoblieTF = [[UITextField alloc]initWithFrame:CGRectMake(170, 5, 140, 34)];
                            UserMoblieTF.returnKeyType = UIReturnKeyDone;
                            UserMoblieTF.keyboardType = UIKeyboardTypeNamePhonePad;
                            UserNameTF.returnKeyType = UIReturnKeyDone;
                            UserNameTF.keyboardType = UIKeyboardTypeNamePhonePad;


                            UserNameTF.placeholder = @"姓名";
                            UserMoblieTF.placeholder = @"手机号";
                            UserNameTF.delegate = self;
                            UserMoblieTF.delegate = self;
                            [cell.contentView addSubview:UserMoblieTF];
                            [cell.contentView addSubview:UserNameTF];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 2:
                        {
                            cell.textLabel.text = @"渠道";
                            cell.textLabel.textColor = [UIColor blackColor];
                            InTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake( 60, 5, 225, 34)];
                            InTypeLabel.text = @"自来客";
                            InTypeLabel.textAlignment = NSTextAlignmentRight;
                            [cell addSubview:InTypeLabel];
//                            cell.detailTextLabel.text = @"自来客";
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
                            btn.tag = 1;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 108, 44)];
                            [cell1 addSubview:NumberOfPeopleLabel];
                            [cell1 setFrame:CGRectMake(0, 0, 108, 44)];
                            
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            ShenFenTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, 190, 34)];
                            ShenFenTF.placeholder = @"身份证号";
                            ShenFenTF.returnKeyType = UIReturnKeyDone;
                            ShenFenTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            ShenFenTF.delegate = self;
                            [cell.contentView addSubview:ShenFenTF];
                            
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 7;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(110, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];

                        }
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                    break;
                case 1:{
                    
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 2;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 3;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            [cell1 addSubview:DateLabel];
                            [cell2 addSubview:RoomLabel];
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            [cell1 addSubview:timeLabel];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            AllforPaidTF = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            AllforPaidTF.placeholder = @"请输入金额";
                            AllforPaidTF.text = @"";
                            AllforPaidTF.returnKeyType = UIReturnKeyDone;
                            AllforPaidTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            AllforPaidTF.delegate = self;
                            [cell.contentView addSubview:AllforPaidTF];
                            
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 4;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];

                        }
                            break;
                            
                        default:
                            break;
                    }

                    
                }
                    break;
                case 2:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.textLabel.text = @"支付房费";
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
//                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            TotalPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            TotalPriceTF.placeholder = @"请输入金额";
                            TotalPriceTF.returnKeyType = UIReturnKeyDone;
                            TotalPriceTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            TotalPriceTF.delegate = self;
                            [cell.contentView addSubview:TotalPriceTF];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                            
                            
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                             [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            cell1.textLabel.text = @"支付方式";
                            [cell2 addSubview:paidTypeLabel1];
//                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 5;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];

                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 3:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.textLabel.text = @"押金";
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            PaidRent = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            PaidRent.placeholder = @"请输入金额";
                            PaidRent.returnKeyType = UIReturnKeyDone;
                            PaidRent.keyboardType = UIKeyboardTypeNamePhonePad;

                            PaidRent.delegate = self;
                            [cell.contentView addSubview:PaidRent];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            cell1.textLabel.text = @"支付方式";
                            [cell2 addSubview:paidTypeLabel2];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 6;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 4:{
                    [cell addSubview:Remarks];
                }
                    
                    
                default:
                    break;
            }
        }
        else{
            //第一组
            switch (indexPath.section) {
                case 0:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            UserNameTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, 130, 34)];
                            UserMoblieTF = [[UITextField alloc]initWithFrame:CGRectMake(170, 5, 140, 34)];
                            UserNameTF.placeholder = @"姓名";
                            UserMoblieTF.placeholder = @"手机号";
                            UserNameTF.returnKeyType = UIReturnKeyDone;
                            UserNameTF.keyboardType = UIKeyboardTypeNamePhonePad;
                            UserMoblieTF.returnKeyType = UIReturnKeyDone;
                            UserMoblieTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            UserNameTF.delegate = self;
                            UserMoblieTF.delegate = self;
                            [cell.contentView addSubview:UserMoblieTF];
                            [cell.contentView addSubview:UserNameTF];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 2:
                        {
                            cell.textLabel.text = @"渠道";
                            cell.textLabel.textColor = [UIColor blackColor];
                            InTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake( 60, 5, 225, 34)];
                            InTypeLabel.text = @"自来客";
                            InTypeLabel.textAlignment = NSTextAlignmentRight;
                            [cell addSubview:InTypeLabel];
                            //                             cell.detailTextLabel.text = @"自来客";
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
                            btn.tag = 1;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 108, 44)];
                            [cell1 addSubview:NumberOfPeopleLabel];
                            [cell1 setFrame:CGRectMake(0, 0, 108, 44)];
                            
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            ShenFenTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 5, 190, 34)];
                            ShenFenTF.placeholder = @"身份证号";
                            ShenFenTF.returnKeyType = UIReturnKeyDone;
                            ShenFenTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            ShenFenTF.delegate = self;
                            [cell.contentView addSubview:ShenFenTF];
                            
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 7;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(110, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                            
                        }
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                    break;
                case 1:{
                    
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 2;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 3;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            [cell1 addSubview:DateLabel];
                            [cell2 addSubview:RoomLabel];
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            [cell1 addSubview:timeLabel];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            AllforPaidTF = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            AllforPaidTF.text = @"129";
                            AllforPaidTF.returnKeyType = UIReturnKeyDone;
                            AllforPaidTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            AllforPaidTF.delegate = self;
                            [cell.contentView addSubview:AllforPaidTF];
                            
                            UIButton *btn = [[UIButton alloc]initWithFrame:cell1.frame];
                            btn.tag = 4;
                            [btn addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    
                }
                    break;
                case 2:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.textLabel.text = @"支付房费";
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            TotalPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            TotalPriceTF.placeholder = @"请输入金额";
                            TotalPriceTF.returnKeyType = UIReturnKeyDone;
                            TotalPriceTF.keyboardType = UIKeyboardTypeNamePhonePad;

                            TotalPriceTF.delegate = self;
                            [cell.contentView addSubview:TotalPriceTF];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                            
                            
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            cell1.textLabel.text = @"支付方式";
                            [cell2 addSubview:paidTypeLabel1];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 5;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                            
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 3:{
                    switch (indexPath.row) {
                        case 0:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            cell1.textLabel.text = @"押金";
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            
                            [cell.contentView addSubview:cell1];
                            UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                            Y.text = @"￥";
                            [cell.contentView addSubview:Y];
                            PaidRent = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                            PaidRent.placeholder = @"请输入金额";
                            PaidRent.returnKeyType = UIReturnKeyDone;
                            PaidRent.keyboardType = UIKeyboardTypeNamePhonePad;

                            PaidRent.delegate = self;
                            [cell.contentView addSubview:PaidRent];
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                        case 1:
                        {
                            //添加两个小cell
                            UITableViewCell *cell1 = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 158, 44)];
                            UITableViewCell *cell2 = [[UITableViewCell alloc]initWithFrame:CGRectMake(162, 0, 158, 44)];
                            [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                            [cell2 setFrame:CGRectMake(162, 0, 158, 44)];
                            cell1.textLabel.text = @"支付方式";
                            [cell2 addSubview:paidTypeLabel2];
                            //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                            [cell.contentView addSubview:cell1];
                            [cell.contentView addSubview:cell2];
                            UIButton *btn1 = [[UIButton alloc]initWithFrame:cell2.frame];
                            btn1.tag = 6;
                            [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn1];
                            
                            //添加竖线
                            UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
                            [imV setFrame:CGRectMake(160, 0, 0.5f, 44)];
                            [cell.contentView addSubview:imV];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 4:{
                    [cell addSubview:Remarks];
                    
                }
                    
                    
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
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [MyTableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 300)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyView removeFromSuperview];
        [picker removeFromSuperview];
        picker = nil;
        MyView = nil;
    });
    [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT, 320, 260) During:0.3];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
     [MyTableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 64)];
    return YES;
}
//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:UserMoblieTF])
        
    {
        
        if ([aString length] > 11) {
            return NO;
        }
        
    }
    if ([textField isEqual:UserMoblieTF]||[textField isEqual:AllforPaidTF]||[textField isEqual:PaidRent]||[textField isEqual:TotalPriceTF]) {
        return [self validateNumber:string];
    }else if([textField isEqual:ShenFenTF]){
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (BOOL)validateWord:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
/*!
 @method
 @abstract 保存信息有误提醒
 */
-(void)showAlertView:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
//    if (indexPath ==index) {
//        id _id;
//       [ self ShowPickerView:_id];
//    }
//}

//显示pickerview
-(IBAction)ShowPickerView:(id)sender{
    [UserMoblieTF resignFirstResponder];
    [UserNameTF resignFirstResponder];
    [ShenFenTF resignFirstResponder];
    [AllforPaidTF resignFirstResponder];
    [TotalPriceTF resignFirstResponder];
    [PaidRent resignFirstResponder];
    [Remarks resignFirstResponder];
    
    [MyTableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 300)];
    UIButton *btn = (UIButton *)sender;
    if (!MyView) {
        MyView = [[UIView alloc]initWithFrame:CGRectMake(0, MY_HEIGHT, MY_WIDTH, 260)];
        MyView.backgroundColor = COLOR__BLUE;
//        UIButton *leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
//        [leftbtn setTitle:@"取消" forState:UIControlStateNormal];
//        leftbtn.tag = btn.tag;
//        [leftbtn addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
//        [MyView addSubview:leftbtn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
        label.textColor = COLOR__SIX;
        switch (btn.tag) {
            case 1:
                label.text = @"房客来源选择";
                break;
            case 2:
                label.text = @"入住日期选择";
                break;
            case 3:
                label.text = @"入住房间选择";
                break;
            case 4:
                label.text = @"入住天数选择";
                break;
            case 5:
                label.text = @"房费支付方式选择";
                break;
            case 6:
                label.text = @"押金支付方式选择";
                break;
            case 7:
                label.text = @"入住人数选择";
                break;
            default:
                break;
        }
//        [label sizeToFit];
        [MyView addSubview:label];
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
            [picker selectRow:SelectIndex inComponent:0 animated:YES];
            
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
        [MyTableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 64)];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    [self sendToGetDateArr];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (picker.tag) {
        case 1:
            for (int num = 0; num < SourcelistArr.count; num++) {
                NSDictionary *dic = SourcelistArr[num];
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"webname"]];
                if ([str isEqualToString:InTypeLabel.text]) {
                    SelectIndex = num;
                }
            }
            return SourcelistArr.count;
            break;
        case 2:
            for (int num = 0; num < DateRoomArr.count; num++) {
                NSDictionary *dic = DateRoomArr[num];
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                if ([str isEqualToString:DateLabel.text]) {
                    SelectIndex = num;
                }
            }
            return DateRoomArr.count;
            break;
        case 3:{
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    for (int num = 0; num<arr.count; num++) {
                        NSDictionary *dic2 = arr[num];
                        NSString *str2 = [NSString stringWithFormat:@"%@",dic2[@"roomtitle"]];
                        if ([str2 isEqualToString:RoomLabel.text]) {
                            SelectIndex = num;
                        }
                    }
                    return arr.count;
                }
            }
        }
            return 0;
            break;
        case 4:{
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    for (NSDictionary *dic2 in arr) {
                        NSString *str2 = dic2[@"roomtitle"];
                        if ([str2 isEqualToString:RoomLabel.text]) {
                            NSString *dayNum = [NSString stringWithFormat:@"%@",dic2[@"daymax"]];
                            SelectIndex = [numberOfNightStr integerValue] - 1;
                            return [dayNum integerValue];
                        }
                    }
                }
            }
    }
            return 0;
            break;
        case 5:
            SelectIndex = [paidTypeStr1 integerValue];
            return PaidTypeArr.count;
            break;
        case 6:
            SelectIndex = [paidTypeStr2 integerValue];
            return PaidTypeArr.count;
            break;
        case 7:
            SelectIndex = [NumberOfPeopleStr integerValue] - 1;
            return NumberOfPeopleArr.count;
            break;
            
        default:
            break;
    }
    return 0;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *arr;
    switch (picker.tag) {
        case 1:{
            NSDictionary *dic = SourcelistArr[row];
            NSString *str = [NSString stringWithFormat:@"%@",dic[@"webname"]];
            return str;
        }
            break;
        case 2:{
                NSDictionary *dic = DateRoomArr[row];
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                return str;
        }
            break;
        case 3:{
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    NSDictionary *dic2 = arr[row];
                    NSString *str2 = [NSString stringWithFormat:@"%@",dic2[@"roomtitle"]];
                    return str2;
                    
                }
            }

        }
            break;
        case 4:
        {
            NSString *str = [NSString stringWithFormat:@"入住%d晚",row+1];
            return str;
        }
            break;
        case 5:{
            arr = PaidTypeArr;
        }
            break;
        case 6:{
            arr = PaidTypeArr;
        }
            break;
        case 7:{
            arr =NumberOfPeopleArr;
        }
            break;
            
        default:
            break;
    }
    NSString *str = [NSString stringWithFormat:@"%@",arr[row]];
   return str;
}


//收起并隐藏pickerView
-(IBAction)hidePickerView:(id)sender{
    [MyTableView setFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 64)];
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        //线程动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [MyView removeFromSuperview];
//            [picker removeFromSuperview];
//            picker = nil;
//            MyView = nil;
            [picker selectRow:SelectIndex inComponent:0 animated:YES];
            
        });
//        [self.view MoveView:MyView To:CGRectMake(0, MY_HEIGHT, 320, 260) During:0.3];
    }
    else if([btn.titleLabel.text isEqualToString:@"确定"]){
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



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //    NSString *str = [NSString stringWithFormat:@"%@",arr[row]];
    switch (picker.tag) {
            
        case 1:
            InTypeLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            SourceStr = [NSString stringWithFormat:@"%d",row + 1];
            break;
        case 2:
            DateLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            startDateStr = DateLabel.text;
            [MyTableView reloadData];
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
        
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    NSDictionary *dic2 = arr[0];
                    RoomLabel.text = [NSString stringWithFormat:@"%@",dic2[@"roomtitle"]];
                    roomIdStr = [NSString stringWithFormat:@"%@",dic2[@"roomid"]];
                    timeLabel.text = @"入住1晚";
                    AllforPaidTF.text = [NSString stringWithFormat:@"%@",dic2[@"price"]];
                    numberOfNightStr = @"1";
                    break;
                }
            }

            break;
        case 3:
            RoomLabel.text= [self pickerView:pickerView titleForRow:row forComponent:component];
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    NSDictionary *dic2 = arr[row];
                    RoomLabel.text = [NSString stringWithFormat:@"%@",dic2[@"roomtitle"]];
                    roomIdStr = [NSString stringWithFormat:@"%@",dic2[@"roomid"]];
                    AllforPaidTF.text = [NSString stringWithFormat:@"%@",dic2[@"price"]];
                    timeLabel.text = @"入住1晚";
                    numberOfNightStr = @"1";
                    break;
                }
            }
            break;
        case 4:{
            timeLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            for (NSDictionary *dic in DateRoomArr) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                
                if ([str isEqualToString:DateLabel.text]) {
                    NSArray *arr = dic[@"list"];
                    for (NSDictionary *dic2 in arr) {
                        if ([RoomLabel.text isEqualToString:dic2[@"roomtitle"]]) {
                            AllforPaidTF.text = [NSString stringWithFormat:@"%.2f",[dic2[@"price"] floatValue] *(row + 1)];
                        }
                    }
                }
            }
            numberOfNightStr = [NSString stringWithFormat:@"%d",row + 1];
        }
            break;
        case 5:
            paidTypeLabel1.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            paidTypeStr1 = [NSString stringWithFormat:@"%d",row];
            break;
        case 6:
            paidTypeLabel2.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            paidTypeStr2 = [NSString stringWithFormat:@"%d",row];
            break;
        case 7:
            NumberOfPeopleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            NumberOfPeopleStr = [NSString stringWithFormat:@"%d",row + 1];
            break;
            
        default:
            break;
    }
}



-(void)SendToSaveRoom{
    if(UserNameTF.text.length == 0){
        [self showAlertView:@"房客姓名不可为空"];
        return;
    }
    if(UserMoblieTF.text.length != 11){
        [self showAlertView:@"请输入11位合法手机号"];
        return;
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ORDER]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    if (self.Order) {
        [request addPostValue:@"3" forKey:@"type"];
        [request addPostValue:self.Order.OrderId forKey:@"orderid"];
    }
    else{
    [request addPostValue:@"1" forKey:@"type"];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:roomIdStr,@"roomid",AllforPaidTF.text,@"price",numberOfNightStr,@"daynum",startDateStr,@"statime",nil];
    NSString *nid;
    for (NSDictionary *souceDic in SourcelistArr) {
        NSString *souceName = [NSString stringWithFormat:@"%@",souceDic[@"webname"]];
        NSString *souceId = [NSString stringWithFormat:@"%@",souceDic[@"nid"]];
        if ([InTypeLabel.text isEqualToString: souceName]) {
            nid = souceId;
            break;
        }
    }

//    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"71",@"roomid",@"10.00",@"price",@"1",@"daynum",@"2014-11-01",
//                         @"statime",nil];
    NSArray *arr = [NSArray arrayWithObjects:dic, nil];
    NSString *ColorNumberStr =[NSString stringWithFormat:@"%d",ColorNumber];
    NSDictionary *Info_list =[NSDictionary dictionaryWithObjectsAndKeys:ColorNumberStr,@"color",AllforPaidTF.text,@"allprice",TotalPriceTF.text,@"tprice",paidTypeStr1,@"payment",PaidRent.text,@"prepay",paidTypeStr2,@"prepayment",NumberOfPeopleStr,@"rennumber",UserNameTF.text,@"name",ShenFenTF.text,@"shenfen",UserMoblieTF.text,@"mobile",nid,@"source",Remarks.text,@"remark",arr,@"roomlist",nil];
    if ([NSJSONSerialization isValidJSONObject:Info_list])
    {
        NSString *stringl = [self dictionaryToJson:Info_list];
        NSLog(@"%@,%@,",stringl,uid);
        [request addPostValue:stringl forKey:@"info"];
    }else{
        [self.view makeToast:@"订单格式转换错误"];
    }
    
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:@"提交订单成功" duration:0.5 position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                        IuiueRoom *oneRoom = [[IuiueRoom alloc]initWithRoomId:@"" DayPrice:PriceField.text Remarks:Remarks.text RoomTitle:TitleField.text Status:[Status.text integerValue]];
                        //                        [_Roomdelegate getRoom:oneRoom];
                        [self.navigationController popViewControllerAnimated:YES];
                        
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
            NSLog(@"错误：%@",[error localizedDescription]);
            NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
            [self.view makeToast:str duration:0.5 position:@"center"];
        }
    }];
    [request setFailedBlock:^{
        [hud hide:YES];
        NSLog(@"错误：%@",[request.error localizedDescription]);
        
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
}

-(void)SendToSaveRoomRuzhu{
    if(UserNameTF.text.length == 0){
        [self showAlertView:@"房客姓名不可为空"];
        return;
    }
    if(UserMoblieTF.text.length != 11){
        [self showAlertView:@"请输入11位合法手机号"];
        return;
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MANAGE_ORDER]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:@"1" forKey:@"type"];
    [request addPostValue:@"1" forKey:@"status"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:roomIdStr,@"roomid",AllforPaidTF.text,@"price",numberOfNightStr,@"daynum",startDateStr,@"statime",nil];
    
    
    //    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"71",@"roomid",@"10.00",@"price",@"1",@"daynum",@"2014-11-01",
    //                         @"statime",nil];
    NSArray *arr = [NSArray arrayWithObjects:dic, nil];
    NSString *nid;
    for (NSDictionary *souceDic in SourcelistArr) {
        NSString *souceName = [NSString stringWithFormat:@"%@",souceDic[@"webname"]];
        NSString *souceId = [NSString stringWithFormat:@"%@",souceDic[@"nid"]];
        if ([InTypeLabel.text isEqualToString: souceName]) {
            nid = souceId;
            break;
        }
    }
    NSString *ColorNumberStr =[NSString stringWithFormat:@"%d",ColorNumber];
    NSDictionary *Info_list =[NSDictionary dictionaryWithObjectsAndKeys:ColorNumberStr,@"color",AllforPaidTF.text,@"allprice",TotalPriceTF.text,@"tprice",paidTypeStr1,@"payment",PaidRent.text,@"prepay",paidTypeStr2,@"prepayment",NumberOfPeopleStr,@"rennumber",UserNameTF.text,@"name",ShenFenTF.text,@"shenfen",UserMoblieTF.text,@"mobile",nid,@"source",Remarks.text,@"remark",arr,@"roomlist",nil];
    if ([NSJSONSerialization isValidJSONObject:Info_list])
    {
        NSString *stringl = [self dictionaryToJson:Info_list];
        NSLog(@"%@,%@,",stringl,uid);
        [request addPostValue:stringl forKey:@"info"];
    }else{
        [self.view makeToast:@"订单格式转换错误"];
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
                        [self.navigationController popViewControllerAnimated:YES];
                        
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
            NSLog(@"错误：%@",[error localizedDescription]);
            NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
            [self.view makeToast:str duration:0.5 position:@"center"];
        }
    }];
    [request setFailedBlock:^{
        [hud hide:YES];
        NSLog(@"错误：%@",[request.error localizedDescription]);
        
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *reusedidentify = [NSString stringWithFormat:@"%d",section];
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedidentify];
    [cell removeAllSubviews];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedidentify];
    }
    if (section == 3) {
        for (int num = 0; num<11; num++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(5 + num * 28, 9, 25, 25)];
            btn.tag = num;
            [btn addTarget:self action:@selector(ColorChose:) forControlEvents:UIControlEventTouchUpInside];
            
            if (ColorNumber==num) {
                [btn setImage:OnImageArr[num] forState:UIControlStateNormal];
            }
            else{
                [btn setImage:OffImageArr[num] forState:UIControlStateNormal];
            }
            [cell addSubview:btn];
        }
    }
    else if(section == 4){
        NSDate *date = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [[format stringFromDate:date] uppercaseString];
        if (!Order&&[dateString isEqualToString:startDateStr]) {
            UIButton *btnone = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, MY_WIDTH/3,40 )];
            [btnone setTitle:@"直接入住" forState:UIControlStateNormal];
            [btnone addTarget:self action:@selector(SendToSaveRoomRuzhu) forControlEvents:UIControlEventTouchUpInside];
            [btnone setBackgroundColor:COLOR__ARRAY[2]];
            btnone.layer.cornerRadius = 5.0f;
            [cell addSubview:btnone];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnone.right + 20, 10, MY_WIDTH - btnone.right - 40, 40)];
            [btn setTitle:@"提交订单" forState:UIControlStateNormal];
            [btn setBackgroundColor:COLOR__BLUE];
            btn.layer.cornerRadius = 5.0f;
            [btn addTarget:self action:@selector(SendToSaveRoom) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }else{
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, MY_WIDTH - 40, 40)];
            if (self.Order) {
                [btn setTitle:@"修改订单" forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"提交订单" forState:UIControlStateNormal];
            }
            [btn setBackgroundColor:COLOR__BLUE];
            btn.layer.cornerRadius = 5.0f;
            [btn addTarget:self action:@selector(SendToSaveRoom) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 43;
    }else if(section == 4){
        return 100;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 1;
}

-(IBAction)ColorChose:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIView *view = [btn superview];
    for (id _id in view.subviews) {
        if ([_id isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)_id;
            if (button.tag == ColorNumber) {
                [button setImage:OffImageArr[ColorNumber] forState:UIControlStateNormal];
                ColorNumber = btn.tag;
                [btn setImage:OnImageArr[ColorNumber] forState:UIControlStateNormal];
            }
        }
    }
}


-(void)sendToGetDateArr{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CHECK_ROOM]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    request.requestMethod = @"POST";
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    if (self.Order) {
        [request addPostValue:self.Order.OrderId forKey:@"orderid"];
        NSArray *listArr = self.Order.OrderArr;
        NSDictionary *LitleOrder = listArr[0];
        [request addPostValue:LitleOrder[@"statime"] forKey:@"statime"];
    }else{
        [request addPostValue:self.StartDate forKey:@"statime"];
    }
//    [request addPostValue:StartDate forKey:@"statime"];
//    [request addPostValue:@"70" forKey:@"roomid"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:
                {
//                    [self.view makeToast:@"获取日期成功"];
                    DateRoomArr = resultDict[@"info_list"];
                    SourcelistArr = resultDict[@"source_list"];
                    NSDictionary *sourceDic = SourcelistArr[0];
                    //编辑订单
                    if (self.Order) {
                        UserNameTF.text = self.Order.UserName;
                        UserMoblieTF.text = self.Order.UserMobile;
                        NumberOfPeopleLabel.text = [NSString stringWithFormat:@"入住%@人",self.Order.PersonCount];
                        NumberOfPeopleStr = self.Order.PersonCount;
                        ShenFenTF.text = self.Order.NumberOfPeople;
                        SourceStr = self.Order.InType;
                        for (NSDictionary *souceDic in SourcelistArr) {
                            NSString *souceId = [NSString stringWithFormat:@"%@",souceDic[@"nid"]];
                            if ([souceId isEqualToString: SourceStr]) {
                                InTypeLabel.text = [NSString stringWithFormat:@"%@",souceDic[@"webname"]];
                                break;
                            }
                        }
                        NSArray *listArr = self.Order.OrderArr;
                        NSDictionary *LitleOrder = listArr[0];
                        Order *oneOrder = [[Order alloc]initWithStartDate:LitleOrder[@"statime"] roomid:LitleOrder[@"roomid"] price:LitleOrder[@"price"] numberOfNight:LitleOrder[@"daynum"]];
                        timeLabel.text = [NSString stringWithFormat:@"入住%@晚",oneOrder.NumberOfNight];
                        numberOfNightStr = oneOrder.NumberOfNight;
                        
                        AllforPaidTF.text = oneOrder.Price;
                        DateLabel.text = oneOrder.startDate;
                        startDateStr = oneOrder.startDate;
                        for (NSDictionary *dic in DateRoomArr) {
                            NSString *str = [NSString stringWithFormat:@"%@",dic[@"statime"]];
                            if ([str isEqualToString:DateLabel.text]) {
                                NSArray *arr = dic[@"list"];
                                for (NSDictionary *roomDic in arr) {
                                    NSString *roomid = [NSString stringWithFormat:@"%@",roomDic[@"roomid"]];
                                    if ([roomid isEqualToString:oneOrder.roomId]) {
                                        RoomLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"roomtitle"]];
                                        roomIdStr = oneOrder.roomId;
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                        TotalPriceTF.text = self.Order.paidRent;
                        PaidRent.text = self.Order.YJrent;
                        paidTypeStr1 = self.Order.paidType;
                        paidTypeStr2 = self.Order.YJrentType;
                        if ([self.Order.paidType isEqualToString:@"0"]) {
                            paidTypeLabel1.text = @"现金";
                        }else{
                            paidTypeLabel1.text = @"刷卡";
                        }
                        if ([self.Order.YJrentType isEqualToString:@"0"]) {
                            paidTypeLabel2.text = @"现金";
                        }else{
                            paidTypeLabel2.text = @"刷卡";
                        }
//                        ColorNumber = [self.Order.OrderColor integerValue];
//                        UIView *view = [MyTableView dequeueReusableHeaderFooterViewWithIdentifier:@"3"];
//                        for (id _id in view.subviews) {
//                            if ([_id isKindOfClass:[UIButton class]]) {
//                                UIButton *button = (UIButton *)_id;
//                                if (button.tag == ColorNumber) {
//                                    [button setImage:OnImageArr[ColorNumber] forState:UIControlStateNormal];
//                                }else{
//                                    [button setImage:OffImageArr[ColorNumber] forState:UIControlStateNormal];
//                                }
//                            }
//                        }
                        Remarks.text = self.Order.Remarks;
                    }else{
                        //添加订单
                    //初始化房客来源
                    InTypeLabel.text = [NSString stringWithFormat:@"%@",sourceDic[@"webname"]];
                    SourceStr = @"1";
                    
                    NSDictionary *dateDic;
                        if (!self.StartDate) {
                            dateDic = DateRoomArr[7];
                        }
                        else{
                            for ( NSDictionary *littleDic in DateRoomArr ) {
                                if ([littleDic[@"statime"] isEqualToString:self.StartDate]) {
                                    dateDic = littleDic;
                                }
                            }
                        }
                    //开始时间
                    DateLabel.text = [NSString stringWithFormat:@"%@",dateDic[@"statime"]];
                    startDateStr =[NSString stringWithFormat:@"%@",dateDic[@"statime"]];
                    
                    NSArray *arr = dateDic[@"list"];
                        if (self.RoomId.length > 0) {
                            for (NSDictionary *roomdic in arr) {
                                if ([RoomId isEqualToString:roomdic[@"roomid"]]) {
                                    RoomLabel.text = roomdic[@"roomtitle"];
                                    roomIdStr = roomdic[@"roomid"];
                                    AllforPaidTF.text = [NSString stringWithFormat:@"%@",roomdic[@"price"]];
                                }
                            }
                        }else{
                            NSDictionary *roomdic = arr[0];
                            //房间
                            RoomLabel.text = roomdic[@"roomtitle"];
                            roomIdStr = roomdic[@"roomid"];
                            AllforPaidTF.text = [NSString stringWithFormat:@"%@",roomdic[@"price"]];
                        }
                    //入住天数
                    timeLabel.text = @"入住1晚";
                    numberOfNightStr = @"1";
                    //入住人数
                    NumberOfPeopleLabel.text = @"入住1人";
                    NumberOfPeopleStr = @"1";
                    
                    paidTypeLabel1.text = @"现金";
                    paidTypeStr1 = @"0";
                    paidTypeLabel2.text = @"现金";
                    paidTypeStr2 = @"0";
                    }
                    //编辑订单
                    
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
//    hud.labelText = @"加载中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 *转换json语句为NSString
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
