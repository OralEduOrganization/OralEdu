//
//  infoCell1.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infoCell1.h"

@implementation infoCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.pic_image];
        [self.contentView addSubview:self.name_label];
        [self.contentView addSubview:self.identity_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.name_label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 100, 30);
    self.identity_label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 50, 100, 30);
    self.pic_image.frame = CGRectMake(30, 0, 80, 80);
}

-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
       // _pic_image.backgroundColor = [UIColor greenColor];
        
    }
    return _pic_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        // _name_label.backgroundColor = [UIColor greenColor];
        _name_label.textAlignment =  NSTextAlignmentCenter;
    }
    return _name_label;
}

-(UILabel *)identity_label
{
    if(!_identity_label)
    {
        _identity_label = [[UILabel alloc] init];
       // _identity_label.backgroundColor = [UIColor greenColor];
        _identity_label.textAlignment =  NSTextAlignmentCenter;
    }
    return _identity_label;
}



@end
