//
//  nameViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "nameViewController.h"
#import "HttpTool.h"
#import "MBProgressHUD+XMG.h"
@interface nameViewController ()
@property (nonatomic,strong) UITextField *nametext;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *mobilephone;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *xianlabel;
@end

@implementation nameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    [self.view addSubview:self.nametext];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回.png"] forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.label];
    [self.view addSubview:self.xianlabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nametext.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.04,([UIScreen mainScreen].bounds.size.height)*0.14,
                                     ([UIScreen mainScreen].bounds.size.width)*0.9, 50);
    [self.nametext becomeFirstResponder];
    self.label.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.04, ([UIScreen mainScreen].bounds.size.height)*0.29, 400, 50);
    self.xianlabel.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.04,([UIScreen mainScreen].bounds.size.height)*0.25,
                                    ([UIScreen mainScreen].bounds.size.width)*0.9,1.2);
}
-(UILabel *)xianlabel
{
    if (!_xianlabel) {
        _xianlabel=[[UILabel alloc]init];
        _xianlabel.backgroundColor=[UIColor greenColor];
    }
    return _xianlabel;
}
-(UILabel *)label
{
    if (!_label) {
        _label=[[UILabel alloc]init];
       // _label.backgroundColor=[UIColor grayColor];
        _label.font=[UIFont systemFontOfSize:16];
        _label.textColor=[UIColor grayColor];
        _label.text=@"好的名字让你的朋友更容易记住你。";
    }
    return _label;
}
-(UITextField *)nametext
{
    if(!_nametext)
    {
        _nametext = [[UITextField alloc] init];
        _nametext.delegate = self;
        //_nametext.backgroundColor= [UIColor lightGrayColor];
        _nametext.layer.masksToBounds = YES;
//        _nametext.layer.cornerRadius = 30;
        _nametext.placeholder = @"请输入新的用户名";
        _nametext.clearButtonMode = UITextFieldViewModeWhileEditing;
        //_nametext.borderStyle = UITextBorderStyleBezel;

    }
    return _nametext;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self savename];
    return YES;
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnClick
{
    [self savename];
}

-(void)savename
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改用户名" message:@"您确定要修用户名吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.mobilephone = [[NSString alloc] init];
        self.nickname = [[NSString alloc] init];
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        self.mobilephone = [defaultes objectForKey:@"name"];
        self.nickname = self.nametext.text;
        
        NSDictionary *para=@{@"user_moblie":self.mobilephone,@"user_newnickname":self.nickname};
        
        [HttpTool postWithparamsWithURL:@"NicknameUpdate/NicknameUpdate" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //NSString *code=dic[@"code"];
            NSLog(@"%@",dic);
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        
        
        
        
        //返回上一页
        
        [self.navigationController popViewControllerAnimated:YES];
        //保存修改的用户名
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];
}

-(void)keyboardHide
{
    [self.nametext resignFirstResponder];
}


@end
