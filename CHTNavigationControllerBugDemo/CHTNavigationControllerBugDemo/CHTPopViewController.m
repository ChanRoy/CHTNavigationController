//
//  CHTPopViewController.m
//  CHTNavigationControllerDemo
//
//  Created by cht on 2017/4/17.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTPopViewController.h"

@interface CHTPopViewController ()

@end

@implementation CHTPopViewController

- (IBAction)popEvent:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
