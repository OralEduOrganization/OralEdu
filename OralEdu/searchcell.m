//
//  searchcell.m
//  OralEdu
//
//  Created by 温丹华 on 12/7/16.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "searchcell.h"
#import "hisModel.h"
@implementation searchcell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.xingming_label];
        [self.contentView addSubview:self.head_image];
        [self.contentView addSubview:self.identity_label];
        [self.contentView addSubview:self.line_view];
        [self.contentView addSubview:self.intro_label];
        [self.contentView addSubview:self.in_text];
        [self.contentView addSubview:self.mobolelabel];
        UITableView *tableView;
        tableView.tableFooterView = [[UIView alloc]init];
    }
    return self;
}
-(void)setCellDate:(hisModel *)order
{
    self.xingming_label.text = order.name;
    self.identity_label.text = order.identity;
    self.in_text.text = order.sigen;
    self.mobolelabel.text = order.mobile;
    self.head_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:order.pic_url]]];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    
    
    [super layoutSubviews];
    _in_text.delegate = self;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
   // NSLog(@"width = %f,height = %f",width,height);
    self.xingming_label.frame = CGRectMake(width *0.37, (height*0.6-(height*0.24))/2, width *0.2, height *0.24);
    self.identity_label.frame = CGRectMake(width *0.62,(height*0.6-(height*0.18))/2, width *0.2, height *0.18);
    self.head_image.frame = CGRectMake(width *0.04 , height *0.06, width*0.23, width*0.23);
    self.line_view.frame = CGRectMake((width - width*0.94)/2,height *0.6, width *0.94, 1);
    self.intro_label.frame = CGRectMake(width *0.04, height*0.65,width *0.25, height *0.15);
    self.in_text.frame = CGRectMake(width*0.25, height *0.63, 235, height*0.35);
    self.mobolelabel.frame = CGRectMake(10, 10, 100, 40);
}

#pragma mark-UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
#pragma mark - getters
-(UILabel *)xingming_label
{
    if (!_xingming_label) {
        _xingming_label = [[UILabel alloc]init];
       _xingming_label.font = [UIFont systemFontOfSize:17];
    }
    return _xingming_label;
}
-(UILabel *)identity_label
{
    if (!_identity_label) {
        _identity_label = [[UILabel alloc]init];
        _identity_label.layer.cornerRadius = 10;
        _identity_label.layer.borderColor = [[UIColor grayColor]CGColor];
        _identity_label.layer.borderWidth = 0.5f;
        _identity_label.layer.masksToBounds = YES;

    }
    return _identity_label;
}
-(UIImageView *)head_image
{
    if (!_head_image) {
        _head_image = [[UIImageView alloc]init];
        _head_image.backgroundColor = [UIColor grayColor];
        _head_image.layer.masksToBounds = YES;
        _head_image.layer.cornerRadius = 40;
    }
    return _head_image;
}
-(UILabel *)intro_label
{
    if (!_intro_label) {
        _intro_label = [[UILabel alloc]init];
        _intro_label.font = [UIFont systemFontOfSize:13];
        _intro_label.text = @"个人简介:";
        _intro_label.textColor = [UIColor grayColor];
    }
    return _intro_label;
}
-(UITextView *)in_text
{
    if (!_in_text) {
        _in_text = [[UITextView alloc]init];
        _in_text.font = [UIFont systemFontOfSize:13];
        _in_text.textColor = [UIColor grayColor];
    }
    return _in_text;
}
-(UIView *)line_view
{
    if (!_line_view) {
        _line_view = [[UIView alloc]init];
        _line_view.backgroundColor = [UIColor lightGrayColor];
    }
    return _line_view;
}

-(UILabel *)mobolelabel
{
    if(!_mobolelabel)
    {
        _mobolelabel = [[UILabel alloc] init];
        _mobolelabel.backgroundColor = [UIColor greenColor];
        _mobolelabel.font = [UIFont systemFontOfSize:13];
        [_mobolelabel setHidden:YES];
    }
    return _mobolelabel;
}





@end
