//
//  ZCYlocation.m
//  ZCYlocation
//
//  Created by 张春雨 on 16/6/20.
//  Copyright © 2016年 张春雨. All rights reserved.
//


#import "ZCYlocation.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface ZCYlocation()
@property float X;
@property float Y;
@end

@implementation ZCYlocation
//封装CGRect
CGRect CYRectMake(NSString * x , NSString * y , NSString * width , NSString * height){
    CGRect rect;
    rect.origin.x = [ZCYlocation get_Value:x :[ZCYlocation X]];
    rect.origin.y = [ZCYlocation get_Value:y :[ZCYlocation Y]];
    rect.size.width = [ZCYlocation get_Value:width :[ZCYlocation X]];
    rect.size.height = [ZCYlocation get_Value:height :[ZCYlocation Y]];
    return rect;
}


//计算比例，这里以iPhone6为准
+(CGFloat)X{
    return ScreenHeight == 667 ? 1.0 : ScreenWidth/375.0;
}
+(CGFloat)Y{
    return ScreenHeight == 667 ? 1.0 : ScreenHeight/667.0;
}


//计算大小和位置
+(CGFloat)get_Value:(NSString *)str :(CGFloat)proportion{
    if ([str hasSuffix:@"abs"]) { //绝对值
        return [str doubleValue];
    }
    if ([str rangeOfString:@"equ"].location !=NSNotFound){ //选择比例为参考
        NSRange range = [str rangeOfString:@"equ_"];
        NSString * temp = [str substringFromIndex:range.location+1];
        if ([temp isEqualToString:@"x"])
            return [str doubleValue] * [ZCYlocation X];
        return [str doubleValue] * [ZCYlocation Y];
    }
    if ([str hasSuffix:@"na"]) { //抛去固定宽
        NSRange range =[str rangeOfString:@"_"];
        CGFloat offset = [[str substringFromIndex:range.location+1]doubleValue];\
        return  ([str doubleValue]-offset) * proportion +offset;
    }
    return [str doubleValue] * proportion; //拉伸比例
}

@end
