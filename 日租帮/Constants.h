//
//  Constants.h
//  MQ&A
//
//  Created by 赵中良 on 13-11-12.
//  Copyright (c) 2013年 iMobile. All rights reserved.
//

#ifndef MQ_A_Constants_h
#define MQ_A_Constants_h

////登陆接口
//#define URL_LOGIN @"http://192.168.1.21:801/lastweb/index.php/User/ios/login"
//
////app统计接口
//#define URL_APP_LOG @"http://192.168.1.21:801/lastweb/index.php/User/ios/appCount"
//
////意见反馈接口
//#define URL_FEED_BACK @"http://appios.muniao.com/server/iuiue/infoapp/feedbackios_json.asp"
//
////检测版本更新接口
//#define URL_CHECK_UPDATE @"http://appios.muniao.com/server/app_user/ios.do?op=checkupdateios"
//
////注册接口
//#define URL_REGISTER @"http://192.168.1.21:801/lastweb/index.php/User/ios/userReg"
//
////短信验证码接口
//#define URL_SEND_MESSAGE @"http://192.168.1.21:801/lastweb/index.php/User/ios/makecode"
//
////注册短信验证码
//#define URL_SEND_REGMESSAGE @"http://192.168.1.21:801/lastweb/user/ios/regcode"
//
////找回密码接口
//#define URL_FORGET_PASSWORD @"http://192.168.1.21:801/lastweb/index.php/User/ios/findPwd"
//
////订单列表
//#define URL_ORDER_LIST @"http://192.168.1.21:801/lastweb/index.php/User/ios/orderlist"
//
////订单管理列表
//#define URL_MANAGE_ORDER @"http://192.168.1.21:801/lastweb/index.php/User/ios/orderlist"
//
////房间列表
//#define URL_MY_ROOMS @"http://192.168.1.21:801/lastweb/index.php/User/ios/roomlist"
//
////房间管理接口
//#define URL_MANAGE_ROOM @"http://192.168.1.21:801/lastweb/index.php/User/ios/rooms"
//
////检查添加订单房间日期接口
//#define URL_CHECK_ROOM @"http://192.168.1.21:801/lastweb/user/ios/checkroom"
//
////主页日历接口
//#define URL_MAIN_CANLENDAR @"http://192.168.1.21:801/lastweb/index.php/User/ios/calendar"
//
////退房接口
//#define URL_ORDER_OFF @"http://192.168.1.21:801/lastweb/index.php/User/ios/unroomorders"
//
////查询月排期
//#define URL_MONTH_LIST @"http://192.168.1.21:801/lastweb/index.php/User/ios/mpaiqi"
//
//退房详情接口
//#define URL_ORDER_OFF_INFO @"http://192.168.1.21:801/lastweb/index.php/User/Api/unroomordersinfo"
//
////办理入住
//#define URL_ORDER_IN @"http://192.168.1.21:801/lastweb/index.php/User/Api/inroomorder"
//
////办理续租
//#define URL_ORDER_LONG @"http://192.168.1.21:801/lastweb/index.php/User/Api/yqroomorder"


//登陆接口
#define URL_LOGIN @"http://rizubang.muniao.com:8081/user/ios/login"

//app统计接口
#define URL_APP_LOG @"http://rizubang.muniao.com:8081/user/ios/appCount"

//意见反馈接口
#define URL_FEED_BACK @"http://appios.muniao.com/server/iuiue/infoapp/feedbackios_json.asp"

//检测版本更新接口
#define URL_CHECK_UPDATE @"http://appios.muniao.com/server/app_user/ios.do?op=checkupdateios"

//注册接口
#define URL_REGISTER @"http://rizubang.muniao.com:8081/user/ios/userReg"

//短信验证码接口
#define URL_SEND_MESSAGE @"http://rizubang.muniao.com:8081/user/ios/makecode"

//注册短信验证码
#define URL_SEND_REGMESSAGE @"http://rizubang.muniao.com:8081/user/ios/regcode"

//找回密码接口
#define URL_FORGET_PASSWORD @"http://rizubang.muniao.com:8081/user/ios/findPwd"

//订单列表
#define URL_ORDER_LIST @"http://rizubang.muniao.com:8081/user/ios/orderlist"

//订单管理列表
#define URL_MANAGE_ORDER @"http://rizubang.muniao.com:8081/user/ios/orderlist"

//房间列表
#define URL_MY_ROOMS @"http://rizubang.muniao.com:8081/user/ios/roomlist"

//房间管理接口
#define URL_MANAGE_ROOM @"http://rizubang.muniao.com:8081/user/ios/rooms"

//检查添加订单房间日期接口
#define URL_CHECK_ROOM @"http://rizubang.muniao.com:8081/user/ios/checkroom"

//主页日历接口
#define URL_MAIN_CANLENDAR @"http://rizubang.muniao.com:8081/user/ios/calendar"

//退房接口
#define URL_ORDER_OFF @"http://rizubang.muniao.com:8081/user/ios/unroomorders"

//查询月排期
#define URL_MONTH_LIST @"http://rizubang.muniao.com:8081/user/ios/mpaiqi"

//退房详情接口
#define URL_ORDER_OFF_INFO @"http://rizubang.muniao.com:8081/user/ios/unroomordersinfo"

//办理入住
#define URL_ORDER_IN @"http://rizubang.muniao.com:8081/user/ios/inroomorder"

//办理续租
#define URL_ORDER_LONG @"http://rizubang.muniao.com:8081/user/ios/yqroomorder"

//推送消息条数更改
#define URL_MESSAGE_COUNT @"http://rizubang.muniao.com:8081/User/Ios/badge"


//UDID钥匙串名称
#define KEYCHAIN_UDID @"com.company.rizubang.udid"

//用户钥匙串名称
#define KEYCHAIN_USERNAMEPASSWORD @"com.company.rizubang.usernamepassword"

//uid存储名称
#define KEYCHAIN_UID @"com.company.rizubang.userid"

//zend存储名称
#define KEYCHAIN_ZEND @"com.company.rizubang.zend"

//房东店铺名称
#define KEYCHAIN_OWNERNAME @"com.company.rizubang.name"

//房东手机号/账号
#define KEYCHAIN_MOBILE @"com.company.rizubang.mobile"

//房东密码
#define KEYCHAIN_PASSWORD @"com.company.rizubang.password"

//钥匙串中存储的dic
#define MY_DICTIONARY ((NSMutableDictionary *)[iuiueCHKeychain load:KEYCHAIN_USERNAMEPASSWORD])

//获取uid
#define MY_UID ([MY_DICTIONARY objectForKey:KEYCHAIN_UID])

//获取zend
#define MY_ZEND ([MY_DICTIONARY objectForKey:KEYCHAIN_ZEND])

//获取房东店铺名称
#define MY_OWNERNAME ([MY_DICTIONARY objectForKey:KEYCHAIN_OWNERNAME])

//获取房东手机号
#define MY_MOBILE ([MY_DICTIONARY objectForKey:KEYCHAIN_MOBILE])

//获取房东密码
#define MY_PASSWORD ([MY_DICTIONARY objectForKey:KEYCHAIN_PASSWORD])

//appStore获取数据
#define URL_APPSTORE_VERSION @"http://itunes.apple.com/lookup?id=946786845"

//更新接口
#define URL_UPDATE @"https://itunes.apple.com/us/app/ri-zu-bang/id946786845?l=zh&ls=1&mt=8"

//颜色1
#define COLOR__ONE ([UIColor colorWithRed:147.0f/255 green:170.0f/255 blue:235.0f/225 alpha:1])

//颜色2
#define COLOR__TWO ([UIColor colorWithRed:68.0f/255 green:203.0f/255 blue:204.0f/225 alpha:1])
//颜色3
#define COLOR__THREE ([UIColor colorWithRed:78.0f/255 green:172.0f/255 blue:37.0f/225 alpha:1])
//颜色4
#define COLOR__FOUR ([UIColor colorWithRed:246.0f/255 green:167.0f/255 blue:32.0f/225 alpha:1])
//颜色5
#define COLOR__FIVE ([UIColor colorWithRed:118.0f/255 green:227.0f/255 blue:172.0f/225 alpha:1])
//颜色6
#define COLOR__SIX ([UIColor colorWithRed:211.0f/255 green:33.0f/255 blue:32.0f/225 alpha:1])
//颜色7
#define COLOR__SEVEN ([UIColor colorWithRed:246.0f/255 green:171.0f/255 blue:90.0f/225 alpha:1])
//颜色8
#define COLOR__EIGHT ([UIColor colorWithRed:206.0f/255 green:149.0f/255 blue:255.0f/225 alpha:1])
//颜色9
#define COLOR__NINE ([UIColor colorWithRed:240.0f/255 green:114.0f/255 blue:101.0f/225 alpha:1])
//颜色10
#define COLOR__TEN ([UIColor colorWithRed:66.0f/255 green:106.0f/255 blue:241.0f/225 alpha:1])
//颜色11
#define COLOR__ELEVEN ([UIColor colorWithRed:249.0f/255 green:210.0f/255 blue:48.0f/225 alpha:1])

#define COLOR__BLUE ([UIColor colorWithRed:41.0/255.0 green:131.0/255.0 blue:231.0/255.0 alpha:1])
//颜色集合
#define COLOR__ARRAY (@[COLOR__ONE,COLOR__TWO,COLOR__THREE,COLOR__FOUR,COLOR__FIVE,COLOR__SIX,COLOR__SEVEN,COLOR__EIGHT,COLOR__NINE,COLOR__TEN,COLOR__ELEVEN,[UIColor grayColor]])

//判断是否高于ios8的版本
#define ios7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?YES:NO)

//判断是否高于ios8的版本
#define ios8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0?YES:NO)

//判断是否为手机（pad）
#define iphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone?YES:NO)

#define COLOR_SYSTEM_GREEN ([UIColor colorWithRed:0 green:205.0f/255.0f blue:205.0f/255.0f alpha:1])

#define MY_SCREEN ([UIScreen mainScreen].bounds)

#define MY_WIDTH (MY_SCREEN.size.width)

#define MY_HEIGHT (MY_SCREEN.size.height)

//颜色的宏的定义
#define COLOR_ONE ([UIColor colorWithRed:0.0/255 green:253.0/255 blue:255.0/255 alpha:1])
#define COLOR_TWO ([UIColor colorWithRed:52.0/255 green:214.0/255 blue:216.0/255 alpha:1])
#define COLOR_THREE ([UIColor colorWithRed:105.0/255 green:77.0/255 blue:159.0/255 alpha:1])

#define COLOR_FOUR ([UIColor colorWithRed:163.0/255 green:188.0/255 blue:252.0/255 alpha:1])
#define COLOR_FIVE ([UIColor colorWithRed:108.0/255 green:150.0/255 blue:24.0/255 alpha:1])
#define COLOR_SIX ([UIColor colorWithRed:247.0/255 green:200.0/255 blue:0.0/255 alpha:1])
#define COLOR_SEVEN ([UIColor colorWithRed:252.0/255 green:105.0/255 blue:1.0/255 alpha:1])
#define COLOR_EIGHT ([UIColor colorWithRed:223.0/255 green:29.0/255 blue:27.0/255 alpha:1])
#define COLOR_NINE ([UIColor colorWithRed:144.0/255 green:93.0/255 blue:29.0/255 alpha:1])
#define COLOR_back ([UIColor colorWithRed:190.0/255 green:190.0/255 blue:190.0/255 alpha:1])

#define COLOR_ARRAY (@[COLOR_ONE,COLOR_TWO,COLOR_THREE,COLOR_FOUR,COLOR_FIVE,COLOR_SIX,COLOR_SEVEN,COLOR_EIGHT,COLOR_NINE])

#endif

