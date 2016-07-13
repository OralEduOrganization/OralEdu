//
//  historycell.m
//  OralEdu
//
//  Created by 温丹华 on 13/7/16.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "historycell.h"

@implementation historycell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.his_label];
       // [self addSubview:self.del_btn];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    
    self.his_label.frame = CGRectMake(0, 0, 150, 30);
//    self.del_btn.frame = CGRectMake(50, 200, wid-100, 30);
}
#pragma mark - getters


-(UILabel *)his_label
{
    if(!_his_label)
    {
        _his_label = [[UILabel alloc] init];
        // _his_label.backgroundColor = [UIColor redColor];
        _his_label.text = @"历史搜索";
    }
    return _his_label;
}

//-(UIButton *)del_btn
//{
//    if(!_del_btn)
//    {
//        _del_btn = [[UIButton alloc] init];
//        //_del_btn.backgroundColor = [UIColor redColor];
//        [_del_btn setTitle:@"清空历史记录" forState:UIControlStateNormal];
//        [_del_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }
//    return _del_btn;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
