//
//  infoTableViewCell2.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoTableViewCell2 : UITableViewCell
@property (nonatomic,strong) UILabel *m_label1;
@property (nonatomic,strong) UILabel *m_label2;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
