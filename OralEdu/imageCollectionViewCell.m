//
//  imageCollectionViewCell.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/30.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "imageCollectionViewCell.h"

@implementation imageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame)-10)];
        
        [self addSubview:self.imageview];
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imageview.frame), CGRectGetWidth(self.frame)-10, 20)];
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];
        
        _close  = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageNamed:@"delete"];
        [_close setImage:image forState:UIControlStateNormal];
        [_close setFrame:CGRectMake(self.frame.size.width-image.size.width, 0, image.size.width, image.size.height)];
        [_close sizeToFit];
        [_close addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)closeBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(moveImageBtnClick:)]) {
        [_delegate moveImageBtnClick:self];
    }
}
@end
