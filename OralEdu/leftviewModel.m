//
//  leftviewModel.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "leftviewModel.h"

@implementation leftviewModel

- (instancetype)initWithPicurl:(NSString *)leftview_url
                          Name:(NSString *)leftview_name
                      Identity:(NSString *)leftview_identity
                     Signature:(NSString *)leftview_signature

{
    self = [super init];
    if (self) {
        _leftpic_urlstr = leftview_url;
        _leftname_str = leftview_name;
        _leftidentity_str = leftview_identity;
        _leftsignature_str = leftview_signature;
    }
    return self;
}

@end
