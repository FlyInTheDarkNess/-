//
//  MyNavigationController.m
//  日租帮
//
//  Created by 赵中良 on 14-9-23.
//  Copyright (c) 2014年 com.iuiue. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController (){

}

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"空房间",@"所有房间"]];
    [segment setFrame:CGRectMake(80, 8, 160, 30)];
    [segment setSelectedSegmentIndex:0];
    [self.navigationBar addSubview:segment];
    // Do any additional setup after loading the view.
}

-(void)RoomNavigationbarHide{
   
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
