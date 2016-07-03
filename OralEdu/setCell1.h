//
//  setCell1.h
//  OralEdu
//
//  Created by 王俊钢 on 16/7/2.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class setModel;
@interface setCell1 : UITableViewCell
@property (nonatomic,strong) UIImageView *user_image;
@property (nonatomic,strong) UILabel *name_label;
@property (nonatomic,strong) UILabel *phone_label;
@property (nonatomic,strong) UILabel *language_label;
-(void)setCellDate:(setModel *)order;
@end
