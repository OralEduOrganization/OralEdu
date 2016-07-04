//
//  setModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setModel.h"

@implementation setModel
- (instancetype)initWithPicurl:(NSString *)setview_url
                          Name:(NSString *)setview_name
                     phone:(NSString *)setview_phone
                      language:(NSString *)setview_language
{
    self = [super init];
    if (self) {
        _pic_imageurlstr = setview_url;
        _name_str = setview_name;
        _phone_str = setview_phone;
        _language_str = setview_language;
    }
    return self;
}

@end
