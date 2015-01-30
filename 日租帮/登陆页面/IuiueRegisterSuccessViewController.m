//
//  IuiueRegisterSuccessViewController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-24.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueRegisterSuccessViewController.h"

@interface IuiueRegisterSuccessViewController (){
    
}

@end

@implementation IuiueRegisterSuccessViewController
@synthesize MobileNumber,PassWord;
/**
 *  初始化
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"注册成功";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //三个标题
    UILabel *FirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH/3, 40)];
    UILabel *SecondLabel = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/3, FirstLabel.top, MY_WIDTH/3, 40)];
    UILabel *ThirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH/3*2, FirstLabel.top, MY_WIDTH/3, 40)];
    UIFont *onefont = [UIFont systemFontOfSize:14];
    FirstLabel.text = @"1 输入手机号 >";
    FirstLabel.textAlignment = NSTextAlignmentRight;
    SecondLabel.text = @"2 设置密码  >";
    SecondLabel.textAlignment = NSTextAlignmentCenter;
    ThirdLabel.text = @" 3 注册成功";
    ThirdLabel.textColor = COLOR__BLUE;
    FirstLabel.font = onefont;
    SecondLabel.font = onefont;
    ThirdLabel.font = onefont;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view addSubview:FirstLabel];
    [view addSubview:SecondLabel];
    [view addSubview:ThirdLabel];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, view.bottom + 40, MY_WIDTH - 80, 60)];
    label.text = @"\t恭喜您注册成功，请妥善保管您的账号密码";
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40, label.bottom + 20, MY_WIDTH - 80, 40)];
    btn.layer.cornerRadius = 5.0f;
    [btn addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"返回登陆界面" forState:UIControlStateNormal];
    btn.backgroundColor = COLOR__BLUE;
    
    [self.view addSubviews:@[label,btn]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//返回登陆页面
-(IBAction)backToLogin:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
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
