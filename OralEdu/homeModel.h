//
//  homeModel.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject
@property (nonatomic,strong) NSString *person_imageurl;


@property (nonatomic,strong) NSString *home_head_imageurl;
@property (nonatomic,strong) NSString *home_name;
@property (nonatomic,strong) NSString *home_time;
@property (nonatomic,strong) NSString *home_infomation;
@property (nonatomic,strong) NSString *home_phone;

- (instancetype)initWithhome_head_imageurl:(NSString *)home_head_imageurl
                                 home_name:(NSString *)home_name
                                 home_time:(NSString *)home_time;
@end
