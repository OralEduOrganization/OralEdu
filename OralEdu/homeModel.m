//
//  homeModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "homeModel.h"

@implementation homeModel
- (instancetype)initWithhome_head_imageurl:(NSString *)home_head_imageurl
                                 home_name:(NSString *)home_name
                                 home_time:(NSString *)home_time

{
    self = [super init];
    if (self) {
        _home_head_imageurl = home_head_imageurl;
        _home_name = home_name;
        _home_time = home_time;
    }
    return self;
}
@end
