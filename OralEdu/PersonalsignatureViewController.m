//
//  PersonalsignatureViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/1.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "PersonalsignatureViewController.h"

@interface PersonalsignatureViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *person_view;
@property (nonatomic,strong) UILabel *number_label;
@end

#define MAX_LIMIT_NUMS 140

@implementation PersonalsignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.person_view];
    [self.view addSubview:self.number_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.person_view.frame = CGRectMake(0, 79,[UIScreen mainScreen].bounds.size.width, 150);
    self.number_label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 179, 80, 50);
}


-(UITextView *)person_view
{
    if(!_person_view)
    {
        _person_view = [[UITextView alloc] init];
        _person_view.delegate = self;
        _person_view.backgroundColor = [UIColor lightGrayColor];
        _person_view.returnKeyType = UIReturnKeyJoin;//返回键的类型
        
    }
    return _person_view;
}

-(UILabel *)number_label
{
    if(!_number_label)
    {
        _number_label = [[UILabel alloc] init];
        //_number_label.backgroundColor = [UIColor greenColor];
    }
    return _number_label;
}

//return 响应事件
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }

    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.number_label.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}



//点击空白处回收键盘
-(void)keyboardHide
{
    [self.person_view resignFirstResponder];
}
#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
