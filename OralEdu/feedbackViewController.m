//
//  feedbackViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/11.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "feedbackViewController.h"

@interface feedbackViewController ()
@property(nonatomic,strong)UIButton *btn_tijiao;
@property(nonatomic,strong)UITextView *view_fankui;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:197 green:174 blue:124 alpha:1];
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.btn_tijiao];
    [self.view addSubview:self.view_fankui];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view_fankui.delegate = self;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"width = %f,height = %f",width,height);
    self.view_fankui.frame = CGRectMake((width-(width *0.75))/2, height *0.15, width *0.75, height *0.45);
    self.btn_tijiao.frame = CGRectMake((width - (width*0.58))/2, height *0.7, width *0.58,height*0.08);
    
}
#pragma mark - getters
-(UIButton *)btn_tijiao
{
    if (!_btn_tijiao) {
        _btn_tijiao = [[UIButton alloc]init];
        _btn_tijiao.backgroundColor = [UIColor orangeColor];
        [_btn_tijiao setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _btn_tijiao.layer.cornerRadius = 10;
        [_btn_tijiao setTitle:@"提交" forState:UIControlStateNormal];
        [_btn_tijiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn_tijiao addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchDown];
    }
    return _btn_tijiao;
}
-(void)tijiao
{
    NSLog(@"提交");
}
-(UITextView *)view_fankui
{
    if (!_view_fankui) {
        
        _view_fankui = [[UITextView alloc]init];
        [_view_fankui.layer setCornerRadius:10];
    }
    return _view_fankui;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view_fankui resignFirstResponder];
}
#pragma mark - UITextViewDelegate

@end