//
//  setModel.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface setModel : NSObject
@property (nonatomic,strong) NSString *pic_imageurlstr;
@property (nonatomic,strong) NSString *name_str;
@property (nonatomic,strong) NSString *signature_str;
- (instancetype)initWithPicurl:(NSString *)setview_url
                          Name:(NSString *)setview_name
                     Signature:(NSString *)setview_signature;

@end
