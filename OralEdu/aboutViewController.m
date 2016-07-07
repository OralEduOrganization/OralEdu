//
//  aboutViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "aboutViewController.h"
#import "AppDelegate.h"
@interface aboutViewController ()
@property (nonatomic,strong) UIImageView *m_pic_image;
@property (nonatomic,strong) UILabel *m_label;
@property (nonatomic,strong) UILabel *development_label;
@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.m_pic_image];
    [self.view addSubview:self.m_label];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    self.navitionBar.title_label.text = @"关于我们";
    [self.view addSubview:self.development_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.m_pic_image.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, 80, 80, 80);
    self.m_label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-280)/2, 200, 280, 300);
    self.development_label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-220)/2, [UIScreen mainScreen].bounds.size.height-100, 220, 50);
}

-(UIImageView *)m_pic_image
{
    if(!_m_pic_image)
    {
        _m_pic_image = [[UIImageView alloc] init];
        _m_pic_image.image = [UIImage imageNamed:@"about-iPhone"];
        _m_pic_image.layer.masksToBounds = YES;
        _m_pic_image.layer.cornerRadius = 10;
    }
    return _m_pic_image;
}

-(UILabel *)m_label
{
    if(!_m_label)
    {
        
        _m_label = [[UILabel alloc] init];
        //_m_label.backgroundColor = [UIColor greenColor];
         NSString *str = @"    OralEdu(远程在线教育系统)，采用c2c的模式搭建一个用来学习相关口语知识的平台，我们有最专业的社会从业者，有最严格的审核机制，为广大用户提供专业性更强，视角更广的学习机会，每一个人通过我们的平台都可以成为知识的传播者和接收者，利用碎片化的时间来学习，提高自己。利用互联网的特点，彻底解决您时间不足的困扰和资源利用率不高的问题。让用户足不出户就能给接触到最专业的指导，回归语言学习的本质。";
        _m_label.numberOfLines = 0;
//        _m_label.layer.borderWidth = 0.5;
        _m_label.font=[UIFont systemFontOfSize:15];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _m_label.attributedText = attributedString;
        
       
    }
    return _m_label;
}


-(UILabel *)development_label
{
    if(!_development_label)
    {
        _development_label = [[UILabel alloc] init];
        //_development_label.backgroundColor = [UIColor greenColor];
        _development_label.textAlignment = NSTextAlignmentCenter;
        _development_label.numberOfLines = 0;
        _development_label.text = @"Copyright@2016-2017 TJISE  \n  All Right Reserved";
        
    }
    return _development_label;
}



#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self presentLeftMenuViewController];
}

- (void) presentLeftMenuViewController{
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

@end
