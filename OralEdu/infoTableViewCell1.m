//
//  infoTableViewCell1.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infoTableViewCell1.h"

@implementation infoTableViewCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.pic_imageview];
        [self.contentView addSubview:self.m_label];

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pic_imageview.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 80, 80);
    self.m_label.frame = CGRectMake(20, 10, 100, 50);
}

-(UIImageView *)pic_imageview
{
    if(!_pic_imageview)
    {
        _pic_imageview = [[UIImageView alloc] init];
       // _pic_imageview.backgroundColor = [UIColor greenColor];
        _pic_imageview.layer.masksToBounds = YES;
        _pic_imageview.layer.contentsScale = 40;
        
    }
    return _pic_imageview;
}

-(UILabel *)m_label
{
    if(!_m_label)
    {
        _m_label = [[UILabel alloc] init];
       // _m_label.backgroundColor = [UIColor greenColor];
        _m_label.textAlignment =  NSTextAlignmentCenter;
    }
    return _m_label;
}



@end
