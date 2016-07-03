//
//  setCell1.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/2.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setCell1.h"
#import "setModel.h"
@implementation setCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.user_image];
        [self.contentView addSubview:self.name_label];
        [self.contentView addSubview:self.phone_label];
        [self.contentView addSubview:self.language_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.user_image.frame = CGRectMake(20, 20, 80, 80);
    self.name_label.frame = CGRectMake(120, 25, 150, 30);
    self.phone_label.frame = CGRectMake(120, 55, 180, 20);
    self.language_label.frame = CGRectMake(120, 80, 180, 20);
}

-(void)setCellDate:(setModel *)order
{
    self.phone_label.text = order.phone_str;
    self.user_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:order.pic_imageurlstr]]];
    self.name_label.text = order.name_str;
    self.language_label.text = order.language_str;
    [self layoutIfNeeded];
}
#pragma mark - gertter

-(UIImageView *)user_image
{
    if(!_user_image)
    {
        _user_image = [[UIImageView alloc] init];
        //_user_image.backgroundColor = [UIColor greenColor];
        _user_image.layer.masksToBounds = YES;
        _user_image.layer.cornerRadius = 40;
    }
    return _user_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
       // _name_label.backgroundColor = [UIColor greenColor];
    }
    return _name_label;
}

-(UILabel *)phone_label
{
    if(!_phone_label)
    {
        _phone_label = [[UILabel alloc] init];
        //_phone_label.backgroundColor = [UIColor greenColor];
    }
    return _phone_label;
}

-(UILabel *)language_label
{
    if(!_language_label)
    {
        _language_label = [[UILabel alloc] init];
       // _language_label.backgroundColor = [UIColor greenColor];
    }
    return _language_label;
}






@end
