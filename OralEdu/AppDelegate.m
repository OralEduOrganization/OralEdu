//
//  AppDelegate.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "AppDelegate.h"
#import "homeViewController.h"
#import "leftViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "iflyMSC/IFlyMSC.h"
#import "SearchViewController.h"

#define UIInterfaceOrientationIsPortrait(orientation)  ((orientation) == UIInterfaceOrientationPortrait || (orientation) == UIInterfaceOrientationPortraitUpsideDown)
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:[homeViewController alloc]] init];
    leftViewController *leftMenuViewController = [[leftViewController alloc] init];
    _itrAirSideMenu = [[ITRAirSideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController];
    
    _itrAirSideMenu.backgroundImage = [UIImage imageNamed:@"menu_bg"];
    
    //optional delegate to receive menu view status
    _itrAirSideMenu.delegate = leftMenuViewController;
    
    //content view shadow properties
    _itrAirSideMenu.contentViewShadowColor = [UIColor blackColor];
    _itrAirSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _itrAirSideMenu.contentViewShadowOpacity = 0.6;
    _itrAirSideMenu.contentViewShadowRadius = 12;
    _itrAirSideMenu.contentViewShadowEnabled = YES;
    
    //content view animation properties
    _itrAirSideMenu.contentViewScaleValue = 0.7f;
    _itrAirSideMenu.contentViewRotatingAngle = 30.0f;
    _itrAirSideMenu.contentViewTranslateX = 130.0f;
    
    //menu view properties
    _itrAirSideMenu.menuViewRotatingAngle = 30.0f;
    _itrAirSideMenu.menuViewTranslateX = 130.0f;
    
    self.window.rootViewController = _itrAirSideMenu;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"14797912782c8" withSecret:@"398b1d6e9521d5d868bae9812d60fff3"];
    
//    NSString *appid = @"577ca611";//自己申请的appId
//    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
//    [IFlySpeechUtility createUtility:initString];
    
    
    return YES;
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"com.test.static1"]){
       // NSArray *arr = @[@"hello 3D Touch"];
        NSLog(@"tuchn00001");
        
        
    }
    
    if([shortcutItem.type isEqualToString:@"com.test.static2"]){
        // NSArray *arr = @[@"hello 3D Touch"];
        NSLog(@"tuchn00002");
      
        
    }
    
    if([shortcutItem.type isEqualToString:@"com.test.static3"]){
        // NSArray *arr = @[@"hello 3D Touch"];
        NSLog(@"tuchn00003");
     
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
