//
//  infoTableViewCell1.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoTableViewCell1 : UITableViewCell
@property (nonatomic,strong) UIImageView *pic_imageview;
@property (nonatomic,strong) UILabel *m_label;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
