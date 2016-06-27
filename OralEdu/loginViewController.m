//
//  loginViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "loginViewController.h"
#import "TextView.h"
#import "registerViewController.h"
@interface loginViewController ()
@property (nonatomic,strong) UIButton *login_btn;
@property (nonatomic,strong) UIView *m_view;
@property (nonatomic,strong) TextView *Tview;
@property (nonatomic,strong) UIButton *registered_btn;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    [self.view addSubview:self.login_btn];
    [self.view addSubview:self.Tview];
    [self.view addSubview:self.registered_btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _login_btn.frame = CGRectMake(100, 400, 220, 50);
    _Tview.frame = CGRectMake(80, 190, 256, 100);
    _registered_btn.frame = CGRectMake(100, 500, 80, 50);
    //设置为第一响应者
    [self.Tview.user_text becomeFirstResponder];
}

#pragma mark - getters

-(TextView *)Tview
{
    if(!_Tview)
    {
        _Tview = [[TextView alloc] init];
        _Tview.backgroundColor = [UIColor blueColor];
        _Tview.layer.masksToBounds = YES;
        _Tview.layer.cornerRadius = 20;
    }
    return _Tview;
}

-(UIButton *)login_btn
{
    if(!_login_btn)
    {
        _login_btn = [[UIButton alloc] init];
        _login_btn.backgroundColor = [UIColor blueColor];
        [_login_btn setTitle:@"登录" forState:UIControlStateNormal];
        [_login_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _login_btn.layer.masksToBounds = YES;
        _login_btn.layer.cornerRadius = 15;
        [_login_btn addTarget:self action:@selector(go_homeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login_btn;
}

-(UIButton *)registered_btn
{
    if(!_registered_btn)
    {
        _registered_btn = [[UIButton alloc] init];
        _registered_btn.backgroundColor = [UIColor blueColor];
        [_registered_btn setTitle:@"注册" forState:UIControlStateNormal];
        [_registered_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registered_btn.layer.masksToBounds = YES;
        _registered_btn.layer.cornerRadius = 15;
        [_registered_btn addTarget:self action:@selector(go_registerview) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registered_btn;
}

#pragma mark - 实现方法

-(void)go_homeClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)go_registerview
{
    registerViewController *regisVC = [[registerViewController alloc] init];
    [self presentViewController:regisVC animated:YES completion:^{
        
    }];
}

#pragma mark - 键盘回收
-(void)keyboardHide:(id)sender
{
    [_Tview.user_text resignFirstResponder];
    [_Tview.pass_text resignFirstResponder];
}
@end
