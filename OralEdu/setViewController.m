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
#import "setCell2.h"
#import "myinfoViewController.h"
#import "passwordViewController.h"
#import "HttpTool.h"
@interface setViewController ()
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
    self.setarr = [NSMutableArray arrayWithObjects:@"身份认证",@"修改手机号",@"修改密码",nil];
    self.image_arr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"认证"],[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"账单"], nil];
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
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
        
        //[MBProgressHUD hideHUD];

        self.modelarr = [NSMutableArray array];
        setModel *smodel = [[setModel alloc] initWithPicurl:_url1 Name:_name1 phone:name language:@"英文|日语|粤语"];
        [self.modelarr addObject:smodel];
        [self.setTableview reloadData];
        
        
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
    
    
 
    
    
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
        _setTableview.tableFooterView = [[UIView alloc]init];

        _setTableview.backgroundColor = [UIColor clearColor];
        _setTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _setTableview.scrollEnabled =NO;
    }
    return _setTableview;
}

#pragma mark - UItableView DateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 1;
    }
    else if(section == 2)
    {
        return 3;
    }
    else if (section ==3)
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
    static NSString *cellIdentfid = @"setcell1";
    static NSString *cellIdentfid2 = @"setcell2";
    static NSString *cellIdentfid3 = @"setcell3";
    static NSString *cellIdentfid4 = @"setcell4";
    static NSString *cellIdentfid5 = @"setcell5";

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
    else if (indexPath.section == 1)
    {
        setCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid2];
        
            cell = [[setCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid2];
            [cell.btn_01 setTitle:@"打赏" forState:UIControlStateNormal];
            [cell.btn_02 setTitle:@"打赏记录" forState:UIControlStateNormal];
            cell.record_label.text = @"$130";
        
        return cell;
    }
    else if(indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid3];
                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid3];
    
            cell.imageView.image = self.image_arr[indexPath.row];
            cell.textLabel.text = self.setarr[indexPath.row];
       
        return cell;
    }
    else if (indexPath.section == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid4];
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid4];
            cell.imageView.image = [UIImage imageNamed:@"help"];
            cell.textLabel.text = @"帮助与反馈";

        return cell;
    }else if(indexPath.section == 4)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfid5];
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfid5];
            cell.imageView.image = [UIImage imageNamed:@"clean"];
            cell.textLabel.text = @"清理缓存";
        
        return cell;
    }
    return nil;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120.0f;
    }
    else if(indexPath.section == 1)
    {
    return 70.0f;
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
    NSLog(@"aaa");
    
    if (indexPath.section == 0)
    {
        myinfoViewController *myinfoVC = [[myinfoViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
        [self.navigationController pushViewController:myinfoVC animated:YES];
    }
    else if (indexPath.section ==1 )
    {
        
    }
    else if(indexPath.section == 2)
    {
        
        
        
        if (indexPath.row==2) {
                    passwordViewController *passVC = [[passwordViewController alloc] initWithTitle:@"修改密码" isNeedBack:YES btn_image:nil];
                    [self.navigationController pushViewController:passVC animated:YES];
        }
        NSLog(@"身份认证");
    }
    else if (indexPath.section == 3)
    {
        NSLog(@"帮助与反馈");
    }
    else if(indexPath.section==4)
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
    UIAlertController *controll = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"该操作不可逆" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        //清除登录信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
