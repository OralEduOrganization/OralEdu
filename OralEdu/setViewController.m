//
//  setViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setViewController.h"
#import "setView.h"
#import "aboutViewController.h"
#import "AppDelegate.h"
#import "setModel.h"
#import "myinfoViewController.h"
@interface setViewController ()
@property (nonatomic,strong) UITableView *setTableview;
@property (nonatomic,strong) NSMutableArray *setarr;
@property (nonatomic,strong) setView *setV;
@property (nonatomic,strong) NSMutableArray *modelarr;
@property (nonatomic,strong) NSString *cache_str;

@end

@implementation setViewController
{
    NSInteger *chat;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor grayColor];
    [self loadDataFromWeb];
    self.navitionBar.title_label.text = @"设置";
    [self.view addSubview:self.setTableview];
    [self.view addSubview:self.setV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.setTableview.frame = CGRectMake(0, 280, [UIScreen mainScreen].bounds.size.width, 140);
    self.setV.frame = CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width, 150);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    self.setarr = [NSMutableArray arrayWithObjects:@"清理缓存",@"关于我们",nil];
    self.modelarr = [NSMutableArray array];
    setModel *smodel = [[setModel alloc] initWithPicurl:@"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006cxmWbjw8evactf4t2ij30u00u0jtj.jpg" Name:@"涛桑" Signature:@"老师"];
    [self.modelarr addObject:smodel];
}
#pragma mark - gerrers
-(UITableView *)setTableview
{
    if(!_setTableview)
    {
        _setTableview = [[UITableView alloc] init];
        //_setTableview.backgroundColor = [UIColor orangeColor];
        _setTableview.dataSource = self;
        _setTableview.delegate = self;
        _setTableview.backgroundColor = [UIColor clearColor];
        _setTableview.scrollEnabled =NO;
    }
    return _setTableview;
}

-(setView *)setV
{
    if(!_setV)
    {
        _setV = [[setView alloc] init];
        _setV.layer.borderWidth = 1;
       // _setV.backgroundColor = [UIColor greenColor];
        setModel *smol = self.modelarr[0];
        _setV.name_label.text = smol.name_str;
        _setV.accound_label.text = smol.signature_str;
        NSURL *url = [NSURL URLWithString:smol.pic_imageurlstr];
        _setV.pic_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
            UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextVC)];
            TapGestureTecognizer.cancelsTouchesInView=NO;
            [_setV addGestureRecognizer:TapGestureTecognizer];
        
        
    }
    return _setV;
}


#pragma mark - UItableView DateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.setarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentfid = @"setcell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid];
        cell.textLabel.text = self.setarr[indexPath.row];
        cell.textLabel.textAlignment =  NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    if(indexPath.row==0)
    {
         NSLog(@"清理缓存");
        [self cache];
    }
    else
    {
        aboutViewController *aboutVC = [[aboutViewController alloc] initWithTitle:@"关于我们" isNeedBack:YES btn_image:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self presentLeftMenuViewController];
}

- (void) presentLeftMenuViewController{
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

-(void)nextVC
{
    myinfoViewController *myinfoVC = [[myinfoViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
    [self.navigationController pushViewController:myinfoVC animated:YES];
}
//清理缓存
-(void)cache
{
    UIAlertController *controll = [UIAlertController alertControllerWithTitle:@"清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           NSLog(@"files :%ld",[files count]);
                           
                           
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
        
        
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"back" style:    UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controll addAction:action1];
    [controll addAction:action2];
    
    [self presentViewController:controll animated:YES completion:nil];
}

-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
}

@end
