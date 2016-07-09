//
//  setCell3.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/9.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setCell3.h"

@implementation setCell3

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self addSubview:self.labeltext];
        [self addSubview:self.viewimage];
        UITableView *tableView;
        tableView.tableFooterView = [[UIView alloc]init];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - gertter

-(UILabel *)labeltext
{
    if(!_labeltext)
    {
        _labeltext = [[UILabel alloc] init];
    }
    return _labeltext;
}

-(UIImageView *)viewimage
{
    if(!_viewimage)
    {
        _viewimage = [[UIImageView alloc] init];
        
    }
    return _viewimage;
}



@end
