//
//  searchcell.h
//  OralEdu
//
//  Created by 温丹华 on 12/7/16.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchcell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UILabel *xingming_label;
@property (nonatomic,strong) UILabel *identity_label;
@property (nonatomic,strong) UILabel *intro_label;
@property (nonatomic,strong) UITextView *in_text;
@property (nonatomic,strong) UIImageView *head_image;
@property (nonatomic,strong) UIView *line_view;
@end
