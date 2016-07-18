//
//  hisModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "hisModel.h"

@implementation hisModel
-(instancetype)initWithXingming:(NSString *)xingming
                       identity:(NSString *)identity
                             in:(NSString *)in_text
                           head:(NSString *)head
{
    self = [super init];
    if (self) {
        _xingming = xingming;
        _identity = identity;
        _in_text = in_text;
        _head = head;
    }
    return  self;
}
@end
