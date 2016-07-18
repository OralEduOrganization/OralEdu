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
        [self addSubview:self.stopbtn];
        [self addSubview:self.microphone];
        [self addSubview:self.speakbtn];
        [self addSubview:self.speakbackbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.pickImageMenuBtn.frame = CGRectMake(self.frame.size.width*0.85, 10, 30, 30);
    self.pickColorButton.frame = CGRectMake(self.frame.size.width*0.75, 10, 30, 30);
    self.eraseBtn.frame = CGRectMake(self.frame.size.width*0.55, 10, 30, 30);
    self.writeButton.frame = CGRectMake(self.frame.size.width*0.65, 10, 30, 30);
    self.clearBtn.frame = CGRectMake(self.frame.size.width*0.45, 10, 30, 30);
    self.camerabtn.frame = CGRectMake(0, 10, 30, 30);
    self.leftbtn.frame = CGRectMake(self.frame.size.width-30, 10, 30, 30);
    self.tackbtn.frame = CGRectMake(self.frame.size.width/4-30, 10, 30, 30);
    self.stopbtn.frame = CGRectMake(self.frame.size.width/4+10, 10, 30, 30);
    self.microphone.frame = CGRectMake(self.frame.size.width/4+50, 10, 30, 30);
    self.speakbtn.frame = CGRectMake(10, 10, self.frame.size.width/4-40, 30);
    self.speakbackbtn.frame =  CGRectMake(self.frame.size.width/4-30, 10, 30, 30);
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

-(UIButton *)stopbtn
{
    if(!_stopbtn)
    {
        _stopbtn = [[UIButton alloc] init];
        [_stopbtn setImage:[UIImage imageNamed:@"挂断"] forState:UIControlStateNormal];
    }
    return _stopbtn;
}

-(UIButton *)microphone
{
    if(!_microphone)
    {
        _microphone = [[UIButton alloc] init];
        [_microphone setImage:[UIImage imageNamed:@"麦克风"] forState:UIControlStateNormal];
    }
    return _microphone;
}


-(UIButton *)speakbtn
{
    if(!_speakbtn)
    {
        _speakbtn = [[UIButton alloc] init];
        [_speakbtn setHidden:YES];
        [_speakbtn setImage:[UIImage imageNamed:@"按住说话"] forState:UIControlStateNormal];
    }
    return _speakbtn;
}

-(UIButton *)speakbackbtn
{
    if(!_speakbackbtn)
    {
        _speakbackbtn = [[UIButton alloc] init];
        [_speakbackbtn setImage:[UIImage imageNamed:@"聊天返回"] forState:UIControlStateNormal];
        [_speakbackbtn setHidden:YES];
    }
    return _speakbackbtn;
}





@end

