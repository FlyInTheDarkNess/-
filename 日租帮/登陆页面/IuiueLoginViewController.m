//
//  IuiueLoginViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-4.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueLoginViewController.h"

#import "IuiueRoomViewController.h"
#import "IuiueOrderViewController.h"
#import "MyNavigationController.h"
#import "IuiueMainViewController.h"
#import "IuiueRegisterViewController.h"//注册账号
#import "IuiueFindBackPassWordViewController.h"//找回密码
#import "MYViewController.h"//我的类

//自定义tabbar的两个类
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

@interface IuiueLoginViewController ()<UITextFieldDelegate>
{
    UITextField *UserName;
    UITextField *PassWord;
    MBProgressHUD *hud;
}

@end

@implementation IuiueLoginViewController

@synthesize Tokens;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景颜色
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bizhi.jpeg"]];
    //logo图片初始化
    UIImageView *imV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"log"]];
    //logo设置frame
    [imV setFrame:CGRectMake(MY_WIDTH/2 - 110, 70, 220, 100)];
    //添加到视图上
    [self.view addSubview:imV ];
    
    
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/2 - 130, imV.bottom + 20, 40, 40)];
    userNameLabel.text = @"账号:";
    UILabel *passWordLabel  = [[UILabel alloc]initWithFrame:CGRectMake(userNameLabel.left, userNameLabel.bottom + 10, 40, 40)];
    passWordLabel.text = @"密码:";
    [self.view addSubview:userNameLabel];
    [self.view addSubview:passWordLabel];
    
    //初始化输入框及设置
    UserName = [[UITextField alloc]init];
    PassWord = [[UITextField alloc]init];
    UserName.keyboardType = UIKeyboardTypeNamePhonePad;
    PassWord.keyboardType = UIKeyboardTypeNamePhonePad;
    UserName.placeholder = @"请输入您的手机号";
    PassWord.placeholder = @"请输入您的密码";
    PassWord.secureTextEntry = YES;//设置保密
    UserName.text = MY_MOBILE;
    PassWord.text = MY_PASSWORD;
    [UserName setFrame:CGRectMake(userNameLabel.right, userNameLabel.top, 210, 40)];
    [PassWord setFrame:CGRectMake(passWordLabel.right, passWordLabel.top, UserName.width, UserName.height)];
    
    UserName.borderStyle = UITextBorderStyleRoundedRect;
    PassWord.borderStyle = UITextBorderStyleRoundedRect;
    
    
//    UIImageView *UserImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_phone"]];
//    UserName.leftViewMode = UITextFieldViewModeAlways;
//    UserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    UserName.leftView = UserImageV;
//    UIImageView *PassImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
//    PassWord.leftViewMode = UITextFieldViewModeAlways;
//    PassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    PassWord.leftView = PassImageV;
    UserName.returnKeyType = UIReturnKeyDone;
    PassWord.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:UserName];
    [self.view addSubview:PassWord];
    
    //设置输入框delegate
    UserName.delegate = self;
    PassWord.delegate = self;
    
    //登陆按钮初始化设置
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(PassWord.left + 10, PassWord.bottom + 20, PassWord.width - 40, 40)];
    loginBtn.layer.cornerRadius = 5.0f;
    [loginBtn setBackgroundColor:COLOR__BLUE];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //添加忘记密码 ，新用户注册button
    UIButton *LeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, MY_HEIGHT - 44, 70, 30)];
    [LeftBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    LeftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [LeftBtn setTitleColor:COLOR__BLUE forState:UIControlStateNormal];
    [LeftBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LeftBtn];
    UIButton *RightBtn = [[UIButton alloc]initWithFrame:CGRectMake(MY_WIDTH - 80, MY_HEIGHT - 44, 70, 30)];
    [RightBtn setTitle:@"新用户" forState:UIControlStateNormal];
    RightBtn.titleLabel.font = LeftBtn.titleLabel.font;
    [RightBtn setTitleColor:COLOR__BLUE forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)press:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([btn.titleLabel.text isEqualToString:@"登陆"]) {
        if (UserName.text.length != 11) {
            [self.view makeToast:@"请输入合法手机号" duration:1.0f position:@"center"];
            return;
        }
        if (PassWord.text.length < 4) {
            [self.view makeToast:@"请输入至少4位以上密码" duration:1.0f position:@"center"];
            return;
        }
        
        
/*        //自定义cell
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
//        alertView.delegate = self;
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", nil]];//添加按钮
        UIButton *buttom = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
        buttom.backgroundColor = [UIColor redColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
        [view addSubview:buttom];
        view.layer.cornerRadius = 5.0f;
        view.backgroundColor = [UIColor whiteColor];
        [alertView setContainerView:view];
        [alertView show];
     */
        
        [self loginToHome];
    }
    else if([btn.titleLabel.text isEqualToString:@"新用户"]){
        IuiueRegisterViewController *registerVC = [[IuiueRegisterViewController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }
    else if([btn.titleLabel.text isEqualToString:@"忘记密码"]){
        IuiueFindBackPassWordViewController *FBVC = [[IuiueFindBackPassWordViewController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:FBVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }
//    [self.view makeToast:[NSString stringWithFormat:@"您点击了%@",btn.titleLabel.text]];
}
/*
 *跳转到主页
*/
-(void)TurnToHome{
    
    //系统自带tabbar
//    UITabBarController *Tabbar = [[UITabBarController alloc]init];
//    Tabbar.delegate = self;
////    MJCollectionViewController *Main= [[MJCollectionViewController alloc]init];
//    IuiueMainViewController *Main = [[IuiueMainViewController alloc]init];
//    IuiueRoomViewController *room = [[IuiueRoomViewController alloc]init];
//    IuiueOrderViewController *order = [[IuiueOrderViewController alloc]init];
//    LlineViewController *line = [[LlineViewController alloc]init];
//    MYViewController *my  = [[MYViewController alloc]init];
//    UINavigationController *nav1 =[[UINavigationController alloc]initWithRootViewController:order];
//    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:room];
//    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:Main];
//    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:line];
//    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:my];
//    Tabbar.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
//    nav1.tabBarItem.title = @"订单";
//    nav1.tabBarItem.image = [UIImage imageNamed:@"order"];
//    nav2.tabBarItem.title = @"房间";
//    nav2.tabBarItem.image = [UIImage imageNamed:@"room"];
//    nav3.tabBarItem.title = @"日历";
//    nav3.tabBarItem.image = [UIImage imageNamed:@"canlendar"];
//    nav4.tabBarItem.title = @"统计";
//    nav4.tabBarItem.image = [UIImage imageNamed:@"count"];
//    nav5.tabBarItem.title = @"我的";
//    nav5.tabBarItem.image = [UIImage imageNamed:@"my"];
//    //设置程序进入先显示主页
//    [Tabbar setSelectedIndex:2];
//    [self presentViewController:Tabbar animated:YES completion:nil];
    
    //自定义tabbar

    IuiueMainViewController *Main = [[IuiueMainViewController alloc]init];
    IuiueRoomViewController *room = [[IuiueRoomViewController alloc]init];
    IuiueOrderViewController *order = [[IuiueOrderViewController alloc]init];
    LlineViewController *line = [[LlineViewController alloc]init];
    MYViewController *my  = [[MYViewController alloc]init];
    UINavigationController *nav1 =[[UINavigationController alloc]initWithRootViewController:order];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:room];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:Main];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:line];
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:my];
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[nav1, nav2,nav3,nav4,nav5]];
    
    //添加badage
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        NSString *badage = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
        [[nav5 rdv_tabBarItem] setBadgeValue:badage];
    }
//    nav1.tabBarItem.title = @"订单";
//    nav1.tabBarItem.image = [UIImage imageNamed:@"order"];
//    nav2.tabBarItem.title = @"房间";
//    nav2.tabBarItem.image = [UIImage imageNamed:@"room"];
//    nav3.tabBarItem.title = @"日历";
//    nav3.tabBarItem.image = [UIImage imageNamed:@"canlendar"];
//    nav4.tabBarItem.title = @"统计";
//    nav4.tabBarItem.image = [UIImage imageNamed:@"count"];
//    nav5.tabBarItem.title = @"我的";
//    nav5.tabBarItem.image = [UIImage imageNamed:@"my"];
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third",@"fourth",@"fifth"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    
    //判断iconBadgeNumber来决定跳转到主页还是提醒页
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [tabBarController setSelectedIndex:4];
        [my TurntoRemindView];
    }else{
    [tabBarController setSelectedIndex:2];
    }
    [self presentViewController:tabBarController animated:YES completion:nil];

}


//点击空白处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [PassWord resignFirstResponder];
    [UserName resignFirstResponder];
}

//点击return收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [PassWord resignFirstResponder];
    [UserName resignFirstResponder];
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if (tabBarController.selectedViewController == viewController) {
        return NO;
    } else {
        return YES;
    }
}


-(void)loginToHome{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_LOGIN]];
    [request addPostValue:UserName.text forKey:@"usertel"];
    [request addPostValue:PassWord.text forKey:@"userpwd"];
    [request addPostValue:Tokens forKey:@"tokens"];
    [request setCompletionBlock:^{
        [hud hide:YES];//隐藏hud
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        NSString *str = [NSString stringWithFormat:@"%@",dic[@"code"]];
        if ([str isEqualToString:@"1"]) {
            NSString *str = [NSString stringWithFormat:@"%@",MY_UID];
            if (str.length > 0) {
                [iuiueCHKeychain delete:KEYCHAIN_USERNAMEPASSWORD];
            }
            NSLog(@"%@",dic);
            [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
            [usernamepasswordKVPairs setObject:[dic valueForKey:@"uid"] forKey:KEYCHAIN_UID];
            [usernamepasswordKVPairs setObject:dic[@"zend"] forKey:KEYCHAIN_ZEND];
            [usernamepasswordKVPairs setObject:dic[@"utel"] forKey:KEYCHAIN_MOBILE];
            [usernamepasswordKVPairs setObject:dic[@"uname"] forKey:KEYCHAIN_OWNERNAME];
            [usernamepasswordKVPairs setObject:dic[@"upwd"] forKey:KEYCHAIN_PASSWORD];
            [iuiueCHKeychain save:KEYCHAIN_USERNAMEPASSWORD data:usernamepasswordKVPairs];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self TurnToHome];//跳转到主页
            });
        }
        else{
            [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
        }
    }];
    [request setFailedBlock:^{
        [hud hide:YES];
        [self.view makeToast:@"网络连接失败，请检查网络设置" duration:1 position:@"center"];
    }];
    hud =
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hideToastActivity];
    hud.labelText = @"正在登陆，请稍候";
    [request startAsynchronous];

}

//限定只能输入数字或字母
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:UserName]) {
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
