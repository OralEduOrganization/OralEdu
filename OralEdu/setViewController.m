//
//  setViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setViewController.h"
#import "aboutViewController.h"
#import "AppDelegate.h"
#import "setModel.h"
#import "myinfoViewController.h"
#import "setCell1.h"
#import "setCell3.h"
#import "myinfoViewController.h"
#import "passwordViewController.h"
#import "IndividualitysignatureViewController.h"
#import "mobilephoneViewController.h"
#import "feedbackViewController.h"
#import "HttpTool.h"
#import "MBProgressHUD.h"
static NSString *cellIdentfid = @"setcell1";
static NSString *cellIdentfid2 = @"setcell2";
static NSString *cellIdentfid3 = @"setcell3";

@interface setViewController ()
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UITableView *setTableview;
@property (nonatomic,strong) NSMutableArray *setarr;
@property (nonatomic,strong) NSMutableArray *modelarr;
@property (nonatomic,strong) UIImageView *user_image;
@property (nonatomic,strong) NSMutableArray *image_arr;
@property (nonatomic,strong) NSString *url1;
@property (nonatomic,strong) NSString *name1;
@end

@implementation setViewController
{
    NSInteger *chat;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"bai"] forState:UIControlStateNormal];
    self.view.backgroundColor =UIColorFromRGB(0XE6E6E7);
    [self loadDataFromWeb];
    self.navitionBar.title_label.text = @"设置";
    [self.view addSubview:self.setTableview];
    [self.setTableview registerClass:[setCell3 class] forCellReuseIdentifier:cellIdentfid3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.setTableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    
    self.setarr = [NSMutableArray arrayWithObjects:@"身份认证",@"修改手机号",@"修改密码",nil];
    self.image_arr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"认证"],[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"账单"], nil];
    if (name==nil) {
        self.modelarr = [NSMutableArray array];

        self.modelarr = [NSMutableArray array];
        setModel *smodel = [[setModel alloc] initWithPicurl:@"http://img.zcool.cn/community/01096455d4612e32f875a132accf76.jpg" Name:@"无" phone:@"无"];
        [self.modelarr addObject:smodel];
        [self.setTableview reloadData];
    }
    else
    {
    
    NSDictionary *para=@{@"user_moblie":name};
    [HttpTool postWithparamsWithURL:@"UserHomepage/HomepageShow?" andParam:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.url1 = [[NSString alloc] init];
        self.name1 = [[NSString alloc] init];
        
        NSLog(@"dic = %@",dic);
        
        NSDictionary *dit = [dic objectForKey:@"data"];
        
        NSLog(@"dit = %@",dit);
        self.url1 = [dit objectForKey:@"url"];
        self.name1 = [dit objectForKey:@"user_nickname"];
        NSLog(@"url = %@",_url1);
        NSLog(@"name = %@",_name1);
        
        
        self.modelarr = [NSMutableArray array];
        setModel *smodel = [[setModel alloc] initWithPicurl:_url1 Name:_name1 phone:name];
        [self.modelarr addObject:smodel];
        [self.setTableview reloadData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"失败");
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"请检查网络设置";
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperViewOnHide];
        }];
    }];
    }
    
}

#pragma mark - gerrers

-(UITableView *)setTableview
{
    if(!_setTableview)
    {
        _setTableview = [[UITableView alloc] init];
        _setTableview.dataSource = self;
        _setTableview.delegate = self;
        _setTableview.tableFooterView = [[UIView alloc]init];
        _setTableview.backgroundColor = [UIColor clearColor];
        _setTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _setTableview;
}

#pragma mark - UItableView DateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 3;
    }
    else if (section ==2)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 )
    {
        setCell1 *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid];
        
            cell = [[setCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid];
            [cell setCellDate:self.modelarr[indexPath.row]];
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        return cell;
    }
    
    setCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid3 forIndexPath:indexPath];
    if(indexPath.section == 1)
    {
        UIImage *image=self.image_arr[indexPath.row];
        CGSize size=cell.viewimage.frame.size;
        cell.viewimage.image=[image imageByScalingToSize:size];
        cell.labeltext.text = self.setarr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section == 2)
    {
        UIImage *image=[UIImage imageNamed:@"help"];
        CGSize size=cell.viewimage.frame.size;
        cell.viewimage.image=[image imageByScalingToSize:size];
        cell.labeltext.text = @"帮助与反馈";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section == 3)
    {
        UIImage *image=[UIImage imageNamed:@"clean"];
        CGSize size=cell.viewimage.frame.size;
        cell.viewimage.image=[image imageByScalingToSize:size];
        cell.labeltext.text = @"清理缓存";
        return cell;
    }
    return nil;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat height11 = [UIScreen mainScreen].bounds.size.height;
        return (height11*0.18);
    }
    else
    {
        return 40.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // return @"标题";
    if (section == 0) {
        return @"";
    }else
    {
        return @"   ";
    }
}

//点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        myinfoViewController *myinfoVC = [[myinfoViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
        [self.navigationController pushViewController:myinfoVC animated:YES];
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row==1) {
            mobilephoneViewController *mobileVC = [[mobilephoneViewController alloc] initWithTitle:@"修改手机号" isNeedBack:YES btn_image:nil];
            [self.navigationController pushViewController:mobileVC animated:YES];
        }
        
        if (indexPath.row==2) {
                    passwordViewController *passVC = [[passwordViewController alloc] initWithTitle:@"修改密码" isNeedBack:YES btn_image:nil];
            
                    [self.navigationController pushViewController:passVC animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        feedbackViewController *feedbackVC = [[feedbackViewController alloc] initWithTitle:@"帮助与反馈" isNeedBack:YES btn_image:nil];

        [self.navigationController pushViewController:feedbackVC animated:YES];
        NSLog(@"帮助与反馈");
    }
    else if(indexPath.section==3)
    {
        NSLog(@"清理缓存");
        [self cache];
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

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        //        //取得一个目录下得所有文件名
        //        NSArray *files = [manager subpathsAtPath:filePath];
        //        NSLog(@"files1111111%@ == %ld",files,files.count);
        //
        //        // 从路径中获得完整的文件名（带后缀）
        //        NSString *exe = [filePath lastPathComponent];
        //        NSLog(@"exeexe ====%@",exe);
        //
        //        // 获得文件名（不带后缀）
        //        exe = [exe stringByDeletingPathExtension];
        //
        //        // 获得文件名（不带后缀）
        //        NSString *exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        //        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

@end
