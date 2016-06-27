//
//  titleModel.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface titleModel : NSObject
@property (nonatomic,strong) NSString *title_imageurl;
@property (nonatomic,strong) NSString *title_name;
- (instancetype)initWithtitle_imageurl:(NSString *)title_imageurl
                            title_name:(NSString *)title_name;
@end
