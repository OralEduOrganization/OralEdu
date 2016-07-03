//
//  ZCYlocation.h
//  ZCYlocation
//
//  Created by 张春雨 on 16/6/20.
//  Copyright © 2016年 张春雨. All rights reserved.
//


/*
 示例语法：
 x =  x*比例                           -----(无任何结尾 拉伸比例)
 x_abs =  x                           -----(abs结尾)
 x_64na = 包括恒定导航栏高度 64 + x*比例  -----(na结尾)
 y_equ_x  = y*(x的比例)                -----(equ_x/y结尾)
 
 */

#import <UIKit/UIKit.h>
@interface ZCYlocation : NSObject
+(CGFloat)X;
+(CGFloat)Y;
CGRect CYRectMake(NSString * x , NSString * y , NSString * width , NSString * height);
@end


