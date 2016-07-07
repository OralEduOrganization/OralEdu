//
//  CustomnavView.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "CustomnavView.h"

@implementation CustomnavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0X2a2624);
        [self addSubview:self.title_label];
        [self addSubview:self.left_btn];
        [self addSubview:self.right_btn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
    
    self.title_label.frame = CGRectMake((screenWidth-120)/2, 20, 120, 30);
    self.left_btn.frame = CGRectMake(10 , 20, 30, 30);
    self.right_btn.frame = CGRectMake(screenWidth-10-40, 25, 30, 30);
    
}

#pragma mark - getters


-(UILabel *)title_label
{
    if(!_title_label)
    {
        _title_label = [[UILabel alloc] init];
       // _title_label.backgroundColor = [UIColor orangeColor];
        _title_label.textAlignment =   NSTextAlignmentCenter;
        _title_label.textColor = [UIColor whiteColor];
    }
    return _title_label;
}

-(UIButton *)left_btn
{
    if(!_left_btn)
    {
        _left_btn = [[UIButton alloc] init];
       // _left_btn.backgroundColor = [UIColor orangeColor];
        _left_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _left_btn;
}

-(UIButton *)right_btn
{
    if(!_right_btn)
    {
        _right_btn = [[UIButton alloc] init];
        //_right_btn.backgroundColor = [UIColor orangeColor];
        _right_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _right_btn;
}




@end
