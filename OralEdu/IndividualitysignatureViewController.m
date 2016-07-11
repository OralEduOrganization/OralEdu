//
//  IndividualitysignatureViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/11.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "IndividualitysignatureViewController.h"

@interface IndividualitysignatureViewController ()

@end

@implementation IndividualitysignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
