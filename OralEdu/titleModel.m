//
//  titleModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "titleModel.h"

@implementation titleModel
- (instancetype)initWithtitle_imageurl:(NSString *)title_imageurl
                            title_name:(NSString *)title_name

{
    self = [super init];
    if (self) {
        _title_imageurl = title_imageurl;
        _title_name = title_name;
    }
    return self;
}
@end
