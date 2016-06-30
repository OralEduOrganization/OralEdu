//
//  addressViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "addressViewController.h"

@interface addressViewController ()

@end

@implementation addressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnClick
{
    [self saveaddress];
}

-(void)saveaddress
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改地址" message:@"您确定要修改地址吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        //保存修改的地址
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];
}
@end
