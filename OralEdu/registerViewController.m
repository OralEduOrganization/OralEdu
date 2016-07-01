//
//  registerViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "registerViewController.h"
#import "loginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+XMG.h"
#import "AFNetworking.h"
#import "HttpTool.h"
@interface registerViewController ()
@property (nonatomic,strong) UIButton *login_btn;
@property (nonatomic,strong) UIButton *reist_btn;
@property (nonatomic,strong) UITextField *phone_text;
@property (nonatomic,strong) UITextField *pass_text;
@property (nonatomic,strong) UITextField *valid_text;
@property (nonatomic,strong) UIButton *get_btn;
@property (nonatomic,strong) UIImageView *phone_image;
@property (nonatomic,strong) UIImageView *pass_image;
@property (nonatomic,strong) UIImageView *valid_image;
@property (nonatomic,strong) NSString *user_str;
@property (nonatomic,strong) NSString *user_password;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groud2.jpg"]];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    self.user_str = [[NSString alloc] init];
    self.user_password = [[NSString alloc] init];
    [self.view addSubview:self.login_btn];
    [self.view addSubview:self.reist_btn];
    [self.view addSubview:self.phone_text];
    [self.view addSubview:self.pass_text];
    [self.view addSubview:self.valid_text];
    [self.view addSubview:self.reist_btn];
    [self.view addSubview:self.get_btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.login_btn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-220)/2, 500, 220, 50);
    self.reist_btn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-220)/2, 400, 220, 50);
    self.phone_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 150, 300, 50);
    self.pass_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 220, 300, 50);
    self.valid_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 290, 170, 50);
    self.get_btn.frame = CGRectMake(210, 290, 130, 50);
    //设置为第一响应者
    [self.phone_text becomeFirstResponder];
    
}

#pragma mark - getters

-(UIButton *)login_btn
{
    if(!_login_btn)
    {
        _login_btn = [[UIButton alloc] init];
       // _login_btn.backgroundColor = [UIColor orangeColor];
        [_login_btn setTitle:@"已有密码，点击登录" forState:UIControlStateNormal];
        [_login_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_login_btn addTarget:self action:@selector(go_login) forControlEvents:UIControlEventTouchUpInside];
        _login_btn.layer.masksToBounds = YES;
        _login_btn.layer.cornerRadius = 15;
    }
    return _login_btn;
}

-(UIButton *)reist_btn
{
    if(!_reist_btn)
    {
        _reist_btn = [[UIButton alloc] init];
        _reist_btn.backgroundColor = [UIColor orangeColor];
        [_reist_btn setTitle:@"注册" forState:UIControlStateNormal];
        [_reist_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_reist_btn addTarget:self action:@selector(regis) forControlEvents:UIControlEventTouchUpInside];
        _reist_btn.layer.masksToBounds = YES;
        _reist_btn.layer.cornerRadius = 15;
    }
    return _reist_btn;
}

-(UITextField *)phone_text
{
    if(!_phone_text)
    {
        _phone_text = [[UITextField alloc] init];
        _phone_text.delegate = self;
        _phone_text.placeholder = @"请输入手机号";
        _phone_text.keyboardType = UIKeyboardTypePhonePad;
        _phone_text.returnKeyType =UIReturnKeyDone;
        _phone_text.backgroundColor = [UIColor orangeColor];
        _phone_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phone_text.borderStyle = UITextBorderStyleRoundedRect;
        _phone_text.leftView = self.phone_image;
        _phone_text.leftViewMode=UITextFieldViewModeAlways;
    }
    return _phone_text;
}

-(UITextField *)pass_text
{
    if(!_pass_text)
    {
        _pass_text = [[UITextField alloc] init];
        _pass_text.delegate = self;
        _pass_text.placeholder = @"请输入密码";
        _pass_text.returnKeyType = UIReturnKeyGo;
        _pass_text.backgroundColor = [UIColor orangeColor];
        _pass_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pass_text.borderStyle = UITextBorderStyleRoundedRect;
        _pass_text.secureTextEntry = YES;
        _pass_text.leftView = self.pass_image;
        _pass_text.leftViewMode=UITextFieldViewModeAlways;
    }
    return _pass_text;
}

-(UITextField *)valid_text
{
    if(!_valid_text)
    {
        _valid_text = [[UITextField alloc] init];
        _valid_text.delegate = self;
        _valid_text.placeholder = @"请输入验证码";
        _valid_text.returnKeyType = UIReturnKeyGo;
        _valid_text.backgroundColor = [UIColor orangeColor];
        _valid_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valid_text.borderStyle = UITextBorderStyleRoundedRect;
        _valid_text.leftView = self.valid_image;
        _valid_text.leftViewMode=UITextFieldViewModeAlways;
    }
    return _valid_text;
}

-(UIButton *)get_btn
{
    if(!_get_btn)
    {
        _get_btn = [[UIButton alloc] init];
        _get_btn.backgroundColor = [UIColor orangeColor];
        _get_btn.layer.masksToBounds = YES;
        _get_btn.layer.cornerRadius = 15;
        [_get_btn addTarget:self action:@selector(startTime) forControlEvents:UIControlEventTouchUpInside];
        [_get_btn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_get_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _get_btn;
}

-(UIImageView *)phone_image
{
    if(!_phone_image)
    {
        _phone_image = [[UIImageView alloc] init];
        _phone_image.frame = CGRectMake(10, 10, 30, 30);
        _phone_image.image = [UIImage imageNamed:@"phone1"];
    }
    return _phone_image;
}

-(UIImageView *)pass_image
{
    if(!_pass_image)
    {
        _pass_image = [[UIImageView alloc] init];
        _pass_image.frame = CGRectMake(10, 10, 30, 30);
        _pass_image.image = [UIImage imageNamed:@"lock1"];
    }
    return _pass_image;
}

-(UIImageView *)valid_image
{
    if(!_valid_image)
    {
        _valid_image = [[UIImageView alloc] init];
        _valid_image.frame = CGRectMake(10, 10, 30, 30);
        _valid_image.image = [UIImage imageNamed:@"lock1"];
    }
    return _valid_image;
}



#pragma mark - 实现方法
-(void)go_login
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)regis
{
    [SMSSDK commitVerificationCode:_valid_text.text phoneNumber:_phone_text.text zone:@"86" result:^(NSError *error) {
        if (!error) {

            [MBProgressHUD showSuccess:@"验证成功"];
            
            self.user_str = self.phone_text.text;
            self.user_password = self.pass_text.text;
            
            [self dismissViewControllerAnimated:YES completion:^{
                //这里进行信息的注册
                
                NSDictionary *para=@{@"user_moblie":self.user_str,@"user_pwd":self.user_password};
                
                [HttpTool postWithparamsWithURL:@"User/UserSignup" andParam:para success:^(id responseObject) {
                    NSData *data = [[NSData alloc] initWithData:responseObject];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];

                

            }];
            
        }else{
            NSLog(@"验证失败:%@",error);
            [MBProgressHUD showError:@"注册失败，请检查输入"];
        }
    }];
}

-(void)keyboardHide:(id)sender
{
    [self.pass_text resignFirstResponder];
    [self.phone_text resignFirstResponder];
    [self.valid_text resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)getvalid
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone_text.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"获取验证码成功");
//            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"获取验证码成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [control addAction:action1];
//            [control addAction:action2];
//            [self presentViewController:control animated:YES completion:nil];
            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            NSLog(@"获取验证码失败");
            [MBProgressHUD showError:@"请确认您输入的手机号"];
        }
        
    }];

}
-(void)startTime{

    [self getvalid];
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_get_btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _get_btn.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_get_btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _get_btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
@end
