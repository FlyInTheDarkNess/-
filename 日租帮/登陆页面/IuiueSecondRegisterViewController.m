//
//  IuiueSecondRegisterViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueSecondRegisterViewController.h"
#import "IuiueRegisterSuccessViewController.h"

@interface IuiueSecondRegisterViewController ()<UITextFieldDelegate>
{
    UITextField *YanZhengMaTextfeild;
    UIButton *SendBtn;
    UITextField *FirstPassword;
    UITextField *SecondPassword;
    UIScrollView *MyScrollView;
    UILabel *faultLabel;//确认密码错误
    MBProgressHUD *hud;//透明指示层
}

@end

@implementation IuiueSecondRegisterViewController
@synthesize MobileNumber;
/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"设置密码";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"获取验证码" style:UIBarButtonItemStyleBordered target:self action:@selector(sendYanZheng:)];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bizhi.jpeg"]];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //三个标题
    UILabel *FirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH/3, 40)];
    UILabel *SecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/3, FirstLabel.top, MY_WIDTH/3, 40)];
    UILabel *ThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/3*2, FirstLabel.top, MY_WIDTH/3, 40)];
    UIFont *onefont = [UIFont systemFontOfSize:14];
    FirstLabel.text = @"1 输入手机号 >";
    FirstLabel.textAlignment = NSTextAlignmentRight;
    SecondLabel.text = @"2 设置密码";
    SecondLabel.textAlignment = NSTextAlignmentCenter;
    ThirdLabel.text = @"> 3 注册成功";
    SecondLabel.textColor = COLOR__BLUE;
    FirstLabel.font = onefont;
    SecondLabel.font = onefont;
    ThirdLabel.font = onefont;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view addSubview:FirstLabel];
    [view addSubview:SecondLabel];
    [view addSubview:ThirdLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, MY_WIDTH - 40, 15)];
    NSString *OneStr = [self.MobileNumber substringToIndex:3];
    NSString *TwoStr = [self.MobileNumber substringFromIndex:7];
    label.text = [NSString stringWithFormat:@"验证码短信已经发送到%@****%@",OneStr,TwoStr];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    YanZhengMaTextfeild = [[UITextField alloc]initWithFrame:CGRectMake(100, label.bottom + 20, MY_WIDTH - 120, 40)];
    YanZhengMaTextfeild.borderStyle = UITextBorderStyleRoundedRect;
    YanZhengMaTextfeild.placeholder = @"请输入短信中的验证码";
    YanZhengMaTextfeild.returnKeyType = UIReturnKeyDone;
    YanZhengMaTextfeild.keyboardType = UIKeyboardTypeNamePhonePad;
    YanZhengMaTextfeild.delegate = self;
   
    
    
    FirstPassword = [[UITextField alloc]initWithFrame:CGRectMake(YanZhengMaTextfeild.left, YanZhengMaTextfeild.bottom + 20, YanZhengMaTextfeild.width, YanZhengMaTextfeild.height)];
    
    SecondPassword = [[UITextField alloc]initWithFrame:CGRectMake(FirstPassword.left, FirstPassword.bottom + 20, FirstPassword.width, FirstPassword.height)];
    FirstPassword.borderStyle = UITextBorderStyleRoundedRect;
    SecondPassword.borderStyle = UITextBorderStyleRoundedRect;
    FirstPassword.returnKeyType = UIReturnKeyDone;
    SecondPassword.returnKeyType = UIReturnKeyDone;
    FirstPassword.keyboardType = UIKeyboardTypeNamePhonePad;
    SecondPassword.keyboardType = UIKeyboardTypeNamePhonePad;
    FirstPassword.secureTextEntry = YES;
    SecondPassword.secureTextEntry = YES;
    FirstPassword.delegate = self;
    SecondPassword.delegate = self;
    FirstPassword.placeholder = @"请设置6位以上的密码";
    SecondPassword.placeholder = @"请再次输入密码";
    
    
    SendBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, SecondPassword.bottom + 20, MY_WIDTH - 80, 40)];
    [SendBtn setTitle:@"注册" forState:UIControlStateNormal];
    [SendBtn addTarget:self action:@selector(TurnToSuccess:) forControlEvents:UIControlEventTouchUpInside];
    SendBtn.layer.cornerRadius = 5.0f;
    SendBtn.backgroundColor = COLOR__BLUE;
    

    UILabel *YanzhengLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, YanZhengMaTextfeild.top, 80, YanZhengMaTextfeild.height)];
    YanzhengLabel.text = @"验证码：";
    YanzhengLabel.font = [UIFont systemFontOfSize:15];
    UILabel *PasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, FirstPassword.top, YanzhengLabel.width, YanzhengLabel.height)];
    PasswordLabel.text = @"设置密码：";
    PasswordLabel.font = [UIFont systemFontOfSize:15];
    UILabel *CertainLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, SecondPassword.top, PasswordLabel.width, PasswordLabel.height)];
    CertainLabel.text = @"确认密码：";
    CertainLabel.font = [UIFont systemFontOfSize:15];
    
    faultLabel = [[UILabel alloc]initWithFrame:CGRectMake(FirstPassword.left, FirstPassword.bottom, FirstPassword.width, 20)];
    faultLabel.text = @"两次输入的密码不同，请重新输入";
    faultLabel.font = [UIFont systemFontOfSize:10];
    faultLabel.textAlignment = NSTextAlignmentRight;
    faultLabel.textColor = [UIColor redColor];
    faultLabel.hidden = YES;
    
    MyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, view.bottom, MY_WIDTH, MY_HEIGHT - view.bottom)];
    [MyScrollView addSubviews:@[label,YanZhengMaTextfeild,FirstPassword,SecondPassword,SendBtn,YanzhengLabel,PasswordLabel,CertainLabel,faultLabel]];
    [MyScrollView setContentSize:CGSizeMake(MY_WIDTH, SendBtn.bottom + 20)];
    [self.view addSubview:MyScrollView];

    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (FirstPassword.text.length > 0&&SecondPassword.text.length > 0 &&![FirstPassword.text isEqualToString:SecondPassword.text]) {
        faultLabel.hidden = NO;
    }else{
        faultLabel.hidden = YES;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:FirstPassword]||[textField isEqual:SecondPassword]) {
        faultLabel.hidden = YES;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [MyScrollView setFrame:CGRectMake(0, 40, MY_WIDTH, MY_HEIGHT - 320)];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [ MyScrollView setFrame:CGRectMake(0, 40, MY_WIDTH, MY_HEIGHT - 40)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)TurnToSuccess:(id)sender{
    if (YanZhengMaTextfeild.text.length != 4) {
        [self.view makeToast:@"请填写正确的4位验证码" duration:0.5f position:@"center"];
        return;
    }
    if (FirstPassword.text.length < 4) {
        [self.view makeToast:@"请设置至少4位密码" duration:0.5f position:@"center"];
        return;
    }
    if (SecondPassword.text.length == 0) {
        [self.view makeToast:@"确认密码不能为空" duration:0.5f position:@"center"];
        return;
    }
    if (![FirstPassword.text isEqualToString:SecondPassword.text]) {
        [self.view makeToast:@"两次设置的密码不同，请重新设置" duration:0.5f position:@"center"];
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REGISTER]];
    request.requestMethod = @"POST";
    [request addPostValue:MobileNumber forKey:@"usertel"];
    [request addPostValue:YanZhengMaTextfeild.text forKey:@"usercode"];
    [request addPostValue:SecondPassword.text forKey:@"userpwd"];
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:
                {
                    
                    [self.view makeToast:@"注册成功" duration:0.5f position:@"center"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        IuiueRegisterSuccessViewController *success = [[IuiueRegisterSuccessViewController alloc]init];
                        [self.navigationController pushViewController:success animated:YES];
                    });
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:0.5 position:@"center"];
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

-(IBAction)sendYanZheng:(id)sender{
    [self sendMessage];
}

-(void)startTime{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.navigationItem.rightBarButtonItem.title =[NSString stringWithFormat:@"获取验证码"];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                self.navigationItem.rightBarButtonItem.title =[NSString stringWithFormat:@"(%@)秒",strTime];
                self.navigationItem.rightBarButtonItem.enabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

-(void)sendMessage{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_SEND_MESSAGE]];
    request.requestMethod = @"POST";
    [request addPostValue:self.MobileNumber forKey:@"usertel"];
    
    [request setCompletionBlock:^{
        [hud hide:YES];
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
                    [self.view makeToast:@"验证码已发送，请注意查收" duration:1.0f position:@"center"];
                    [self startTime];
                }
                    break;
                default:
                {
                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                    [self.view makeToast:str duration:1.0f position:@"center"];
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


//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:YanZhengMaTextfeild]) {
        return [self validateNumber1:string];
    }
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
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
- (BOOL)validateNumber1:(NSString*)number {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
