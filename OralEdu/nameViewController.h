//
//  nameViewController.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
@interface nameViewController : BaseViewController<UITextFieldDelegate>

-(void)setName:(NSString *)str;

@end
