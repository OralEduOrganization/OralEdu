//
//  TextView.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *user_text;
@property (nonatomic,strong) UITextField *pass_text;
@property (nonatomic,strong) UIImageView *user_image;
@property (nonatomic,strong) UIImageView *password_image;
@end
