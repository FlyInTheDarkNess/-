//
//  IuiueAppDelegate.m
//  日租帮
//
//  Created by 赵中良 on 14-9-3.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "IuiueAppDelegate.h"
#import "IuiueLoginViewController.h"
#import "SvUDIDTools.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "MYViewController.h"



@implementation IuiueAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"application:%@\nlaunchOptions:%@",application,launchOptions);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //调用更新
    
    [self Update1];
    //获取广告标识符
    NSString *udid = [SvUDIDTools UDID];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    
    // 当前应用软件版本  比如：1.0.1 Version
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    
    // 当前应用版本号码   int类型  Build
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    //获取当前设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSString* deviceNamea = [[UIDevice currentDevice] model];
    NSLog(@"设备名称: %@",deviceNamea );
    
    //从钥匙串中获取zend
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_UDID];
    NSString *zend = [usernamepasswordKVPairs objectForKey:KEYCHAIN_UDID];
    
    if (zend.length > 0 ) {
        NSDictionary *dica=[NSDictionary dictionaryWithObjectsAndKeys:zend,@"imei",deviceName,@"phone_config",@"0",@"type",appCurVersionNum,@"version",@"0",@"channel",@"4",@"os", nil];
        NSLog(@"发送数据：%@",zend);
        __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APP_LOG]];

    request.requestMethod = @"POST";
        for (id _id in dica.allKeys) {
            NSString *str = [dica valueForKey:_id];
            [request addPostValue:str forKey:_id];
        }
    
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            switch ([resultDict[@"code"] integerValue]) {
                case 1:{
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                    [self.window makeToast:str duration:1.5 position:@"center"];
                }
                default:
                {
//                    NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                    [self.window makeToast:str duration:1.0 position:@"center"];
                }
                    break;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request.error localizedDescription]);
        [self.window makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
        
    }];
    //    hud.detailsLabelText = @"正在登录，请稍后....";
    [request startAsynchronous];
    }
    else{
        //手动存储udid
        NSMutableDictionary *muniaoUdidKVPairs = [NSMutableDictionary dictionary];
        [muniaoUdidKVPairs setObject:udid forKey:KEYCHAIN_UDID];
        [iuiueCHKeychain save:KEYCHAIN_UDID data:muniaoUdidKVPairs];
        zend = udid;
        NSDictionary *dica=[NSDictionary dictionaryWithObjectsAndKeys:zend,@"imei",deviceName,@"phone_config",@"0",@"type",@"1.0",@"version",@"0",@"channel",@"4",@"os", nil];
        __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APP_LOG]];
        
        request.requestMethod = @"POST";
        for (id _id in dica.allKeys) {
            NSString *str = [dica valueForKey:_id];
            [request addPostValue:str forKey:_id];
        }
        
        [request setCompletionBlock:^{
            NSLog(@"%@",request.responseString);
            NSError *error;
            NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                switch ([resultDict[@"code"] integerValue]) {
                    case 1:{
//                        NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                        [self.window makeToast:str duration:1.5 position:@"center"];
                    }
                    default:
                    {
//                        NSString *str = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
//                        [self.window makeToast:str duration:1.0 position:@"center"];
                    }
                        break;
                }
            }else{
                NSLog(@"%@",[error localizedDescription]);
            }
        }];
        
        [request setFailedBlock:^{
            NSLog(@"%@",[request.error localizedDescription]);
            [self.window makeToast:@"网络连接失败，请检查网络设置" duration:1.0f position:@"center"];
            
        }];
        //    hud.detailsLabelText = @"正在登录，请稍后....";
        [request startAsynchronous];

    }
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor grayColor]];
//    [[UINavigationBar appearance] setBackgroundColor:COLOR_SYSTEM_GREEN];
    
    
    //蛋疼休眠一秒钟
    [NSThread sleepForTimeInterval:1];
    
    IuiueLoginViewController *login = [[IuiueLoginViewController alloc]init];
    
    
    self.window.rootViewController = login;
    
        
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    //推送注册
    if (ios8) {
        //1.创建消息上面要添加的动作(按钮的形式显示出来)
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];

        //3.创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
        
        [application registerUserNotificationSettings:notiSettings];
//         [UIUserNotificationSettings settingsForTypes:
//          (UIUserNotificationTypeSound |
//           UIUserNotificationTypeAlert |
//           UIUserNotificationTypeBadge) categories:nil];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
//    NSDictionary* payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (payload)
//    {
//        
//    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //    UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
    //    UIUserNotificationType types = [settings types];
    //    //只有5跟7的时候包含了 UIUserNotificationTypeBadge
    //    if (types == 5 || types == 7) {
    //        application.applicationIconBadgeNumber = 0;
    //    }
    //注册远程通知
    [application registerForRemoteNotifications];
//    UIRemoteNotificationTypeSound = @"tuisong";
    
//    [[UIApplication sharedApplication] set] = notificationSettings;
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"关闭");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@",application);
    
    
    //测试本地通知
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
//    
//    notification.timeZone=[NSTimeZone defaultTimeZone];
//    
//    notification.alertBody=@"测试推送的快捷回复";
//    notification.soundName = @"tuisong.mp3";
//    if (ios8) {
//        notification.category = @"alert";
//    }
//    
//        [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
    
    
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 10;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"打开程序2");
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    if ([result isKindOfClass:[RDVTabBarController class]]) {
//        if(application.applicationState == UIApplicationStateInactive){
//            RDVTabBarController *VC = (RDVTabBarController *)result;
//            [VC setSelectedIndex:4];
//            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
//            if (nav.viewControllers.count > 1) {
//                [nav popToRootViewControllerAnimated:NO];
//            }
//            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
//            [MVC TurntoRemindView];
//        }
//        else{
            
            //            if (nav.viewControllers.count > 1) {
            //                [nav popToRootViewControllerAnimated:NO];
            //            }
        
            if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
                RDVTabBarController *VC = (RDVTabBarController *)result;
                [VC setSelectedIndex:4];
                UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
                MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
                NSString *str = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
                [[MVC rdv_tabBarItem] setBadgeValue:str];
            }
//        }
    }

//    if([UIApplication sharedApplication].applicationIconBadgeNumber > 0){
//        [[UIApplication sharedApplication].keyWindow makeToast:@"有提醒未处理"];
//    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    NSLog(@"regisger success:%@",pToken);
    NSString *Str = [NSString stringWithFormat:@"%@",pToken];
    NSString *str = [Str substringFromIndex:1];
    Str = [str substringToIndex:str.length - 1];
    IuiueLoginViewController *login = (IuiueLoginViewController *)self.window.rootViewController;
    login.Tokens = Str;
    
    //注册成功，将deviceToken保存到应用服务器数据库中
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    
//    NSLog(@"userinfo:%@",userInfo);
//    
//    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    NSLog(@"userinfo:%@",userInfo);
    //    [UIApplication sharedApplication].applicationIconBadgeNumber--;
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    if ([result isKindOfClass:[RDVTabBarController class]]) {
        if(application.applicationState == UIApplicationStateInactive){
            RDVTabBarController *VC = (RDVTabBarController *)result;
            [VC setSelectedIndex:4];
            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:NO];
            }
            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
            [MVC TurntoRemindView];
        }
        else{
            RDVTabBarController *VC = (RDVTabBarController *)result;
            //            [VC setSelectedIndex:4];
            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
            //            if (nav.viewControllers.count > 1) {
            //                [nav popToRootViewControllerAnimated:NO];
            //            }
            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
            //            if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
            NSDictionary *dic = userInfo[@"aps"];
            [UIApplication sharedApplication].applicationIconBadgeNumber = [dic[@"badge"] integerValue];
            NSString *str = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
            [[MVC rdv_tabBarItem] setBadgeValue:str];
            [MVC refresh];
            //            }
        }
    }

}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"userinfo:%@",notification);
//    IuiueLoginViewController *login = [[IuiueLoginViewController alloc]init];
    
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    if ([result isKindOfClass:[RDVTabBarController class]]) {
        if(application.applicationState == UIApplicationStateInactive){
            RDVTabBarController *VC = (RDVTabBarController *)result;
            [VC setSelectedIndex:4];
            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
            if (nav.viewControllers.count > 1) {
                [nav popToRootViewControllerAnimated:NO];
            }
            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
            [MVC TurntoRemindView];
        }
        else{
            RDVTabBarController *VC = (RDVTabBarController *)result;
            [VC setSelectedIndex:4];
            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
//            if (nav.viewControllers.count > 1) {
//                [nav popToRootViewControllerAnimated:NO];
//            }
            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
            if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
                NSString *str = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
                [[MVC rdv_tabBarItem] setBadgeValue:str];
            }
        }
    }
//        [result presentViewController:login animated:YES completion:nil];
}


//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    NSLog(@"userinfo:%@",userInfo);
////    [UIApplication sharedApplication].applicationIconBadgeNumber--;
//    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    UIViewController *result = nil;
//    
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    
//    UIView *frontView = [[window subviews] objectAtIndex:0];
//    id nextResponder = [frontView nextResponder];
//    
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    if ([result isKindOfClass:[RDVTabBarController class]]) {
//        if(application.applicationState == UIApplicationStateInactive){
//            RDVTabBarController *VC = (RDVTabBarController *)result;
//            [VC setSelectedIndex:4];
//            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
//            if (nav.viewControllers.count > 1) {
//                [nav popToRootViewControllerAnimated:NO];
//            }
//            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
//            [MVC TurntoRemindView];
//        }
//        else{
//            RDVTabBarController *VC = (RDVTabBarController *)result;
////            [VC setSelectedIndex:4];
//            UINavigationController *nav =(UINavigationController *)[[VC viewControllers]objectAtIndex:4];
//            //            if (nav.viewControllers.count > 1) {
//            //                [nav popToRootViewControllerAnimated:NO];
//            //            }
//            MYViewController* MVC = [nav.viewControllers objectAtIndex:0];
////            if ([UIApplication sharedApplication].applicationIconBadgeNumber >0) {
//            NSDictionary *dic = userInfo[@"aps"];
//            [UIApplication sharedApplication].applicationIconBadgeNumber = [dic[@"badge"] integerValue];
//                NSString *str = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
//                [[MVC rdv_tabBarItem] setBadgeValue:str];
//            [MVC refresh];
////            }
//        }
//    }
//
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail%@",error);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"MEmoryWarning");
}


//自动更新
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
//            [self.view makeToast:@"已是最新版本！"];
//        [self showView];
        }
        else{
//            url =[NSURL URLWithString:URL_UPDATE];
//            NSLog(@"url");
            [self showView];
            
        }
}

-(void)showView{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到新版本，是否立即升级？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL_UPDATE]];
    }
    else{
        
    }
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
//        [self showView];
//        [self.view makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    
}

@end
