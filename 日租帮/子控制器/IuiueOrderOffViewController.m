//
//  IuiueOrderOffViewController.m
//  日租帮
//
//  Created by 赵中良 on 14/10/24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueOrderOffViewController.h"

@interface IuiueOrderOffViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *MyTableView;
    UITextField *TotalPriceTF;
    UITextField *PaidRent;
    UILabel *paidTypeLabel1;
    UILabel *paidTypeLabel2;
    UITextView *Remarks;//备注
    UILabel *label;
    __weak ASIFormDataRequest *request;
    MBProgressHUD *hud;//透明指示层
    NSArray *RoomList;//接口获得
    UIStepper *MyStepper;//续租天数
    UILabel *XuzuLabel;//续租天数显示
}

@end

@implementation IuiueOrderOffViewController
@synthesize MyOrder;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 108) style:UITableViewStyleGrouped];
    paidTypeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 105, 34)];
    paidTypeLabel1.textAlignment = NSTextAlignmentLeft;
    paidTypeLabel1.text = @"现金";
    
    paidTypeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 105, 34)];
    paidTypeLabel2.textAlignment = NSTextAlignmentLeft;
    paidTypeLabel2.text = @"现金";
    Remarks = [[UITextView alloc]initWithFrame:CGRectMake(10, 2, 280, 95)];
    Remarks.delegate = self;
    Remarks.returnKeyType = UIReturnKeyDone;
    label = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 300, 30)];
    label.text = @"备注";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    RoomList = [NSArray array];
    
    
    XuzuLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 30)];
    XuzuLabel.text = @"续租1天";
    XuzuLabel.textAlignment = NSTextAlignmentCenter;
    XuzuLabel.font = [UIFont systemFontOfSize:14];
    
    MyStepper = [[UIStepper alloc]initWithFrame:CGRectMake(XuzuLabel.left, XuzuLabel.bottom + 10, 60, 30)];
    MyStepper.minimumValue = 1;
    MyStepper.maximumValue = 30- [MyOrder.numberOfDay integerValue];
    MyStepper.stepValue = 1;
    [MyStepper addTarget:self action:@selector(Stepperchanged:) forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 4:
        case 0:
            return 1;
            break;
            
        default:
            return 2;
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseidentify = [NSString stringWithFormat:@"%d:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseidentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                        cell.imageView.image =[UIImage imageNamed:@"orderbox1_nomal"];
                        cell.textLabel.text = MyOrder.UserName;
                        cell.detailTextLabel.text = MyOrder.UserMobile;
                        break;
                        
                    default:
                        cell.textLabel.text = @"数据加载错误";
                        break;
                }
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:{
                        if ([self.title isEqualToString:@"办理入住"]) {
                            NSArray *arr = MyOrder.OrderArr;
                            NSString *str;
                            for (NSDictionary *dic in arr) {
                                str = [NSString stringWithFormat:@"%@,%@入住,实住%@晚,￥%@",dic[@"roomtitle"],dic[@"statime"],dic[@"daynum"],dic[@"price"]];
                                
                            }
                            cell.textLabel.text = str;
                            cell.textLabel.numberOfLines = arr.count;
                            cell.textLabel.font = [UIFont systemFontOfSize:14];
                            
                        }else if ([self.title isEqualToString:@"办理退房"]){
                            NSArray *arr = RoomList;
                            NSString *str;
                            for (NSDictionary *dic in arr) {
                                str = [NSString stringWithFormat:@"%@,%@入住,实住%@晚,￥%@",dic[@"roomtitle"],dic[@"statime"],dic[@"trueday"],dic[@"trueprice"]];
                                
                            }
                            cell.textLabel.text = str;
                            cell.textLabel.numberOfLines = arr.count;
                            cell.textLabel.font = [UIFont systemFontOfSize:14];
                        }else{
                            NSArray *arr = MyOrder.OrderArr;
                            NSString *str;
                            for (NSDictionary *dic in arr) {
                                str = [NSString stringWithFormat:@"%@,%@入住,入住%@晚,￥%@\n续租%.0f天,续租房费￥%.0f",dic[@"roomtitle"],dic[@"statime"],dic[@"daynum"],dic[@"price"],MyStepper.value,[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value];
                                
                            }
                            cell.textLabel.text = str;
                            cell.textLabel.numberOfLines = 0;
                            cell.textLabel.font = [UIFont systemFontOfSize:14];
                            
                        }
                    }
                        break;
                    case 1:
                    {
                        if ([self.title isEqualToString:@"办理入住"]) {
                            NSDictionary *dic = MyOrder.OrderArr[0];
                            if ([MyOrder.AllForpaid floatValue]-[MyOrder.paidRent floatValue]>= 0) {
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%@\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥%.2f",MyOrder.AllForpaid,MyOrder.paidRent,MyOrder.YJrent,[MyOrder.AllForpaid floatValue]-[MyOrder.paidRent floatValue]];
                            }else{
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%@\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥0",MyOrder.AllForpaid,MyOrder.paidRent,MyOrder.YJrent];
                            }
                            
                        }else if ([self.title isEqualToString:@"办理退房"]){
                            NSDictionary *dic = RoomList[0];
                            if ([dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]>=0) {
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%@\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥%.2f",dic[@"trueprice"],MyOrder.paidRent,MyOrder.YJrent,[dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]];
                            }else{
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%@\n已收房费：￥%@\n已收押金：￥%@\n需退还房费：￥%.2f",dic[@"trueprice"],MyOrder.paidRent,MyOrder.YJrent,[MyOrder.paidRent floatValue]-[dic[@"trueprice"] floatValue]];
                            }
                        }else{
                            NSDictionary *dic = MyOrder.OrderArr[0];
                            if ([MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]>= 0) {
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%.0f\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥%.2f",[MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value,MyOrder.paidRent,MyOrder.YJrent,[MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]];
                            }else{
                                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%@\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥0",MyOrder.AllForpaid,MyOrder.paidRent,MyOrder.YJrent];
                            }
                            [cell addSubview:MyStepper];
                            [cell addSubview:XuzuLabel];
                        }
                        cell.textLabel.numberOfLines = 4;
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                    }
                        break;
                    default:
                        cell.textLabel.text = @"数据加载错误";
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
                        cell1.textLabel.text = @"应补交房费";
                        [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                        //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        [cell.contentView addSubview:cell1];
                        UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                        Y.text = @"￥";
                        [cell.contentView addSubview:Y];
                        TotalPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                        TotalPriceTF.placeholder = @"请输入金额";
                        if ([self.title isEqualToString:@"办理入住"]) {
                            if ([MyOrder.AllForpaid floatValue]-[MyOrder.paidRent floatValue]>= 0) {
                                TotalPriceTF.text = [NSString stringWithFormat:@"%.2f",[MyOrder.AllForpaid floatValue]-[MyOrder.paidRent floatValue]];
                            }else{
                                TotalPriceTF.text = [NSString stringWithFormat:@"0"];
                            }
                            
                        }else if([self.title isEqualToString:@"办理退房"])
                        {
                            NSDictionary *dic = RoomList[0];
                            if ([dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]>0) {
                                cell1.textLabel.text = @"应补交房费";
                                TotalPriceTF.text = [NSString stringWithFormat:@"%.2f",[dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]];
                            }else{
                                cell1.textLabel.text = @"需退还房费";
                                TotalPriceTF.text = [NSString stringWithFormat:@"%.2f",[MyOrder.paidRent floatValue]-[dic[@"trueprice"] floatValue]];
                            }
                            
                        }else{
                            NSDictionary *dic = MyOrder.OrderArr[0];
                            if ([MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]>= 0) {
                                cell1.textLabel.text = @"应补交房费";
                                TotalPriceTF.text = [NSString stringWithFormat:@"%.2f",[MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]];
                            }else{
                                cell1.textLabel.text = @"应补交房费";
                                TotalPriceTF.text = [NSString stringWithFormat:@"0"];
                            }

                        }
                        
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
                        btn1.tag = 1;
                        //                    [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
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
                        [cell1 setFrame:CGRectMake(0, 0, 158, 44)];
                        //                            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        [cell.contentView addSubview:cell1];
                        UILabel *Y = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 20, 34)];
                        Y.text = @"￥";
                        [cell.contentView addSubview:Y];
                        PaidRent = [[UITextField alloc]initWithFrame:CGRectMake(195, 5, 140, 34)];
                        PaidRent.placeholder = @"请输入金额";
                        if ([self.title isEqualToString:@"办理退房"]) {
                            cell1.textLabel.text = @"退还押金";
                        }else{
                            cell1.textLabel.text = @"补交押金";
                        }
                        PaidRent.text = MyOrder.YJrent;
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
                        btn1.tag = 2;
                        //                    [btn1 addTarget:self action:@selector(ShowPickerView:) forControlEvents:UIControlEventTouchUpInside];
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
                switch (indexPath.row) {
                    case 0:
                        [cell addSubview:Remarks];
                        [cell addSubview:label];
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }

    }
    
    if ([self.title isEqualToString:@"办理续租"]) {
        if (indexPath.section==1&&indexPath.row == 0) {
            NSArray *arr = MyOrder.OrderArr;
            NSString *str;
            for (NSDictionary *dic in arr) {
                str = [NSString stringWithFormat:@"%@,%@入住,入住%@晚,￥%@\n续租%.0f天,续租房费￥%.0f",dic[@"roomtitle"],dic[@"statime"],dic[@"daynum"],dic[@"price"],MyStepper.value,[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value];
                
            }
            cell.textLabel.text = str;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }else if(indexPath.section == 1&&indexPath.row ==1){
            NSDictionary *dic = MyOrder.OrderArr[0];
            if ([MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]>= 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%.0f\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥%.2f",[MyOrder.AllForpaid floatValue]+[dic[@"price"] floatValue]/[dic[@"daynum"] floatValue]* MyStepper.value,MyOrder.paidRent,MyOrder.YJrent,[MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"应收总计：￥%.0f\n已收房费：￥%@\n已收押金：￥%@\n需补交房费：￥0",[MyOrder.AllForpaid floatValue]+[dic[@"price"] floatValue]/[dic[@"daynum"] floatValue]* MyStepper.value,MyOrder.paidRent,MyOrder.YJrent];
            }
            
        }else if(indexPath.section == 2&&indexPath.row == 0){
            NSDictionary *dic = MyOrder.OrderArr[0];
            if ([MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]>= 0) {
                TotalPriceTF.text = [NSString stringWithFormat:@"%.2f",[MyOrder.AllForpaid floatValue]+[dic[@"price"] intValue]/[dic[@"daynum"] intValue]* MyStepper.value-[MyOrder.paidRent floatValue]];
            }else{
                TotalPriceTF.text = [NSString stringWithFormat:@"0"];
            }
        }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&&indexPath.row == 1) {
        return 100;
    }
    else if(indexPath.section == 4&&indexPath.row == 0){
        return 100;
    }
    else if(indexPath.section == 1&&indexPath.row == 0){
        return 55;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.5;
    }else if(section ==4){
        return 80;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0.5;
    }
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
    }
    if (section == 4) {
        UIButton *Certain = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH/5, 16, MY_WIDTH*0.6, 44)];
        [Certain setTitle:self.title forState:UIControlStateNormal];
        if ([self.title isEqualToString:@"办理退房"]) {
            [Certain addTarget:self action:@selector(SendToTurnOffOrder:) forControlEvents:UIControlEventTouchUpInside];
        }else if([self.title isEqualToString:@"办理入住"]){
            [Certain addTarget:self action:@selector(SendToTurnInOrder) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [Certain addTarget:self action:@selector(SendToTurnLongOrder) forControlEvents:UIControlEventTouchUpInside];
        }
        [Certain setBackgroundColor:COLOR__BLUE];
        Certain.layer.cornerRadius = 5.0f;
        [cell addSubview:Certain];
    }
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    label.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length >0) {
        label.hidden = YES;
    }else{
        label.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
    }else{
        return YES;
    }
    return NO;
}

-(void)SendToTurnOffOrder:(NSString *)OrderId{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_OFF]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    NSDictionary *dic =RoomList[0];

    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:dic[@"nid"] forKey:@"nid"];
    [request addPostValue:Remarks.text forKey:@"remark"];
    NSString *tprice;
    if ([dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]>0) {
        tprice = [NSString stringWithFormat:@"%.2f",[dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]];
    }else{
        tprice = [NSString stringWithFormat:@"%.2f",[dic[@"trueprice"] floatValue] - [MyOrder.paidRent floatValue]];
    }
    [request addPostValue:TotalPriceTF.text forKey:@"tprice"];
    NSString *prepay = [NSString stringWithFormat:@"-%@",PaidRent.text];
    [request addPostValue:prepay forKey:@"prepay"];
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

-(void)SendToTurnOffOrderInfo{
    if ([self.title isEqualToString:@"办理入住"]||[self.title isEqualToString:@"办理续租"]) {
        MyTableView.dataSource = self;
        MyTableView.delegate = self;
        [self.view addSubview:MyTableView];
    }
    else{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_OFF_INFO]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
//    NSDictionary *dic = MyOrder.OrderArr[0];
    
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
//    [request addPostValue:dic[@"nid"] forKey:@"nid"];
    [request addPostValue:MyOrder.OrderId forKey:@"orderid"];

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
                    RoomList = resultDict[@"roomlist"];
                    MyTableView.dataSource = self;
                    MyTableView.delegate = self;
                    [self.view addSubview:MyTableView];
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
}

-(void)SendToTurnInOrder{
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_IN]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    
    NSDictionary *dic = MyOrder.OrderArr[0];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:dic[@"nid"] forKey:@"nid"];
    [request addPostValue:Remarks.text forKey:@"remark"];
    [request addPostValue:TotalPriceTF.text forKey:@"addpay"];
    [request addPostValue:PaidRent.text forKey:@"addprepay"];
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
                        [self.navigationController popViewControllerAnimated:YES];
                    });                }
                    
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

-(void)SendToTurnLongOrder{
    
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ORDER_LONG]];
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    request.requestMethod = @"POST";
    
    NSDictionary *dic = MyOrder.OrderArr[0];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    NSString *numberOfDay = [NSString stringWithFormat:@"%.0f",MyStepper.value];
    [request addPostValue:numberOfDay forKey:@"daynum"];
    [request addPostValue:dic[@"nid"] forKey:@"nid"];
    [request addPostValue:Remarks.text forKey:@"remark"];
    [request addPostValue:TotalPriceTF.text forKey:@"addpay"];
    [request addPostValue:PaidRent.text forKey:@"addprepay"];
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
                        [self.navigationController popViewControllerAnimated:YES];
                    });                }
                    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self SendToTurnOffOrderInfo];
}

-(IBAction)Stepperchanged:(id)sender{
    XuzuLabel.text = [NSString stringWithFormat:@"续租%.0f天",MyStepper.value];
    
    [MyTableView reloadData];
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
