//
//  addressViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "addressViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface addressViewController ()
@property(nonatomic,strong)UILabel *textLabel;
@property (nonatomic , strong)CLLocationManager *locationManager;
@property (nonatomic , strong) UILabel *address_label;
@property (nonatomic , strong) UIButton *address_btn;
@property (nonatomic , strong) NSString *address_str;
@end

@implementation addressViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回.png"] forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"保存" forState:UIControlStateNormal];
    
    self.address_str = [[NSString alloc] init];
    
    [self.view addSubview:self.address_label];
    [self.view addSubview:self.address_btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.address_btn.frame = CGRectMake(10, 70, 50, 50);
    self.address_label.frame = CGRectMake(70, 70, 100, 50);
}

-(UIButton *)address_btn
{
    if(!_address_btn)
    {
        _address_btn = [[UIButton alloc] init];
        [_address_btn setImage:[UIImage imageNamed:@"address-iPhone"] forState:UIControlStateNormal];
        [_address_btn addTarget:self action:@selector(positioning) forControlEvents:UIControlEventTouchUpInside];
    }
    return _address_btn;
}

-(UILabel *)address_label
{
    if(!_address_label)
    {
        _address_label = [[UILabel alloc] init];
       // _address_label.backgroundColor = [UIColor orangeColor];
        _address_label.text = self.address_str;
    }
    return _address_label;
}

-(void)positioning
{
    self.locationManager=[[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10;
    
    [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    
    [self.locationManager startUpdatingLocation];//开启定位
}

- (void)locate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@提示 message:@定位不成功 ,请确认开启定位 delegate:nil cancelButtonTitle:@取消 otherButtonTitles:@确定, nil];
//        [alertView show];
        
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
            self.address_str = city;
            NSLog(@"定位完成:%@",self.address_str);
             self.address_label.text = self.address_str;
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightbtnClick
{
    [self saveaddress];
}

-(void)saveaddress
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改地址" message:@"您确定要修改地址吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
        //保存修改的地址
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];
}
@end
