//
//  imageTableViewCell.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/28.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "imageTableViewCell.h"

@implementation imageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.specific_imageview];
        [self.contentView addSubview:self.name_label];
        [self.contentView addSubview:self.time_label];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.specific_imageview.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 80, 80);
    self.time_label.frame = CGRectMake(140, 10, 100, 50);
    self.name_label.frame = CGRectMake(20, 10, 100, 50);
}

-(UIImageView *)specific_imageview
{
    if(!_specific_imageview)
    {
        _specific_imageview = [[UIImageView alloc] init];
        _specific_imageview.backgroundColor = [UIColor greenColor];
    }
    return _specific_imageview;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        _name_label.backgroundColor = [UIColor greenColor];
    }
    return _name_label;
}


-(UILabel *)time_label
{
    if(!_time_label)
    {
        _time_label = [[UILabel alloc] init];
        _time_label.backgroundColor = [UIColor greenColor];
    }
    return _time_label;
}





@end
