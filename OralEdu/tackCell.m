//
//  tackCell.m
//  OralEdu
//
//  Created by 王俊钢 on 16/7/14.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "tackCell.h"

@implementation tackCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.tacklabel];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.tacklabel.frame = CGRectMake(10, 5, 100, 30);

    
}

-(UILabel *)tacklabel
{
    if(!_tacklabel)
    {
        _tacklabel = [[UILabel alloc] init];
        _tacklabel.backgroundColor = [UIColor redColor];
        _tacklabel.numberOfLines = 0;
        _tacklabel.font = [UIFont fontWithName:@"Helvetica" size:12];

    }
    return _tacklabel;
}





@end
