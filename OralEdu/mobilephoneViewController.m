//
//  mobilephoneViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/8.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "mobilephoneViewController.h"

@interface mobilephoneViewController ()
@property (nonatomic,strong) UITextField *oldphonetext;
@property (nonatomic,strong) UITextField *newphonetext;

@end

@implementation mobilephoneViewController

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
