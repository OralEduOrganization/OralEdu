//
//  setview.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/12.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setview.h"


@implementation setview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.eraseBtn];
        [self addSubview:self.writeButton];
        [self addSubview:self.pickColorButton];
        [self addSubview:self.clearBtn];
        [self addSubview:self.pickImageMenuBtn];
        [self addSubview:self.camerabtn];
        [self addSubview:self.leftbtn];
        [self addSubview:self.tackbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pickImageMenuBtn.frame = CGRectMake(self.frame.size.width-100, 10, 30, 30);
    self.pickColorButton.frame = CGRectMake(self.frame.size.width-200, 10, 30, 30);
    self.eraseBtn.frame = CGRectMake(self.frame.size.width-300, 10, 30, 30);
    self.writeButton.frame = CGRectMake(self.frame.size.width-250, 10, 30, 30);
    self.clearBtn.frame = CGRectMake(self.frame.size.width-150, 10, 30, 30);
    self.camerabtn.frame = CGRectMake(0, 10, 30, 30);
    self.leftbtn.frame = CGRectMake(self.frame.size.width-30, 10, 30, 30);
    self.tackbtn.frame = CGRectMake(self.frame.size.width/4-30, 10, 30, 30);
    
}

-(UIButton *)writeButton
{
    if(!_writeButton)
    {
        _writeButton = [[UIButton alloc] init];
        [_writeButton setImage:[UIImage imageNamed:@"画笔"] forState:UIControlStateNormal];
    }
    return _writeButton;
}

-(UIButton *)pickColorButton
{
    if(!_pickColorButton)
    {
        _pickColorButton = [[UIButton alloc] init];
        [_pickColorButton setImage:[UIImage imageNamed:@"颜色"] forState:UIControlStateNormal];
        _pickColorButton.selected=true;
    }
    return _pickColorButton;
}

-(UIButton *)eraseBtn
{
    if(!_eraseBtn)
    {
        _eraseBtn = [[UIButton alloc] init];
        [_eraseBtn setImage:[UIImage imageNamed:@"橡皮"] forState:UIControlStateNormal];
    }
    return _eraseBtn;
}

-(UIButton *)pickImageMenuBtn
{
    if(!_pickImageMenuBtn)
    {
        _pickImageMenuBtn = [[UIButton alloc] init];
        [_pickImageMenuBtn setImage:[UIImage imageNamed:@"图库"] forState:UIControlStateNormal];

    }
    return _pickImageMenuBtn;
}

-(UIButton *)camerabtn
{
    if(!_camerabtn)
    {
        _camerabtn = [[UIButton alloc] init];
        [_camerabtn setImage:[UIImage imageNamed:@"摄像头－关"] forState:UIControlStateNormal];
    }
    return _camerabtn;
}

-(UIButton *)clearBtn
{
    if(!_clearBtn)
    {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setImage:[UIImage imageNamed:@"clean"] forState:UIControlStateNormal];
    }
    return _clearBtn;
}

-(UIButton *)leftbtn
{
    if(!_leftbtn)
    {
        _leftbtn = [[UIButton alloc] init];
        [_leftbtn setImage:[UIImage imageNamed:@"侧拉"] forState:UIControlStateNormal];
    }
    return _leftbtn;
}

-(UIButton *)tackbtn
{
    if(!_tackbtn)
    {
        _tackbtn = [[UIButton alloc] init];
        [_tackbtn setImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
    }
    return _tackbtn;
}


@end

