//
//  videoRightView.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/1.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "videoRightView.h"

@interface videoRightView ()

    @property (strong, nonatomic)  UISlider *redColorSlider;
    @property (strong, nonatomic)  UISlider *greenColorSlider;
    @property (strong, nonatomic)  UISlider *blueColorSlider;
    @property (strong, nonatomic)  UISlider *alphaValueSlider;

    @property (strong, nonatomic)  UILabel *redColorValue;
    @property (strong, nonatomic)  UILabel *greenColorValue;
    @property (strong, nonatomic)  UILabel *blueColorValue;
    @property (strong, nonatomic)  UILabel *alphaValue;
    @property (strong, nonatomic)  UILabel *aimColorLabel;

    @property (strong, nonatomic)  UIImageView *resultColorImageView;

    @property (strong, nonatomic)  UIButton *confirmBtn;

@end


@implementation videoRightView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.currentSelectedColor=[UIColor redColor];
        [self changeColor];
        [self addSubview:self.redColorSlider];
        [self addSubview:self.greenColorSlider];
        [self addSubview:self.blueColorSlider];
        [self addSubview:self.alphaValueSlider];
        [self addSubview:self.resultColorImageView];
        
        [self addSubview:self.redColorValue];
        [self addSubview:self.greenColorValue];
        [self addSubview:self.blueColorValue];
        [self addSubview:self.alphaValue];
        [self addSubview:self.aimColorLabel];
        [self addSubview:self.confirmBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toGetColor:) name:@"getColor" object:nil];
    }
    return self;
}
#pragma mark - Private methods
- (void)setResultColor
{
    CGFloat r = self.redColorSlider.value;
    CGFloat g = self.greenColorSlider.value;
    CGFloat b = self.blueColorSlider.value;
    CGFloat a = self.alphaValueSlider.value;
    
    [self.resultColorImageView setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:a]];
    
    [self.redColorValue setText:[NSString stringWithFormat:@"红色%.2f",r]];
    [self.greenColorValue setText:[NSString stringWithFormat:@"绿色%.2f",g]];
    [self.blueColorValue setText:[NSString stringWithFormat:@"蓝色%.2f",b]];
    [self.alphaValue setText:[NSString stringWithFormat:@"透明度%.2f",a]];
}

-(void)changeColor{
    const CGFloat *_components = CGColorGetComponents(self.currentSelectedColor.CGColor);
    CGFloat red     = _components[0];
    CGFloat green = _components[1];
    CGFloat blue   = _components[2];
    CGFloat alpha = _components[3];
    
    self.redColorSlider.value = red;
    self.greenColorSlider.value = green;
    self.blueColorSlider.value = blue;
    self.alphaValueSlider.value = alpha;
    
    [self.redColorValue setText:[NSString stringWithFormat:@"红色%.2f",red]];
    [self.greenColorValue setText:[NSString stringWithFormat:@"绿色%.2f",green]];
    [self.blueColorValue setText:[NSString stringWithFormat:@"蓝色%.2f",blue]];
    [self.alphaValue setText:[NSString stringWithFormat:@"透明度%.2f",alpha]];
    
    [self.resultColorImageView setBackgroundColor:self.currentSelectedColor];
}

#pragma mark - Button action methods

- (void)redSliderMoved
{
    [self setResultColor];
}

- (void)greenSliderMoved
{
    [self setResultColor];
}

- (void)blueSliderMoved
{
    [self setResultColor];
}

- (void)alphaSliderMoved
{
    [self setResultColor];
}

#pragma mark - Click
-(void)confirmBtnClick{
    
    self.currentSelectedColor=self.resultColorImageView.backgroundColor;
     [[NSNotificationCenter defaultCenter]postNotificationName:@"returnColor" object:self.currentSelectedColor];
    
}
#pragma mark - Observer
-(void)toGetColor:(NSNotification *)notification{
    
    UIColor *receiveColor=(UIColor *)[notification object];
    self.currentSelectedColor=receiveColor;
    [self changeColor];
    

}
#pragma mark - getters

-(UISlider *)redColorSlider{
    if(!_redColorSlider){
        _redColorSlider=[[UISlider alloc]initWithFrame:CGRectMake(10, 30, 100, 50)];
        [_redColorSlider addTarget:self action:@selector(redSliderMoved) forControlEvents:UIControlEventValueChanged];
    }
    return _redColorSlider;
}
-(UISlider *)greenColorSlider{
    if(!_greenColorSlider){
        _greenColorSlider=[[UISlider alloc]initWithFrame:CGRectMake(10, 90, 100, 50)];
        [_greenColorSlider addTarget:self action:@selector(greenSliderMoved) forControlEvents:UIControlEventValueChanged];
    }
    return _greenColorSlider;
}

-(UISlider *)blueColorSlider{
    if(!_blueColorSlider){
        _blueColorSlider=[[UISlider alloc]initWithFrame:CGRectMake(10, 150, 100, 50)];
        [_blueColorSlider addTarget:self action:@selector(blueSliderMoved) forControlEvents:UIControlEventValueChanged];
    }
    return _blueColorSlider;
}
-(UISlider *)alphaValueSlider{
    if(!_alphaValueSlider){
        _alphaValueSlider=[[UISlider alloc]initWithFrame:CGRectMake(10,210, 100, 50)];
        [_alphaValueSlider addTarget:self action:@selector(alphaSliderMoved) forControlEvents:UIControlEventValueChanged];
    }
    return _alphaValueSlider;
}

-(UIImageView *)resultColorImageView{
    if(!_resultColorImageView){
        _resultColorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 300, 50, 50)];
        _resultColorImageView.layer.masksToBounds = YES;
        _resultColorImageView.layer.cornerRadius = 26;
    }
    return _resultColorImageView;
}

-(UILabel *)redColorValue{
    if(!_redColorValue){
        _redColorValue=[[UILabel alloc]initWithFrame:CGRectMake(120, 30, 100, 50)];
        _redColorValue.font=[UIFont systemFontOfSize:15];

    }
    return _redColorValue;
}
-(UILabel *)greenColorValue{
    if(!_greenColorValue){
        _greenColorValue=[[UILabel alloc]initWithFrame:CGRectMake(120, 90, 100, 50)];
        _greenColorValue.font=[UIFont systemFontOfSize:15];
    }
    return _greenColorValue;
}
-(UILabel *)blueColorValue{
    if(!_blueColorValue){
        _blueColorValue=[[UILabel alloc]initWithFrame:CGRectMake(120, 150, 100, 50)];
        _blueColorValue.font=[UIFont systemFontOfSize:15];
    }
    return _blueColorValue;
}
-(UILabel *)alphaValue{
    if(!_alphaValue){
        _alphaValue=[[UILabel alloc]initWithFrame:CGRectMake(120, 210, 100, 50)];
        _alphaValue.font=[UIFont systemFontOfSize:15];
    }
    return _alphaValue;
}
-(UILabel *)aimColorLabel{
    if(!_aimColorLabel){
        _aimColorLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 250, 100, 50)];
        [_aimColorLabel setText:@"目标颜色："];
        _aimColorLabel.font=[UIFont systemFontOfSize:15];
    }
    return _aimColorLabel;
}

-(UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 5, 100, 50)];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"确认颜色" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _confirmBtn;
}



@end
