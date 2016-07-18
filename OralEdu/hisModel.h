//
//  hisModel.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hisModel : NSObject
@property NSString *history_arr;


@property (nonatomic,strong)NSString *xingming;
@property (nonatomic,strong)NSString *identity;
@property (nonatomic,strong)NSString *in_text;
@property (nonatomic,strong)NSString *head;

-(instancetype)initWithXingming:(NSString *)xingming
                       identity:(NSString *)identity
                             in:(NSString *)in_text
                           head:(NSString *)head;


@end
