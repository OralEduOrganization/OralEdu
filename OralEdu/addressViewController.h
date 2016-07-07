//
//  addressViewController.h
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//


#import "ViewController.h"
#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface addressViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property(strong,nonatomic) CLLocationManager *myLocationManager;
@property(strong,nonatomic) CLGeocoder *myGeocoder;
@property(strong,nonatomic) CLLocation *myLocation;
@end
