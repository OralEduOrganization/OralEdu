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
        
        [self addSubview:self.imageview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //self.m_image.frame = CGRectMake(5, 5, 45, 45);
    self.imageview.frame = CGRectMake(5, 5, 80, 80);
}

-(UIImageView *)imageview
{
    if(!_imageview)
    {
        _imageview = [[UIImageView alloc] init];
        _imageview.backgroundColor = [UIColor greenColor];
    }
    return _imageview;
}

@end
