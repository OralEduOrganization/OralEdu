//
//  setView.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setView.h"

@implementation setView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pic_image];
        [self addSubview:self.name_label];
        [self addSubview:self.accound_label];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pic_image.frame = CGRectMake(20, 20, 100, 100);
    self.name_label.frame = CGRectMake(155, 25, 130, 50);
    self.accound_label.frame = CGRectMake(155, 80, 130, 50);
}
#pragma mark - getters


-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
        //_pic_image.backgroundColor = [UIColor blueColor];
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
       // _name_label.backgroundColor = [UIColor blueColor];
        _name_label.textAlignment = NSTextAlignmentCenter;
    }
    return _name_label;
}

-(UILabel *)accound_label
{
    if(!_accound_label)
    {
        _accound_label = [[UILabel alloc] init];
        //_accound_label.backgroundColor = [UIColor blueColor];
        _accound_label.textAlignment = NSTextAlignmentCenter;
    }
    return _accound_label;
}





@end
