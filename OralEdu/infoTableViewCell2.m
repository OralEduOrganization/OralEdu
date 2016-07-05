//
//  infoTableViewCell2.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infoTableViewCell2.h"

@implementation infoTableViewCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.m_label1];
        [self.contentView addSubview:self.m_label2];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.m_label1.frame = CGRectMake(20, 10, 100, 50);
    self.m_label2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 10, 100, 50);
}

-(UILabel *)m_label1
{
    if(!_m_label1)
    {
        _m_label1 = [[UILabel alloc] init];
       // _m_label1.backgroundColor = [UIColor greenColor];
        _m_label1.textAlignment = NSTextAlignmentCenter;
    }
    return _m_label1;
}

-(UILabel *)m_label2
{
    if(!_m_label2)
    {
        _m_label2 = [[UILabel alloc] init];
       // _m_label2.backgroundColor = [UIColor greenColor];
        _m_label2.textAlignment = NSTextAlignmentCenter;
        _m_label2.numberOfLines = 0;
    }
    return _m_label2;
}

-(void)getChange{
    [self.m_label1 removeFromSuperview];
    [self.m_label2 removeFromSuperview];
    
    self.m_label3=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 50)];
    self.m_label3.textAlignment = NSTextAlignmentCenter;
//    self.m_label3.backgroundColor=[UIColor whiteColor];
       self.m_label3.layer.cornerRadius = 26;
    [self.m_label3.layer setBorderWidth:1];
    self.m_label3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.m_label3.layer.masksToBounds = YES;

    [self.contentView addSubview:self.m_label3];
}


@end
