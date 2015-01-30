//
//  MYViewController.m
//  XXX
//
//  Created by macmini on 14-8-19.
//  Copyright (c) 2014年 macmini. All rights reserved.
//

#import "MYViewController.h"
#import "IuiuesourceViewController.h"
@interface MYViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>{
    UITableView *tableview;
    CGRect frame;
    UITextField *textfiled;
    UITextField *textfiled1;
//    BOOL CanUpdates;//是否有新版本
}

@end

@implementation MYViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       
                                       initWithTitle:@"返回"
                                       
                                       style:UIBarButtonItemStylePlain
                                       
                                       target:self
                                       
                                       action:nil];
               self.navigationItem.backBarButtonItem = backButton;
        self.title = @"我的";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    #define kSCNavBarImageTag 10
//    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        //if iOS 5.0 and later
//        [navBar setBackgroundImage:[UIImage imageNamed:@"3.png"] forBarMetrics:UIBarMetricsDefault];
//    }
//    else
//    {
//        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
//        if (imageView == nil)
//        {
//            imageView = [[UIImageView alloc] initWithImage:
//                         [UIImage imageNamed:@"3.png"]];
//            [imageView setTag:kSCNavBarImageTag];
//            [navBar insertSubview:imageView atIndex:0];
//        }  
//    }
    
    
    //tableview  的加载  的加载  的加载
//    textfiled =[[UITextField alloc]init];
    tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    frame = [UIScreen mainScreen].bounds;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT - 108) style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview.delegate = self;
    tableview.dataSource = self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 5;
        }
            break;
        case 2:{
            return 3;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
-(void)viewWillAppear:(BOOL)animated{
//    CanUpdates = NO;
    [tableview reloadData];
    self.navigationController.navigationBar.translucent = NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *table = [NSString stringWithFormat:@"%d:%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:table];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
    }
//      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (section) {
        case 0:{
//            cell.backgroundColor = [UIColor colorWithRed:65.0/255 green:105.0/225 blue:255.0/255 alpha:1];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:table];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
           UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-200, 0, 170, 50)];
           [cell addSubview:lable];
//            [lable setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
            lable.textColor = [UIColor blackColor];
            lable.textAlignment = NSTextAlignmentRight;
            lable.text = MY_OWNERNAME;
           NSString *uname = @"用户名";
            cell.textLabel.text = uname;
            cell.imageView.image = [UIImage imageNamed:@"Username"];
//            [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
//            cell.textLabel.textColor = [UIColor grayColor];
        }
            break;
         case 1:
          
            if(row == 0){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:table];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(MY_WIDTH - 60, 15, 20, 20)];
                
                label.backgroundColor = [UIColor redColor];
                label.textColor = [UIColor whiteColor];
                if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
                    NSString *str = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
                    label.text = str;
                    label.hidden = NO;
                }else{
                    label.hidden = YES;
                }
                [cell.contentView addSubview:label];
                label.layer.masksToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.cornerRadius = 10.0f;
                cell.imageView.image = [UIImage imageNamed:@"提醒25"];
                cell.textLabel.text = @"提醒";
                
            }else if (row == 1){
                cell.imageView.image = [UIImage imageNamed:@"操作记录25"];
                cell.textLabel.text = @"操作记录";
            }else if (row == 2){
                cell.imageView.image = [UIImage imageNamed:@"备忘录25"];
                cell.textLabel.text = @"备忘录";
            }else if (row == 3){
                cell.imageView.image = [UIImage imageNamed:@"意见反馈25"];
                cell.textLabel.text = @"建议反馈";
            }else if (row == 4){
                cell.imageView.image = [UIImage imageNamed:@"来源25"];
                cell.textLabel.text = @"房客来源";
            }
            break;
          case 2:
            if(row == 0){
                cell.imageView.image = [UIImage imageNamed:@"关于25"];
                cell.textLabel.text = @"关于日租帮";
            }else if (row == 1){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:table];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];

                cell.imageView.image = [UIImage imageNamed:@"刷新25"];
                cell.textLabel.text = @"软件更新";
//                if (CanUpdates) {
//                    cell.detailTextLabel.text = @"已有新版本";
//                }else{
//                    cell.detailTextLabel.text = @"已是最新版本";
//                }
            }
//            else if (row == 2){
//                cell.imageView.image = [UIImage imageNamed:@"设置25"];
//                cell.textLabel.text = @"设置";
//            }
            else if (row == 2){
                cell.imageView.image = [UIImage imageNamed:@"退出25"];
                cell.textLabel.text = @"退出登录";
            }
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }if(section == 1){
        return 1;
    }if(section == 2){
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
            if(row == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改用户名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                alert.delegate = self;
                [alert show];
                

            }
            break;
            
         case 1:
            if(row == 0){
                RemindViewController *remind = [[RemindViewController alloc]init];
                [self.navigationController pushViewController:remind animated:YES];
            }else if (row == 1){
                OperationIuiueViewController *operation = [[OperationIuiueViewController alloc]init];
                [self.navigationController pushViewController:operation animated:YES];
            }else if (row == 2){
                The_memoViewController *memo = [[The_memoViewController alloc]init];
                [self.navigationController pushViewController:memo animated:YES];
            }else if (row == 3){
                FeedbackViewController *feed = [[FeedbackViewController alloc]init];
                [self.navigationController pushViewController:feed animated:YES];
            }else if (row == 4){
                IuiuesourceViewController *iuiue = [[IuiuesourceViewController alloc]init];
                [self.navigationController pushViewController:iuiue animated:YES];
            }
            break;
          case 2:
            if(row == 0){
                AboutViewController *about = [[AboutViewController alloc]init];
                [self.navigationController pushViewController:about animated:YES];
            }
            if(row == 1){
              //申请新的开发者账号以后 需要接入的借口的地方
                [self Update1];
            }
            if(row == 2){
//                   [iuiueCHKeychain delete:KEYCHAIN_USERNAMEPASSWORD];
                
                UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"是否退出登录" delegate: self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil, nil];
                action.delegate = self;
                [action showInView:[UIApplication sharedApplication].keyWindow];
            }
        default:
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
       [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    if(section == 0){
        return 50;
    }else{
        return 50;
    }
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////修改用户名的uialertview

//  修改yo9nghuming
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL_UPDATE]];
        }
        else{
            
        }
    }else{
        textfiled = [alertView textFieldAtIndex:0];
        textfiled.delegate = self;
        NSString *numstr = textfiled.text;
        NSString *num;
        
        
        if(buttonIndex == 1){
            if([numstr isEqualToString:@""]){
                [self.view makeToast:@"输入不合法" duration:1 position:@"center"];
                return;
            }
            if(numstr.length > 4){
                [self.view makeToast:@"您输入的新名称长度不能超过四位" duration:2 position:@"center"];
                return;
            }
            num = [numstr substringWithRange:NSMakeRange(0, 1)];
            if(![num isEqualToString:@" "]){
                NSLog(@"%@",numstr);
                NSString *uid = [NSString stringWithFormat:@"%@",MY_UID];
                NSString *zend = [NSString stringWithFormat:@"%@",MY_ZEND];
                __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://rizubang.muniao.com:8081/user/ios/upUserinfo"]];
                [request addPostValue:uid forKey:@"userid"];
                [request addPostValue:zend forKey:@"zend"];
                [request addPostValue:textfiled.text forKey:@"username"];
                [request setCompletionBlock:^{
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&err];
                    [self.view makeToast:dic[@"message"] duration:1 position:@"center"];
                    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:@"com.company.rizubang.usernamepassword"];
                    [usernamepasswordKVPairs setObject:textfiled.text forKey:@"com.company.rizubang.name"];
                    [iuiueCHKeychain save:KEYCHAIN_USERNAMEPASSWORD data:usernamepasswordKVPairs];
                    
                    [tableview reloadData]; /// 刷新tableview改过修改以后的用户名
                }];
                [request setFailedBlock:^{
                    [self.view makeToast:@"网络连接异常..." duration:1 position:@"center"];
                }];
                [request startAsynchronous];
                
            }else{
                [self.view makeToast:@"输入不合法" duration:1 position:@"center"];
            }
            
        }
        

    }
}

//跳转到提醒页
-(void)TurntoRemindView{
    [self tableView:tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
}

-(void)refresh{
    [tableview reloadData];
}

-(void)Update:(float)NewVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    if (NewVersion <= [appCurVersion floatValue]) {
            [self.view makeToast:@"已是最新版本！"];
        }
        else{
//            url =[NSURL URLWithString:URL_UPDATE];
//            NSLog(@"url");
            [self showView];
            
        }
}

-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 2;
    [alert show];
}

//
-(void)Update1{
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APPSTORE_VERSION]];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
                NSLog(@"%@",resultDict[@"results"]);
                NSArray *arr = resultDict[@"results"];
                NSDictionary *dic = arr.lastObject;
               
                NSString *NewVersion = dic[@"version"];
                NSLog(@"dic：%@",NewVersion);
            [self Update:[NewVersion floatValue]];
        }
    }
     ];
    [request setFailedBlock:^{
        
        [self.view makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    
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
