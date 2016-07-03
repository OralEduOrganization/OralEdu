//
//  infoCell3.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/3.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infoCell3.h"

@implementation infoCell3

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
    self.label1.frame = CGRectMake(20, 10, 80, 30);
    self.label2.frame = CGRectMake(120, 10, 80, 30);
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
        //_label2.textAlignment =  NSTextAlignmentCenter;
    }
    return _label2;
}


@end
