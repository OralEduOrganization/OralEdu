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
@property (nonatomic,strong) UIImageView *leftview;
@property (nonatomic,strong) UIImageView *leftview2;
@end

@implementation mobilephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];

    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"保存" forState:UIControlStateNormal];
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
-(void)rightbtnClick
{
    
    NSLog(@"xiugai");
}

-(UITextField *)oldphonetext
{
    if (!_oldphonetext) {
        _oldphonetext=[[UITextField alloc]init];
        _oldphonetext.backgroundColor=[UIColor lightGrayColor];
        _oldphonetext.delegate = self;
        _oldphonetext.placeholder=@"请输入原手机号";
        _oldphonetext.layer.masksToBounds=YES;
        _oldphonetext.layer.cornerRadius=15;
        _oldphonetext.clearButtonMode=UITextFieldViewModeWhileEditing;
        _oldphonetext.leftView = self.leftview2;
        _oldphonetext.leftViewMode=UITextFieldViewModeAlways;
    }
    return _oldphonetext;
}

-(UITextField *)newphonetext
{
    if (!_newphonetext) {
        _newphonetext=[[UITextField alloc]init];
        _newphonetext.delegate = self;
        _newphonetext.backgroundColor=[UIColor lightGrayColor];
        _newphonetext.placeholder=@"请输入新手机号";
        _newphonetext.layer.masksToBounds=YES;
        _newphonetext.layer.cornerRadius=15;
        _newphonetext.clearButtonMode=UITextFieldViewModeWhileEditing;
        _newphonetext.leftView = self.leftview;
        _newphonetext.leftViewMode=UITextFieldViewModeAlways;
    }
    return _newphonetext;
}

-(UIImageView *)leftview
{
    if(!_leftview)
    {
        _leftview = [[UIImageView alloc] init];
        _leftview.image = [UIImage imageNamed:@"phone1"];
        _leftview.frame = CGRectMake(10, 10, 30, 30);

    }
    return _leftview;
}

-(UIImageView *)leftview2
{
    if(!_leftview2)
    {
        _leftview2 = [[UIImageView alloc] init];
        _leftview2.image = [UIImage imageNamed:@"phone1"];
        _leftview2.frame = CGRectMake(10, 10, 30, 30);
    }
    return _leftview2;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField removeFromSuperview];
    return YES;
}

-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardHide:(id)sender
{
    [self.oldphonetext resignFirstResponder];
    [self.newphonetext resignFirstResponder];
}

@end
