//
//  feedbackViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/11.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()

@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    

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
