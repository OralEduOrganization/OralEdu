//
//  AVPlayView.h
//  OralEdu
//
//  Created by 王俊钢 on 16/7/29.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayView : UIView
- (id)initWithFrame:(CGRect)frame url:(NSString *)url;

- (void)play;

@end
