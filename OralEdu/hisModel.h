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


@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *identity;
@property (nonatomic,strong)NSString *sigen;
@property (nonatomic,strong)NSString *pic_url;
@property (nonatomic,strong)NSString *mobile;

-(instancetype)initWithXingming:(NSString *)name
                       identity:(NSString *)identity
                             in:(NSString *)sigen
                           head:(NSString *)pic_url
                         mobile:(NSString *)mobile;




@end
