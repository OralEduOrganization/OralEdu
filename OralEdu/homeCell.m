//
//  homeCell.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "homeCell.h"
#import "homeModel.h"
@interface homeCell()
@property (nonatomic,strong) UILabel *home_namelabel;
@property (nonatomic,strong) UIImageView *home_headimage;
@property (nonatomic,strong) UILabel *home_timelabel;

@end
@implementation homeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.home_namelabel];
        [self.contentView addSubview:self.home_headimage];
        [self.contentView addSubview:self.home_timelabel];
        [self.contentView addSubview:self.home_btn];
    }
    return self;
}
-(void)setCellDate:(homeModel *)order
{
    self.home_namelabel.text = order.home_name;
    _home_headimage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:order.home_head_imageurl]]];
    self.home_timelabel.text = order.home_time;
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.home_headimage.frame = CGRectMake(20, 10, 50, 50);
    self.home_namelabel.frame = CGRectMake(120,20, 80, 20);
    self.home_timelabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 20, 50, 20);
    self.home_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30, 20, 20, 20);
}
#pragma mark - gertter
-(UIImageView *)home_headimage
{
    if(!_home_headimage)
    {
        _home_headimage = [[UIImageView alloc] init];
        _home_headimage.backgroundColor = [UIColor orangeColor];
        _home_headimage.layer.masksToBounds = YES;
        _home_headimage.layer.cornerRadius = 25;
    }
    return _home_headimage;
}

-(UILabel *)home_namelabel
{
    if(!_home_namelabel)
    {
        _home_namelabel = [[UILabel alloc] init];
        
    }
    return _home_namelabel;
}

-(UILabel *)home_timelabel
{
    if(!_home_timelabel)
    {
        _home_timelabel = [[UILabel alloc] init];
        //_home_timelabel.backgroundColor = [UIColor redColor];
    }
    return _home_timelabel;
}

-(UIButton *)home_btn
{
    if(!_home_btn)
    {
        _home_btn = [[UIButton alloc] init];
        [_home_btn setImage:[UIImage imageNamed:@"首页联系人未选中叹号"] forState:UIControlStateNormal];
    }
    return _home_btn;
}

@end
