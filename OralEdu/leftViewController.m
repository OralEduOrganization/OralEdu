//
//  leftViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "leftViewController.h"
#import "AppDelegate.h"
#import "homeViewController.h"
#import "leftCell.h"
#import "setViewController.h"
//#import "leftView.h"
#import "leftviewModel.h"
#import "materViewController.h"
#import "aboutViewController.h"
#import "HttpTool.h"
@interface leftViewController ()
@property (nonatomic,strong) UITableView *left_tableview;
@property (nonatomic,strong) NSMutableArray *leftarr;
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) NSMutableArray *leftviewarr;
@property (nonatomic,strong) UIImageView *user_image;
@property (nonatomic,strong) UILabel *login_label;
@property (nonatomic,strong) NSMutableArray *pic_arr;
@property (nonatomic,strong) NSString *url1;
@property (nonatomic,strong) NSString *name1;
@end

@implementation leftViewController
{
    NSIndexPath *selectedIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _leftarr = [NSMutableArray arrayWithObjects:@"主页",@"素材库",@"设置", @"关于我们",nil];
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    if (name==nil) {
        [self loadDataFromWeb];
    }
    else
    {
        [self loadDataFromWeb];
    }
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groud3"]];
    [self.view addSubview:self.left_tableview];
    [self.view addSubview:self.user_image];
    [self.view addSubview:self.login_label];
    self.pic_arr = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"主页icon"],[UIImage imageNamed:@"心"],[UIImage imageNamed:@"设置齿轮"],[UIImage imageNamed:@"关于"], nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];

}

-(void)login{
    [self loadDataFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.user_image.frame = CGRectMake(70, 70, 130, 130);
    _left_tableview.frame = CGRectMake(0, 300, self.view.frame.size.width, 80 * 3);
    self.login_label.frame = CGRectMake(80, 220, 100, 40);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    if (name==nil) {
        leftviewModel *leftm = [[leftviewModel alloc] initWithPicurl:@"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006cxmWbjw8evactf4t2ij30u00u0jtj.jpg" Name:@"涛桑" Identity:@"老师" Signature:@"阿迪耐克 i 恩老师的课分离出来才能，；OK吃呢吗肯定是短裤 v 难受；"];
        self.leftviewarr = [NSMutableArray array];
        [self.leftviewarr addObject:leftm];
        self.login_label.text = @"请登录";
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
            NSLog(@"url111 = %@",_url1);
            NSLog(@"name111 = %@",_name1);
            leftviewModel *leftm = [[leftviewModel alloc] initWithPicurl:_url1 Name:_name1 Identity:@"老师" Signature:@"阿迪耐克 i 恩老师的课分离出来才能，；OK吃呢吗肯定是短裤 v 难受；"];
            self.leftviewarr = [NSMutableArray array];
            [self.leftviewarr addObject:leftm];
            NSURL *url = [NSURL URLWithString:_url1];
            _user_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            self.login_label.text = @"登录成功";

            
        } failure:^(NSError *error) {
            NSLog(@"失败");
        }];

        
    }
    
}

#pragma mark - getters

-(UITableView *)left_tableview
{
    if(!_left_tableview)
    {
        _left_tableview = [[UITableView alloc] init];
        _left_tableview.backgroundColor = [UIColor clearColor];
        _left_tableview.delegate = self;
        _left_tableview.dataSource = self;
        _left_tableview.scrollEnabled =NO;
        _left_tableview.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
    }
    return _left_tableview;
}

-(UIImageView *)user_image
{
    if(!_user_image)
    {
        _user_image = [[UIImageView alloc] init];
        _user_image.backgroundColor = [UIColor greenColor];
        _user_image.layer.masksToBounds = YES;
        _user_image.layer.cornerRadius = 65;
        leftviewModel *model = self.leftviewarr[0];
        NSURL *url = [NSURL URLWithString:model.leftpic_urlstr];
        _user_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    return _user_image;
}

-(UILabel *)login_label
{
    if(!_login_label)
    {
        _login_label = [[UILabel alloc] init];
        //_login_label.backgroundColor = [UIColor greenColor];
        _login_label.textAlignment = NSTextAlignmentCenter;
        _login_label.text = @"请登陆";
    }
    return _login_label;
}




#pragma mark UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"leftcell";
    leftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[leftCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor =[UIColor clearColor];
        cell.m_label.text = self.leftarr[indexPath.row];
        cell.m_label.textColor = [UIColor whiteColor];
        cell.m_imageview.image = self.pic_arr[indexPath.row];
    }
 
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//点击cell跳转界面
#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    //update content view controller with setContentViewController
    [itrSideMenu hideMenuViewController];
    selectedIndexPath = indexPath;
}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController{
    
    NSLog(@"didHideMenuViewController: %@ isMenuVisible <%d>", NSStringFromClass([menuViewController class]), (int)sideMenu.isLeftMenuVisible );
    
    if (selectedIndexPath.row == 0) {
        [sideMenu setContentViewController:[[[UINavigationController alloc] initWithRootViewController:[homeViewController alloc]] init]];
    }
    else if(selectedIndexPath.row ==1){
        [sideMenu setContentViewController:[[[UINavigationController alloc] initWithRootViewController:[ materViewController alloc]] init]];
    }
    else if(selectedIndexPath.row ==2){
        [sideMenu setContentViewController:[[[UINavigationController alloc] initWithRootViewController:[setViewController  alloc]] init]];
    }
    else if (selectedIndexPath.row == 3)
    {
        [sideMenu setContentViewController:[[[UINavigationController alloc] initWithRootViewController:[aboutViewController  alloc]] init]];
    }
}
@end
