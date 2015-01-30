//
//  FeedbackViewController.m
//  日租帮
//
//  Created by macmini on 14-9-19.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>{
    UITextField *textfiled;
    UITextView *content_textview;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    CGRect frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 20, frame.origin.y +10, 170, 30)];
    [self.view addSubview:lable];
    lable.text = @"尊敬的用户您好:";
    lable.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    [lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    UILabel *speek_lable = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 35, frame.origin.y + 50, 250, 30)];
    speek_lable.text = @"    我们很乐意分享您的感受，欢迎提出意见和建议，我们会认真对待您的反馈，感谢您的关注和支持。我们将参考您的建议来改善服务.";
    speek_lable.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    speek_lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    speek_lable.alpha = 0.7;
    speek_lable.numberOfLines = 0;
    [speek_lable sizeToFit];
    [speek_lable setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [self.view addSubview:speek_lable];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 20, frame.origin.y + 170, 80, 30)];
    content.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    [content setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [self.view addSubview:content];
    content.text = @"联系方式:";
    
    ////添加联系方式的textfiled
    textfiled = [[UITextField alloc]initWithFrame:CGRectMake(frame.origin.x + 100, frame.origin.y + 170, 200, 30)];
    [self.view addSubview:textfiled];
    textfiled.layer.borderColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1].CGColor;
    textfiled.layer.borderWidth = 1;
    textfiled.placeholder = @"请输入您的手机号/可为空";
    textfiled.layer.cornerRadius = 5.0f;
    textfiled.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    textfiled.delegate = self;
    
    UILabel *lable_text = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x + 20, frame.origin.y + 210, 80, 30)];
    lable_text.textColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    [lable_text setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [self.view addSubview:lable_text];
    lable_text.text = @"详细描述:";
    
    //添加内容的textview
    content_textview = [[UITextView alloc]initWithFrame:CGRectMake(frame.origin.x + 20, frame.origin.y + 245, 280, 110)];
    content_textview.layer.borderColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1].CGColor;
    content_textview.layer.borderWidth = 1;
    content_textview.layer.cornerRadius = 5.0f;
    content_textview.delegate = self;
    [self.view addSubview:content_textview];
    
    //初始化提交的按钮
    UIButton *button_phone = [[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x + 85, frame.origin.y + 370, 150, 40)];
    [self.view addSubview:button_phone];
    button_phone.layer.masksToBounds = YES;
    button_phone.layer.cornerRadius = 5;
    button_phone.backgroundColor = [UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1];
    [button_phone setTitle:@"提交" forState:UIControlStateNormal];
    [button_phone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_phone addTarget:self action:@selector(Sure) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
-(void)Sure{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/feedback"]];
    [request addPostValue:MY_UID forKey:@"userid"];
    [request addPostValue:MY_ZEND forKey:@"zend"];
    [request addPostValue:textfiled.text forKey:@"contact"];
    [request addPostValue:content_textview.text forKey:@"content"];
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"网络连接异常......");
    }];
    [request startAsynchronous];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textfiled resignFirstResponder];
    [content_textview resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = [UIScreen mainScreen].bounds;
    [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 100, frame.size.width, frame.size.height)];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
     CGRect frame = [UIScreen mainScreen].bounds;
    [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y + 60, frame.size.width, frame.size.height)];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    CGRect frame = [UIScreen mainScreen].bounds;
    [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y +60, frame.size.width,frame.size.height)];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = [UIScreen mainScreen].bounds;
    [self.view setFrame:CGRectMake(frame.origin.x, frame.origin.y - 160, frame.size.width, frame.size.height)];
}
-(void)viewWillAppear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

    // Dispose of any resources that can be recreated.
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
