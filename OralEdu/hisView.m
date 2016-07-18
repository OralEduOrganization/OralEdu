//
//  hisView.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "hisView.h"

@implementation hisView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.his_label];
        [self addSubview:self.del_btn];
        [self addSubview:self.his_tableview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    
    self.his_label.frame = CGRectMake(0, 0, 150, 30);
    self.del_btn.frame = CGRectMake(50, 200, wid-100, 30);
    self.his_tableview.frame = CGRectMake(0, 30, wid, 150);
}

#pragma mark - getters


-(UILabel *)his_label
{
    if(!_his_label)
    {
        _his_label = [[UILabel alloc] init];

        _his_label.text = @"历史搜索";
    }
    return _his_label;
}

-(UIButton *)del_btn
{
    if(!_del_btn)
    {
        _del_btn = [[UIButton alloc] init];

        [_del_btn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [_del_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _del_btn;
}

-(UITableView *)his_tableview
{
    if(!_his_tableview)
    {
        _his_tableview = [[UITableView alloc] init];
       // _his_tableview.backgroundColor = [UIColor blueColor];
        _his_tableview.showsVerticalScrollIndicator = NO;
        _his_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _his_tableview;
}


@end
