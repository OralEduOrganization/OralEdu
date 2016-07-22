//
//  hisModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "hisModel.h"

@implementation hisModel
-(instancetype)initWithXingming:(NSString *)name
                       identity:(NSString *)identity
                             in:(NSString *)sigen
                           head:(NSString *)pic_url
                         mobile:(NSString *)mobile
{
    self = [super init];
    if (self) {
        _name = name;
        _identity = identity;
        _sigen = sigen;
        _pic_url = pic_url;
        _mobile = mobile;
    }
    return  self;
}
@end
