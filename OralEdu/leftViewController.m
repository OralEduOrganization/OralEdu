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
#import "leftView.h"
#import "leftviewModel.h"
#import "materViewController.h"
@interface leftViewController ()
@property (nonatomic,strong) UITableView *left_tableview;
@property (nonatomic,strong) NSMutableArray *leftarr;
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) leftView *leftV;
@property (nonatomic,strong) NSMutableArray *leftviewarr;

@end

@implementation leftViewController
{
    NSIndexPath *selectedIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromWeb];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud2.jpg"]];
    //self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.left_tableview];
    [self.view addSubview:self.leftV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.leftV.frame = CGRectMake(80, 80, 230, 200);
    _left_tableview.frame = CGRectMake(0, 360, self.view.frame.size.width, 80 * 3);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    _leftarr = [NSMutableArray arrayWithObjects:@"主页",@"素材库",@"设置", nil];
    
    
    
    leftviewModel *leftm = [[leftviewModel alloc] initWithPicurl:@"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006cxmWbjw8evactf4t2ij30u00u0jtj.jpg" Name:@"涛桑" Identity:@"老师" Signature:@"阿迪耐克 i 恩老师的课分离出来才能，；OK吃呢吗肯定是短裤 v 难受；"];
    self.leftviewarr = [NSMutableArray array];
    [self.leftviewarr addObject:leftm];
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
    }
    return _left_tableview;
}

-(leftView *)leftV
{
    if(!_leftV)
    {
        _leftV = [[leftView alloc] init];
        //_leftV.backgroundColor = [UIColor lightGrayColor];
        leftviewModel *model = self.leftviewarr[0];
        _leftV.name_label.text = model.leftname_str;
        _leftV.identity_label.text = model.leftidentity_str;
        _leftV.signature_label.text = model.leftsignature_str;
        NSURL *url = [NSURL URLWithString:model.leftpic_urlstr];
        _leftV.pic_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    return _leftV;
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
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
}
@end
