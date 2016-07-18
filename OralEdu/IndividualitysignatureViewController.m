//
//  IndividualitysignatureViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/11.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "IndividualitysignatureViewController.h"
#import "HttpTool.h"
@interface IndividualitysignatureViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *person_view;
@property (nonatomic,strong) UILabel *number_label;
@property (nonatomic,strong) UILabel *xian_label;
@end

#define MAX_LIMIT_NUMS 30

@implementation IndividualitysignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"保存" forState:UIControlStateNormal];
    
    [self.view addSubview:self.person_view];
    [self.view addSubview:self.number_label];
    [self.view addSubview:self.xian_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.person_view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.05,
                                        ([UIScreen mainScreen].bounds.size.height)*0.135,
                                        ([UIScreen mainScreen].bounds.size.width)*0.9, 50);
    self.number_label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.81,
                                         ([UIScreen mainScreen].bounds.size.height)*0.25, 55, 30);
    
    self.xian_label.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.05,
                                     ([UIScreen mainScreen].bounds.size.height*0.29),
                                     ([UIScreen mainScreen].bounds.size.width)*0.9,1);
    
}

-(UILabel *)xian_label
{
    if (!_xian_label) {
        _xian_label=[[UILabel alloc] init];
        _xian_label.backgroundColor=[UIColor greenColor];
    }
    return _xian_label;
}

-(UILabel *)number_label
{
    if (!_number_label) {
        _number_label=[[UILabel alloc]init];
        
       // _number_label.backgroundColor=[UIColor redColor];
        
    }
    return _number_label;
}
-(UITextView *)person_view
{
    if (!_person_view) {
        _person_view=[[UITextView alloc]init];
        _person_view.delegate = self;
        _person_view.font=[UIFont systemFontOfSize:18];
        _person_view.layer.masksToBounds=YES;
        _person_view.layer.cornerRadius=15;
        _person_view.returnKeyType = UIReturnKeyJoin;//返回键的类型
    }
    return _person_view;
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

-(void)rightbtnClick
{
   
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"保存修改信息" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //取出用户账号
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        

        NSDictionary *para=@{@"user_moblie":name,@"user_newsigned":self.person_view.text};
        
        [HttpTool postWithparamsWithURL:@"Update/SignedUpdate" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          
            NSLog(@"%@",dic);
            
         
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }];
    
    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:nil];

}

@end
