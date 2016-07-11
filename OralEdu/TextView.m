//
//  TextView.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "TextView.h"

@implementation TextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.user_text];
        [self addSubview:self.pass_text];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.user_text.frame= CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height / 2);
    self.pass_text.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2);
}


#pragma mark - getters

-(UITextField *)user_text
{
    if(!_user_text)
    {
        _user_text = [[UITextField alloc] init];
        _user_text.backgroundColor = [UIColor whiteColor];
        _user_text.delegate = self;
        _user_text.borderStyle = UITextBorderStyleBezel;
        _user_text.placeholder = @"请输入帐号";
        _user_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _user_text.returnKeyType =UIReturnKeyGo;
        _user_text.leftView = self.user_image;
        _user_text.leftViewMode = UITextFieldViewModeAlways;
    }
    return _user_text;
}

-(UITextField *)pass_text
{
    if(!_pass_text)
    {
        _pass_text = [[UITextField alloc] init];
        _pass_text.backgroundColor = [UIColor whiteColor];
        _pass_text.delegate = self;
        _pass_text.borderStyle = UITextBorderStyleBezel;
        _pass_text.placeholder = @"请输入密码";
        _pass_text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pass_text.returnKeyType =UIReturnKeyGo;
        _pass_text.leftView = self.password_image;
        _pass_text.leftViewMode = UITextFieldViewModeAlways;
        _pass_text.secureTextEntry = YES;
    }
    return _pass_text;
}

-(UIImageView *)user_image
{
    if(!_user_image)
    {
        _user_image = [[UIImageView alloc] init];
        //_uset_image.backgroundColor = [UIColor greenColor];
        _user_image.image = [UIImage imageNamed:@"phone1"];
        _user_image.frame = CGRectMake(20, 10, 30, 30);
    }
    return _user_image;
}

-(UIImageView *)password_image
{
    if(!_password_image)
    {
        _password_image = [[UIImageView alloc] init];
        // _password_image.backgroundColor = [UIColor greenColor];
        _password_image.image = [UIImage imageNamed:@"lock1"];
        _password_image.frame = CGRectMake(20, 10, 30, 30);
        
    }
    return _password_image;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
