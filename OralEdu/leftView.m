//
//  leftView.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "leftView.h"

@implementation leftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pic_image];
        [self addSubview:self.name_label];
        [self addSubview:self.identity_label];
        [self addSubview:self.signature_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pic_image.frame = CGRectMake(30, 0, 100, 100);
    self.name_label.frame = CGRectMake(30, 110, 100, 30);
    self.identity_label.frame = CGRectMake(30, 150, 100, 30);
    self.signature_label.frame = CGRectMake(10, 190, 250, 80);
}

#pragma mark - getters

-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
        //_pic_image.backgroundColor = [UIColor greenColor];
        _pic_image.layer.masksToBounds = YES;
        _pic_image.layer.cornerRadius = 30;
    }
    return _pic_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        //_name_label.backgroundColor = [UIColor greenColor];
        _name_label.textAlignment = NSTextAlignmentCenter;
    }
    return _name_label;
}

-(UILabel *)identity_label
{
    if(!_identity_label)
    {
        _identity_label = [[UILabel alloc] init];
       // _identity_label.backgroundColor = [UIColor greenColor];
        _identity_label.textAlignment = NSTextAlignmentCenter;
        
    }
    return _identity_label;
}

-(UILabel *)signature_label
{
    if(!_signature_label)
    {
        _signature_label = [[UILabel alloc] init];
        //_signature_label.backgroundColor = [UIColor greenColor];
        _signature_label.numberOfLines = 0;
        
    }
    return _signature_label;
}






@end
