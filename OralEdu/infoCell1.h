//
//  infoCell1.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoCell1 : UITableViewCell
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) UILabel *name_label;
@property (nonatomic,strong) UILabel *identity_label;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
;
@end
