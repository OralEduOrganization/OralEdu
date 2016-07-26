//
//  AppDelegate.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITRAirSideMenu.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAccelerometerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property ITRAirSideMenu *itrAirSideMenu;


@end

