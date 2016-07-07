//
//  BaseViewController.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomnavView.h"
@interface BaseViewController : UIViewController

@property (nonatomic,strong) CustomnavView *navitionBar;

-(instancetype)initWithTitle:(NSString *)title isNeedBack:(BOOL)IsNeed btn_image:(UIImage *)btn_image;
-(void)leftbtnClick;
-(void)rightbtnClick;
@end
