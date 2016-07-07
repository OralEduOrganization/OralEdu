//
//  voiceViewController.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/6.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "voiceViewController.h"
#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyMSC.h"

@interface voiceViewController ()

@property (nonatomic,strong) UIButton   *voiceBtn;

@end

@implementation voiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.voiceBtn];
}

-(void)voiceBtnClick{
    
}

#pragma mark - getters

-(UIButton *)voiceBtn{
    if(!_voiceBtn){
        _voiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 50)];
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn setTitle:@"选取颜色" forState:UIControlStateNormal];
        _voiceBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _voiceBtn.backgroundColor=[UIColor lightGrayColor];
        [_voiceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    return _voiceBtn;
}


@end
