//
//  CHTViewController.m
//  CHTNavigationControllerDemo
//
//  Created by cht on 2017/4/17.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTViewController.h"

@interface CHTViewController ()

@end

@implementation CHTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationItem && self.navigationController.viewControllers.count > 1) {
        [self creatBackBtn];
    }
}

- (void)creatBackBtn
{
    UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackBtn.frame = CGRectMake(0, 0, 14, 24);
    [navBackBtn setImage:[UIImage imageNamed:@"Nav_Back_Btn"] forState:UIControlStateNormal];
    [navBackBtn addTarget:self action:@selector(backBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackBtn];
}

- (void)backBarBtnClick:(UIButton *)navBackBtn{
    
    [self.navigationController popViewControllerAnimated:YES];
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
