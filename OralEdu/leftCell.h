//
//  leftCell.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class lefttableModel;
@interface leftCell : UITableViewCell
@property (nonatomic,strong) UILabel *m_label;
@property (nonatomic,strong) UIImageView *m_imageview;
-(void)setCellDate:(lefttableModel *)leftmodel;
@end
