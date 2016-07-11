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
    CGFloat height = self.frame.size.height;
    CGFloat widht = self.frame.size.width;
    self.labeltext.frame = CGRectMake(widht *0.17, (height-30)/2, 100, 30);
  
}

#pragma mark - gertter

-(UILabel *)labeltext
{
    if(!_labeltext)
    {
        _labeltext = [[UILabel alloc] init];
        //_labeltext.backgroundColor = [UIColor redColor];
    }
    
    return _labeltext;
}

-(UIImageView *)viewimage
{
    if(!_viewimage)
    {
        CGFloat height = self.frame.size.height;
        CGFloat widht = self.frame.size.width;
        _viewimage = [[UIImageView alloc] initWithFrame:CGRectMake(widht*0.07, (height-20)/2, 20, 20)];
       // _viewimage.backgroundColor = [UIColor blueColor];
    }
    return _viewimage;
}



@end
