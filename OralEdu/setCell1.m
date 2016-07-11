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
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   // NSLog(@"width = %f,height = %f",width,height);
    self.user_image.frame = CGRectMake(width*0.04, height *0.025, width*0.19, height*0.11);
    self.name_label.frame = CGRectMake(width*0.35, height *0.034, width*0.36, height*0.04);
    self.phone_label.frame = CGRectMake(width *0.35, height *0.1, width*0.43, height*0.023);

}

-(void)setCellDate:(setModel *)order
{
    self.phone_label.text = order.phone_str;
    self.user_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:order.pic_imageurlstr]]];
    self.name_label.text = order.name_str;
    [self layoutIfNeeded];
}
#pragma mark - gertter

-(UIImageView *)user_image
{
    if(!_user_image)
    {
        _user_image = [[UIImageView alloc] init];
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
    }
    return _name_label;
}

-(UILabel *)phone_label
{
    if(!_phone_label)
    {
        _phone_label = [[UILabel alloc] init];
    }
    return _phone_label;
}






@end
