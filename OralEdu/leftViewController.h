//
//  leftViewController.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"
@interface leftViewController : UIViewController<ITRAirSideMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, assign) int selectedIndex;
@end
