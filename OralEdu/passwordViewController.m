//
//  passwordViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "passwordViewController.h"
#import "HttpTool.h"
#import "MBProgressHUD+XMG.h"
#import "MBProgressHUD.h"
@interface passwordViewController ()
@property (nonatomic,strong) UITextField *oldpass_text;
@property (nonatomic,strong) UITextField *newpass_text1;
@property (nonatomic,strong) UITextField *newpass_text2;
@property (nonatomic,strong) UIImageView *leftview1;
@property (nonatomic,strong) UIImageView *leftview2;
@property (nonatomic,strong) UIImageView *leftview3;
@property (nonatomic,strong) NSString *user_namestr;
@property (nonatomic,strong) NSString *oldpassword_str;
@property (nonatomic,strong) NSString *newpassword_str;
@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    self.user_namestr = [[NSString alloc] init];
    self.oldpassword_str = [[NSString alloc] init];
    self.newpassword_str = [[NSString alloc] init];
    [self.view addSubview:self.oldpass_text];
    [self.view addSubview:self.newpass_text1];
    [self.view addSubview:self.newpass_text2];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"保存" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldpass_text.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2, 100, 240, 50);
    self.newpass_text1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2, 170 , 240, 50);
    self.newpass_text2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-240)/2, 240 , 240, 50);
}

#pragma mark - getters

-(UITextField *)oldpass_text
{
    if(!_oldpass_text)
    {
        _oldpass_text = [[UITextField alloc] init];
        _oldpass_text.delegate = self;
        _oldpass_text.backgroundColor = [UIColor lightGrayColor];
        _oldpass_text.placeholder = @"请输入原密码";
        _oldpass_text.layer.masksToBounds = YES;
        _oldpass_text.layer.cornerRadius = 15;
        _oldpass_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _oldpass_text.borderStyle = UITextBorderStyleBezel;
        _oldpass_text.secureTextEntry = YES;
        _oldpass_text.leftView = self.leftview1;
        _oldpass_text.leftViewMode=UITextFieldViewModeAlways;
    }
    return _oldpass_text;
}

-(UITextField *)newpass_text1
{
    if(!_newpass_text1)
    {
        _newpass_text1 = [[UITextField alloc] init];
        _newpass_text1.delegate = self;
        _newpass_text1.backgroundColor = [UIColor lightGrayColor];
        _newpass_text1.placeholder = @"请输入新密码";
        _newpass_text1.layer.masksToBounds = YES;
        _newpass_text1.layer.cornerRadius = 15;
        _newpass_text1.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newpass_text1.borderStyle = UITextBorderStyleBezel;
        _newpass_text1.secureTextEntry = YES;
        _newpass_text1.leftView = self.leftview2;
        _newpass_text1.leftViewMode=UITextFieldViewModeAlways;
    }
    return _newpass_text1;
}

-(UITextField *)newpass_text2
{
    if(!_newpass_text2)
    {
        _newpass_text2 = [[UITextField alloc] init];
        _newpass_text2.delegate = self;
        _newpass_text2.backgroundColor = [UIColor lightGrayColor];
        _newpass_text2.placeholder = @"请再次输入新密码";
        _newpass_text2.layer.masksToBounds = YES;
        _newpass_text2.layer.cornerRadius = 15;
        _newpass_text2.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newpass_text2.borderStyle = UITextBorderStyleBezel;
        _newpass_text2.secureTextEntry = YES;
        _newpass_text2.leftView = self.leftview3;
        _newpass_text2.leftViewMode=UITextFieldViewModeAlways;
    }
    return _newpass_text2;
}

-(UIImageView *)leftview1
{
    if(!_leftview1)
    {
        _leftview1 = [[UIImageView alloc] init];
        _leftview1.frame = CGRectMake(10, 10, 30, 30);
        _leftview1.image = [UIImage imageNamed:@"lock1"];
        
    }
    return _leftview1;
}

-(UIImageView *)leftview2
{
    if(!_leftview2)
    {
        _leftview2 = [[UIImageView alloc] init];
        _leftview2.frame = CGRectMake(10, 10, 30, 30);
        _leftview2.image = [UIImage imageNamed:@"lock1"];
        
    }
    return _leftview2;
}

-(UIImageView *)leftview3
{
    if(!_leftview3)
    {
        _leftview3 = [[UIImageView alloc] init];
        _leftview3.frame = CGRectMake(10, 10, 30, 30);
        _leftview3.image = [UIImage imageNamed:@"lock1"];
       
    }
    return _leftview3;
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnClick
{
    [self savenewpass];
}

-(void)savenewpass
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"保存密码" message:@"您确定要修改密码吗" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (self.newpass_text2.text!=self.newpass_text1.text) {
            NSLog(@"请确认新密码");
            [MBProgressHUD showError:@"请确认新密码"];
        }
        else
        {
            //验证登录信息
            NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
            self.user_namestr = [defaultes objectForKey:@"name"];
            self.oldpassword_str= [defaultes objectForKey:@"password"];
            self.newpassword_str = self.newpass_text2.text;
            
            NSDictionary *para=@{@"user_moblie":self.user_namestr,@"user_pwd":self.oldpassword_str,@"user_newpwd":self.newpassword_str};
            
            [HttpTool postWithparamsWithURL:@"PasswordUpdate/PasswordUpdate" andParam:para success:^(id responseObject) {
                NSData *data = [[NSData alloc] initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *code=dic[@"code"];
                NSLog(@"%@",dic);
                if ([code isEqualToString:@"400"]) {
                    
                    [MBProgressHUD showError:@"密码错误"];
                    
                }
                else
                {
                    //返回上一页
                    [self.navigationController popViewControllerAnimated:YES];
                    //保存登录信息
                    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
                    [defaultes setObject:self.user_namestr forKey:@"name"];
                    [defaultes setObject:self.newpassword_str forKey:@"password"];
                    [defaultes synchronize];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];

            
           
        }
    
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardHide:(id)sender
{
    [self.oldpass_text resignFirstResponder];
    [self.newpass_text1 resignFirstResponder];
    [self.newpass_text2 resignFirstResponder];
}
@end
