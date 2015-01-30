//
//  AboutViewController.m
//  日租帮
//
//  Created by macmini on 14-9-15.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>{
     UIWebView *phoneCallWebView;
}

@end

@implementation AboutViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于日租帮";
//    CGRect frame = [UIScreen mainScreen].bounds;
   // UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(frame.size.width/10, frame.size.height/10+ 100, 250, 132)];
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0,MY_WIDTH,MY_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;

    [self.view addSubview:tableview];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *table = @"table";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:table];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:table];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 1){
            cell.textLabel.text = @"网站:";
            cell.detailTextLabel.text = @"WWW.rizubang.com";
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"名称:";
            cell.detailTextLabel.text = @"日租帮";
        }else if (indexPath.row == 3){
//            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 100, 44)];
//            [button setTitle:@"检查版本更新" forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor colorWithRed:72.0/255 green:118.0/255 blue:255.0/255 alpha:1] forState:UIControlStateNormal];
//            [cell addSubview:button];
//            
//            button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
            cell.textLabel.text = @"版本:";
            cell.detailTextLabel.text = @"1.0";
        } else if (indexPath.row == 0){
            cell.textLabel.text =@"客服:";
            cell.detailTextLabel.text = @"0311-66560503";
           
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        CGRect frame = [UIScreen mainScreen].bounds;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 160)];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(frame.origin.x + 60, frame.origin.y + 15, 200, 100)];
        [view addSubview:image];
        image.image = [UIImage imageNamed:@"log"];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, frame.size.width, 30)];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = @"最实用  最简单  最便利  最牛";
       [lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    lable.textAlignment = UITextAlignmentCenter;
        [view addSubview:lable];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self number];
    }
        
}
-(void)number{
    NSString *phoneNum = @"0311-66560503";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的View 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
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
