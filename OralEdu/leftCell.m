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
    self.m_label.frame = CGRectMake(120, 20, 80, 30);
    
}
#pragma mark - gertter


-(UILabel *)m_label
{
    if(!_m_label)
    {
        _m_label = [[UILabel alloc] init];
    }
    return _m_label;
}

@end
