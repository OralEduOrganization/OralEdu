//
//  mobilephoneViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/8.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "mobilephoneViewController.h"
#import "MBProgressHUD+XMG.h"
#import "HttpTool.h"
@interface mobilephoneViewController ()
@property (nonatomic,strong) UITextField *passworetext;
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
    [self.view addSubview:self.passworetext];
    [self.view addSubview:self.newphonetext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.passworetext.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.1, 100,
                                       ([UIScreen mainScreen].bounds.size.width)*0.8, 50);
    self.newphonetext.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.1, 190,
                                       ([UIScreen mainScreen].bounds.size.width)*0.8, 50);
}
-(void)rightbtnClick
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改账户" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //验证登录信息
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *password = [defaultes objectForKey:@"password"];
        NSString *oldmobile = [defaultes objectForKey:@"name"];
        if (self.passworetext.text!=password) {
            [MBProgressHUD showError:@"密码错误"];
        }
        else
        {
        
            NSDictionary *para=@{@"user_moblie":oldmobile,@"user_newmoblie":self.newphonetext.text};

            [HttpTool postWithparamsWithURL:@"Update/MobileUpdate" andParam:para success:^(id responseObject) {
                NSData *data = [[NSData alloc] initWithData:responseObject];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *code=dic[@"code"];
                
                NSLog(@"%@",dic);
                
                
                   // [MBProgressHUD showError:@"手机号错误"];
                    
                
                 if([code isEqualToString:@"200"])
                {
                    //返回上一页
                    [self.navigationController popViewControllerAnimated:YES];
                    //保存登录信息
                    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
                    [defaultes setObject:self.newphonetext.text forKey:@"name"];

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

-(UITextField *)passworetext
{
    if (!_passworetext) {
        _passworetext=[[UITextField alloc]init];
        _passworetext.backgroundColor=[UIColor lightGrayColor];
        _passworetext.delegate = self;
        _passworetext.placeholder=@"请输入密码";
        _passworetext.layer.masksToBounds=YES;
        _passworetext.layer.cornerRadius=15;
         _passworetext.secureTextEntry = YES;
        _passworetext.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passworetext.leftView = self.leftview2;
        _passworetext.clearsOnBeginEditing = YES;
        _passworetext.clearButtonMode = UITextFieldViewModeAlways;
        _passworetext.leftViewMode=UITextFieldViewModeAlways;
    }
    return _passworetext;
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
        _newphonetext.clearButtonMode = UITextFieldViewModeAlways;
        _newphonetext.clearButtonMode=UITextFieldViewModeWhileEditing;
        _newphonetext.leftView = self.leftview;
        _newphonetext.clearsOnBeginEditing = YES;
        _newphonetext.leftViewMode=UITextFieldViewModeAlways;
        _newphonetext.keyboardType = UIKeyboardTypePhonePad;
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
        _leftview2.image = [UIImage imageNamed:@"lock1"];
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
    [self.passworetext resignFirstResponder];
    [self.newphonetext resignFirstResponder];
}

@end
