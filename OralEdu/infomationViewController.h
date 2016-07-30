//
//  infomationViewController.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface infomationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(void)getInfo:(NSString *)phone;

@property (nonatomic,assign)NSString *mark;

@end
