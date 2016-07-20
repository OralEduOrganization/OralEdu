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
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
@interface registerViewController ()
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
    
    MBProgressHUD *HUD;
}
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
@property (nonatomic,strong) UIImageView *groudimage;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.groudimage];
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
   // _Tview.frame = CGRectMake(width *0.16, height *0.18, width*0.68, height*0.18);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.login_btn.frame = CGRectMake((width - (width*0.58))/2, height *0.75, width *0.58,height*0.08);
    self.reist_btn.frame = CGRectMake((width - (width*0.58))/2, height *0.6, width *0.58,height*0.08);
    self.phone_text.frame = CGRectMake((width - (width *0.85))/2, height *0.1, width*0.85, height*0.08);
   // self.phone_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, 150, 300, 50);
    self.pass_text.frame = CGRectMake((width - (width *0.85))/2, height *0.23,width*0.85, height*0.08);
    self.valid_text.frame = CGRectMake((width - (width *0.85))/2, height *0.36, width*0.46, height*0.08);
    self.get_btn.frame = CGRectMake(width *0.55,height *0.36, width*0.38,height *0.08);
    //设置为第一响应者
    [self.phone_text becomeFirstResponder];
    
}

#pragma mark - getters

-(UIImageView *)groudimage
{
    if(!_groudimage)
    {
        _groudimage = [[UIImageView alloc] init];
        _groudimage.frame = [UIScreen mainScreen].bounds;
        _groudimage.image = [UIImage imageNamed:@"groud3"];
    }
    return _groudimage;
}

-(UIButton *)login_btn
{
    if(!_login_btn)
    {
        _login_btn = [[UIButton alloc] init];
       // _login_btn.backgroundColor = [UIColor orangeColor];
        [_login_btn setTitle:@"已有密码，点击登录" forState:UIControlStateNormal];
        [_login_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_login_btn addTarget:self action:@selector(go_login) forControlEvents:UIControlEventTouchUpInside];
        _login_btn.layer.masksToBounds = YES;
        _login_btn.layer.cornerRadius = 20;
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
        _reist_btn.layer.cornerRadius = 20;
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
        _phone_text.backgroundColor = [UIColor whiteColor];
        _phone_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phone_text.borderStyle = UITextBorderStyleRoundedRect;
        _phone_text.leftView = self.phone_image;
        _phone_text.leftViewMode=UITextFieldViewModeAlways;
        [_phone_text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _phone_text.layer.masksToBounds = YES;
        _phone_text.layer.cornerRadius = 15;

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
        _pass_text.backgroundColor = [UIColor whiteColor];
        _pass_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pass_text.borderStyle = UITextBorderStyleRoundedRect;
        _pass_text.secureTextEntry = YES;
        _pass_text.leftView = self.pass_image;
        _pass_text.leftViewMode=UITextFieldViewModeAlways;
        _pass_text.layer.masksToBounds = YES;
        _pass_text.layer.cornerRadius = 15;
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
        _valid_text.backgroundColor = [UIColor whiteColor];
        _valid_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valid_text.borderStyle = UITextBorderStyleRoundedRect;
        _valid_text.leftView = self.valid_image;
        _valid_text.leftViewMode=UITextFieldViewModeAlways;
        _valid_text.layer.masksToBounds = YES;
        _valid_text.layer.cornerRadius = 15;

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
        _get_btn.layer.cornerRadius = 20;
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
        _phone_image.frame = CGRectMake(15, 10, 30, 30);
        _phone_image.image = [UIImage imageNamed:@"phone1"];
        
    }
    return _phone_image;
}

-(UIImageView *)pass_image
{
    if(!_pass_image)
    {
        _pass_image = [[UIImageView alloc] init];
        _pass_image.frame = CGRectMake(15, 10, 30, 30);
        _pass_image.image = [UIImage imageNamed:@"lock1"];
    }
    return _pass_image;
}

-(UIImageView *)valid_image
{
    if(!_valid_image)
    {
        _valid_image = [[UIImageView alloc] init];
        _valid_image.frame = CGRectMake(15, 10, 30, 30);
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
            
            
            NSDictionary *para=@{@"user_moblie":self.user_str,@"user_pwd":self.user_password};
            
            [HttpTool postWithparamsWithURL:@"User/UserSignup" andParam:para success:^(id responseObject) {
                NSData *data = [[NSData alloc] initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                NSString *code=dic[@"code"];
                
                if ([code isEqualToString:@"600"])
                {
                   NSLog(@"用户已经存在");
                    //手机震动
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [MBProgressHUD showError:@"用户已经存在"];
                }else
                {
                    [self dismissViewControllerAnimated:YES completion:^{
                        //这里进行信息的注册
                        
                    }];
                    NSLog(@"成功");
                }
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                //手机震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                HUD.labelText = @"请检查网络设置";
                [self.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [HUD removeFromSuperViewOnHide];
                }];
                
            }];
            
            
        }else{
            NSLog(@"验证失败:%@",error);
            //手机震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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

            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            NSLog(@"获取验证码失败");
            //手机震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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

//限制输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.pass_text) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
@end
