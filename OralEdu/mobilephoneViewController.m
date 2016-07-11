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
    [self.view addSubview:self.oldphonetext];
    [self.view addSubview:self.newphonetext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.oldphonetext.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.1, 100,
                                       ([UIScreen mainScreen].bounds.size.width)*0.8, 50);
    self.newphonetext.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.1, 190,
                                       ([UIScreen mainScreen].bounds.size.width)*0.8, 50);
}
-(UITextField *)oldphonetext
{
    if (!_oldphonetext) {
        _oldphonetext=[[UITextField alloc]init];
        _oldphonetext.backgroundColor=[UIColor lightGrayColor];
        _oldphonetext.placeholder=@"请输入原📱号";
        _oldphonetext.layer.masksToBounds=YES;
        _oldphonetext.layer.cornerRadius=15;
        _oldphonetext.clearButtonMode=UITextFieldViewModeWhileEditing;
        
    }
    return _oldphonetext;
}
-(UITextField *)newphonetext
{
    if (!_newphonetext) {
        _newphonetext=[[UITextField alloc]init];
        _newphonetext.backgroundColor=[UIColor lightGrayColor];
        _newphonetext.placeholder=@"请输入新📱号";
        _newphonetext.layer.masksToBounds=YES;
        _newphonetext.layer.cornerRadius=15;
        _newphonetext.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return _newphonetext;
}
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
