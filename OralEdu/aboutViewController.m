//
//  aboutViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()
@property (nonatomic,strong) UIImageView *m_pic_image;
@property (nonatomic,strong) UILabel *m_label;
@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.m_pic_image];
    [self.view addSubview:self.m_label];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.m_pic_image.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, 130, 80, 80);
    self.m_label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-250)/2, 240, 250, 300);
}

-(UIImageView *)m_pic_image
{
    if(!_m_pic_image)
    {
        _m_pic_image = [[UIImageView alloc] init];
        //_m_pic_image.backgroundColor = [UIColor greenColor];
        _m_pic_image.layer.masksToBounds = YES;
        _m_pic_image.layer.cornerRadius = 40;
    }
    return _m_pic_image;
}


-(UILabel *)m_label
{
    if(!_m_label)
    {
        _m_label = [[UILabel alloc] init];
       // _m_label.backgroundColor = [UIColor greenColor];
    }
    return _m_label;
}


#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
