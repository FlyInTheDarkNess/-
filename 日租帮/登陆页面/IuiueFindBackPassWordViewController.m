//
//  IuiueFindBackPassWordViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueFindBackPassWordViewController.h"
#import "IuiueSecondPassWordViewController.h"
@interface IuiueFindBackPassWordViewController ()<UITextFieldDelegate>
{
    UITextField *MobileTextfield;
    UIButton *SendBtn;
    MBProgressHUD *hud;
    
}


@end

@implementation IuiueFindBackPassWordViewController

/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"忘记密码";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(BackTologin)];
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
    FirstLabel.text = @"1 输入手机号";
    FirstLabel.textColor = COLOR__BLUE;
    FirstLabel.textAlignment = NSTextAlignmentRight;
    SecondLabel.text = @" > 2 设置新密码";
    ThirdLabel.text = @"> 3 修改成功";
    FirstLabel.font = onefont;
    SecondLabel.font = onefont;
    ThirdLabel.font = onefont;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view addSubview:FirstLabel];
    [view addSubview:SecondLabel];
    [view addSubview:ThirdLabel];
    
    MobileTextfield = [[UITextField alloc]initWithFrame:CGRectMake(20, view.bottom + 20, MY_WIDTH - 40, 40)];
    MobileTextfield.borderStyle = UITextBorderStyleRoundedRect;
    MobileTextfield.placeholder = @"请输入11位手机号";
    MobileTextfield.returnKeyType = UIReturnKeyDone;
    MobileTextfield.keyboardType = UIKeyboardTypeNamePhonePad;
    MobileTextfield.delegate = self;
    [self.view addSubview:MobileTextfield];
    
    SendBtn = [[UIButton alloc]initWithFrame:CGRectMake(MobileTextfield.left, MobileTextfield.bottom + 20, MobileTextfield.width, 40)];
    [SendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [SendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    SendBtn.layer.cornerRadius = 5.0f;
    SendBtn.backgroundColor = COLOR__BLUE;
    [self.view addSubview:SendBtn];

    
    // Do any additional setup after loading the view.
}

-(void)BackTologin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [MobileTextfield resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)sendMessage:(id)sender{
    [MobileTextfield resignFirstResponder];
    if (MobileTextfield.text.length != 11) {
        [self.view makeToast:@"请输入合法11位手机号" duration:1.0f position:@"center"];
        return;
    }
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_SEND_MESSAGE]];
    request.requestMethod = @"POST";
    [request addPostValue:MobileTextfield.text forKey:@"usertel"];
    
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
                    IuiueSecondPassWordViewController *second = [[IuiueSecondPassWordViewController alloc]init];
                    second.MobileNumber = MobileTextfield.text;
                    [self.navigationController pushViewController:second animated:YES];
                    [second startTime];
                    
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
    hud.labelText = @"发送中...";
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
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
                [SendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                SendBtn.backgroundColor = COLOR__BLUE;
                SendBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [SendBtn setTitle:[NSString stringWithFormat:@"(%@)秒后可重新发送",strTime] forState:UIControlStateNormal];
                SendBtn.backgroundColor = [UIColor grayColor];
                SendBtn.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

//限定只能输入数字或字母
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self validateNumber:string];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
