//
//  nameViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "nameViewController.h"

@interface nameViewController ()
@property (nonatomic,strong) UITextField *nametext;
@end

@implementation nameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    [self.view addSubview:self.nametext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nametext.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50);
    [self.nametext becomeFirstResponder];
}

-(UITextField *)nametext
{
    if(!_nametext)
    {
        _nametext = [[UITextField alloc] init];
        _nametext.delegate = self;
        _nametext.backgroundColor= [UIColor lightGrayColor];
        _nametext.layer.masksToBounds = YES;
//        _nametext.layer.cornerRadius = 30;
        _nametext.placeholder = @"请输入新的用户名";
        _nametext.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nametext.borderStyle = UITextBorderStyleBezel;

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
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
