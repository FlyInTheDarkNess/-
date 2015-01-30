//
//  Memo_detailViewController.m
//  日租帮
//
//  Created by macmini on 14-10-8.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "Memo_detailViewController.h"

@interface Memo_detailViewController ()<UITextViewDelegate>{
    UIBarButtonItem *rightButton;
    UITextView *textview;
    MBProgressHUD *hud;
}
@end

@implementation Memo_detailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.navigationItem.title = @"修改备忘录";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //显示内容的textview
    textview =[[UITextView alloc]initWithFrame:CGRectMake(0, frame.origin.y + 34, frame.size.width, frame.size.height)];
    textview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textview.font = [UIFont systemFontOfSize:16];
    textview.delegate = self;dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textview becomeFirstResponder];
});
    [self.view addSubview:textview];
    //显示时间的textfile
    UITextField *textfile = [[UITextField alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, 30)];
    textfile.backgroundColor = [UIColor groupTableViewBackgroundColor];
    textfile.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:textfile];
    
    textfile.text = _date;
    textview.text = [NSString stringWithFormat:@"%@",_content];
    // Do any additional setup after loading the view.
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
-(void)finish{
    [textview resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/book"]];
    [request addPostValue:uid forKey:@"uid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:@"3" forKey:@"type"];
    [request addPostValue:_nid forKey:@"nid"];
    [request addPostValue:textview.text forKey:@"content"];
    [request setCompletionBlock:^{
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
        [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
    }];
    [request setFailedBlock:^{
        [self.view makeToast:@"网络链接异常......" duration:1 position:@"center"];
    }];
    [request startAsynchronous];
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
