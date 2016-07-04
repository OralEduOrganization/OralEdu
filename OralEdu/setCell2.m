//
//  setCell2.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/2.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setCell2.h"

@implementation setCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.image1];
        [self.contentView addSubview:self.image2];
        [self.contentView addSubview:self.btn_01];
        [self.contentView addSubview:self.btn_02];
        [self.contentView addSubview:self.record_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.image1.frame = CGRectMake(10, 15, 45, 45);
    self.image2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width+10)/2 ,15, 45, 45);
    self.btn_01.frame = CGRectMake(70, 10, 100, 25);
    self.record_label.frame = CGRectMake(70, 35, 100, 25);
    self.btn_02.frame = CGRectMake(250, 10, 100, 50);
}

#pragma mark - gertter

-(UIImageView *)image1
{
    if(!_image1)
    {
        _image1 = [[UIImageView alloc] init];
       // _image1.backgroundColor = [UIColor greenColor];
        _image1.image = [UIImage imageNamed:@"打赏"];
    }
    return _image1;
}

-(UIImageView *)image2
{
    if(!_image2)
    {
        _image2 = [[UIImageView alloc] init];
        //_image2.backgroundColor = [UIColor greenColor];
        _image2.image = [UIImage imageNamed:@"打赏记录"];
    }
    return _image2;
}

-(UIButton *)btn_01
{
    if(!_btn_01)
    {
        _btn_01 = [[UIButton alloc] init];
        [_btn_01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // _btn_01.backgroundColor = [UIColor greenColor];
    }
    return _btn_01;
}

-(UIButton *)btn_02
{
    if(!_btn_02)
    {
        _btn_02 = [[UIButton alloc] init];
        [_btn_02 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //_btn_02.backgroundColor = [UIColor greenColor];
    }
    return _btn_02;
}

-(UILabel *)record_label
{
    if(!_record_label)
    {
        _record_label = [[UILabel alloc] init];
        //_record_label.backgroundColor = [UIColor orangeColor];
        _record_label.textAlignment = NSTextAlignmentCenter;
    }
    return _record_label;
}






@end
