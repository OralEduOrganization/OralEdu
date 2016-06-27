//
//  infoCell2.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infoCell2.h"

@implementation infoCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.label1];
        [self.contentView addSubview:self.label2];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.label1.frame = CGRectMake(30, 20, 100, 50);
    self.label2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 20, 100, 50);
}

#pragma mark - getters

-(UILabel *)label1
{
    if(!_label1)
    {
        _label1 = [[UILabel alloc] init];
       // _label1.backgroundColor = [UIColor greenColor];
        _label1.textAlignment =  NSTextAlignmentCenter;
    }
    return _label1;
}

-(UILabel *)label2
{
    if(!_label2)
    {
        _label2 = [[UILabel alloc] init];
       // _label2.backgroundColor = [UIColor greenColor];
        _label2.textAlignment =  NSTextAlignmentCenter;
    }
    return _label2;
}


@end
