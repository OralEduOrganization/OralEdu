//
//  APIClient.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/30.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"

@interface APIClient :AFHTTPSessionManager

+(instancetype)sharedClient;

@end
