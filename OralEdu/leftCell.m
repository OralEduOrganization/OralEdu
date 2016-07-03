//
//  leftCell.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "leftCell.h"
#import "lefttableModel.h"
@implementation leftCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.m_label];
        [self.contentView addSubview:self.m_imageview];
    }
    return self;
}

-(void)setCellDate:(lefttableModel *)leftmodel
{
    self.m_label.text = leftmodel.leftstr;
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.m_imageview.frame = CGRectMake(50, 20, 30, 30);
    self.m_label.frame = CGRectMake(130, 20, 80, 30);
    
}
#pragma mark - gertter


-(UILabel *)m_label
{
    if(!_m_label)
    {
        _m_label = [[UILabel alloc] init];
        _m_label.backgroundColor = [UIColor greenColor];
    }
    return _m_label;
}

-(UIImageView *)m_imageview
{
    if(!_m_imageview)
    {
        _m_imageview = [[UIImageView alloc] init];
        _m_imageview.backgroundColor = [UIColor greenColor];
    }
    return _m_imageview;
}



@end
