//
//  BaseViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    BOOL isNeedBack;
    NSString *Title;
    UIImage *imagebtn;
}
-(instancetype)initWithTitle:(NSString *)title isNeedBack:(BOOL)IsNeed btn_image:(UIImage *)btn_image
{
    self = [super init];
    if (self) {
        Title = title;
        isNeedBack = IsNeed;
        imagebtn = btn_image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navitionBar];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate  = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(CustomnavView *)navitionBar
{
    if(!_navitionBar)
    {
        _navitionBar = [[CustomnavView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
//        if (!isNeedBack) {
//            [_navitionBar.left_btn removeFromSuperview];
//        }
        if (_navitionBar.left_btn) {
            [_navitionBar.left_btn addTarget:self action:@selector(leftbtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        if(_navitionBar.right_btn)
        {
            [_navitionBar.right_btn addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        _navitionBar.title_label.text = Title;
        
    }
    return _navitionBar;
}

#pragma mark - 响应事件
 
-(void)leftbtnClick
{
    
}

-(void)rightbtnClick
{
    
}
@end
