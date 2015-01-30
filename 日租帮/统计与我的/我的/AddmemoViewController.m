//
//  AddmemoViewController.m
//  XXX
//
//  Created by macmini on 14-8-22.
//  Copyright (c) 2014年 macmini. All rights reserved.
//

#import "AddmemoViewController.h"


@interface AddmemoViewController ()<UITextViewDelegate>{
    UITextView *textview;
    UIBarButtonItem *rightButton;
}

@end

@implementation AddmemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
        self.navigationItem.rightBarButtonItem = rightButton;
        
        self.navigationController.title = @"添加备忘录";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = [UIScreen mainScreen].bounds;
    textview = [[UITextView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y+34, frame.size.width, frame.size.height-64)];
    textview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:textview];
    textview.delegate = self;
    textview.font = [UIFont systemFontOfSize:16];
    textview.returnKeyType = UIReturnKeyDefault;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [textview becomeFirstResponder];
});
    NSData *date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
   NSDateComponents*comps;
    comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
            
                       fromDate:date];
    
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)[comps hour]];//[comps hour];
    NSString *hou;
    if(hour.length == 1){
        hou = [NSString stringWithFormat:@"0%@",hour];
    }else{
        hou = [NSString stringWithFormat:@"%@",hour];
    }
    
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)[comps minute]];//[comps minute];
    NSString *min;
    if(minute.length == 1){
        min = [NSString stringWithFormat:@"0%@",minute];
    }else{
        min = [NSString stringWithFormat:@"%@",minute];
    }
   
    
    NSString *second = [NSString stringWithFormat:@"%ld",(long)[comps second]];//[comps second];
    NSString *secon;
    if(second.length == 1){
        secon = [NSString stringWithFormat:@"0%@",second];
    }else{
        secon = [NSString stringWithFormat:@"%@",second];
    }
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit)
            
                       fromDate:date];
    
    NSInteger year = [comps year];
    
    NSInteger month = [comps month];
    
    NSInteger day = [comps day];
    
    
    UITextField *textfile = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    textfile.text = [NSString stringWithFormat:@"%ld年%ld月%ld日%@:%@:%@",(long)year,(long)month,(long)day,hou,min,secon];
    textfile.textAlignment = UITextAlignmentCenter;
    textfile.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:textfile];
    
    // Do any additional setup after loading the view.
}

-(void)finish{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *info = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"array"]];
//    
//    if(info == nil && info.count == 0){
//        info = [NSMutableArray array];
//    }
//    [info addObject:textview.text];
//    
//    NSData *string = [NSKeyedArchiver archivedDataWithRootObject:info];
//    [userDefaults setObject:string forKey:@"array"];
//     
//    NSLog(@"%@",string);
//    //这里建议同步存储到磁盘中，但是不是必须的
//    [userDefaults synchronize];

    if(textview.text.length == 0){
        [self.view makeToast:@"输入不合法" duration:1 position:@"center"];
        return;
    }
    NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
    NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/book"]];
    [request addPostValue:uid forKey:@"userid"];
    [request addPostValue:zend forKey:@"zend"];
    [request addPostValue:@"1" forKey:@"type"];
    [request addPostValue:textview.text forKey:@"content"];
    [request setCompletionBlock:^{
        self.navigationItem.rightBarButtonItem = rightButton;
        NSLog(@"%@",request.responseString);
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
         textview.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [request setFailedBlock:^{
        [self.view makeToast:@"网络链接异常..." duration:1 position:@"center"];
    }];
    [request startAsynchronous];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
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
