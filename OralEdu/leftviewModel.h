//
//  leftviewModel.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftviewModel : UIView
@property (nonatomic,strong) NSString *leftpic_urlstr;
@property (nonatomic,strong) NSString *leftname_str;
@property (nonatomic,strong) NSString *leftidentity_str;
@property (nonatomic,strong) NSString *leftsignature_str;

- (instancetype)initWithPicurl:(NSString *)leftview_url
                      Name:(NSString *)leftview_name
                       Identity:(NSString *)leftview_identity
                   Signature:(NSString *)leftview_signature;
@end
