//
//  homeViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "homeViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "loginViewController.h"
#import "homeModel.h"
#import "homeCell.h"
#import "titleModel.h"
#import "CustomnavView.h"
#import "infomationViewController.h"
#import "faceVideoViewController.h"
#import "SVPullToRefresh.h"

@interface homeViewController ()
@property (nonatomic,strong) UITableView *homeTableview;
@property (nonatomic,strong) NSMutableArray *homearr;
@property (nonatomic,strong) NSMutableArray *titlearr;
@property (nonatomic,strong) homeCell *cell;
@property (nonatomic,strong) UIButton *m_btn;
@property (nonatomic,strong) UITableViewRowAction *rowAction1;
@property (strong,nonatomic) UIRefreshControl *refresh;

@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //验证登录信息
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    if (name == nil) {
        
        [self go_login];
    }
    
    
    //数据加载
     [self loadDataFromWeb];
    //导航栏加载
    self.navitionBar.left_btn.layer.masksToBounds = YES;
    self.navitionBar.left_btn.layer.cornerRadius = 15;
    //[self.navitionBar.right_btn setTitle:@"add" forState:UIControlStateNormal];
    [self.navitionBar.right_btn setImage:[UIImage imageNamed:@"加号.png"] forState:UIControlStateNormal];
    titleModel *titlein = self.titlearr[0];
    NSURL *url = [NSURL URLWithString:titlein.title_imageurl];
     [self.navitionBar.left_btn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]] forState:UIControlStateNormal];
    self.navitionBar.title_label.text = titlein.title_name;
    
   // [self.view addSubview:self.m_btn];
    [self.view addSubview:self.homeTableview];
    
    __weak homeViewController *weakSelf = self;
    // setup pull-to-refresh
    [self.homeTableview addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.homeTableview triggerPullToRefresh];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.homeTableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    //self.m_btn.frame = CGRectMake(20, 500, 100, 50);
}


- (void)insertRowAtTop {
    __weak homeViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.homeTableview beginUpdates];
        //[weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
//        [weakSelf.homeTableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.homeTableview endUpdates];
        
        [weakSelf.homeTableview.pullToRefreshView stopAnimating];
    });
}




#pragma  mark - 数据源方法
-(void)loadDataFromWeb
{
    self.homearr = [NSMutableArray array];
    //实际上这里进行网络调用
    //数据装
    homeModel *order1 = [[homeModel alloc] initWithhome_head_imageurl:@"http://tva2.sinaimg.cn/crop.72.0.1007.1007.1024/6a0bf347jw8er5bdo5q8zj20u00rz7a9.jpg" home_name:@"涛桑" home_time:@"11:20"];
    [_homearr addObject:order1];
    homeModel *order2 = [[homeModel alloc] initWithhome_head_imageurl:@"http://tva2.sinaimg.cn/crop.72.0.1007.1007.1024/6a0bf347jw8er5bdo5q8zj20u00rz7a9.jpg" home_name:@"李老师" home_time:@"13:50"];
    [_homearr addObject:order2];
    
    //导航栏数据装
    self.titlearr = [NSMutableArray array];
    titleModel *tinfo1 = [[titleModel alloc] initWithtitle_imageurl:@"http://ww2.sinaimg.cn/crop.0.0.1080.1080.1024/b724073bjw8euog8n84bqj20u00u0jtu.jpg" title_name:@"涛桑"];
    [_titlearr addObject:tinfo1];
}

#pragma mark - getters

-(UITableView *)homeTableview
{
    if(!_homeTableview)
    {
        _homeTableview = [[UITableView alloc] init];
        _homeTableview.dataSource = self;
        _homeTableview.delegate = self;
        _homeTableview.tableFooterView = [[UIView alloc]init];

        _homeTableview.backgroundColor = [UIColor whiteColor];
        _homeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _homeTableview;
}

-(UIButton *)m_btn
{
    if(!_m_btn)
    {
        _m_btn = [[UIButton alloc] init];
        //_m_btn.backgroundColor = [UIColor blueColor];
        [_m_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_m_btn setTitle:@"测试登录" forState:UIControlStateNormal];
        [_m_btn addTarget:self action:@selector(go_login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _m_btn;
}


#pragma mark - UItableView DateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.homearr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    _cell.layer.masksToBounds = YES;
    [_cell.layer setBorderWidth:1];
    _cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!_cell)
    {
        _cell = [[homeCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [_cell setCellDate:self.homearr[indexPath.row]];
        
        [_cell.home_btn addTarget:self action:@selector(toinfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        // 1. 更新数据
        
        [_homearr removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
        // 删除一个置顶按钮
    
        UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    
            NSLog(@"点击了置顶");
            // 1. 更新数据
    
            [_homearr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
            
            // 2. 更新UI
    
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
            [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    
        }];
    
        topRowAction.backgroundColor = [UIColor blueColor];
    
    // 添加一个更多按钮
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了更多");
        
        
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 将设置好的按钮放到数组中返回
    
     return @[deleteRowAction, topRowAction, moreRowAction];
    
    //return @[deleteRowAction,moreRowAction];
    
}


//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    faceVideoViewController *myFaceVideoController=[[faceVideoViewController alloc]init];
    myFaceVideoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:myFaceVideoController animated:YES completion:^{
        
    }];
}

#pragma mark - 响应事件
- (void) presentLeftMenuViewController{
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}
-(void)go_login
{
    loginViewController *loginVC = [[loginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
}
-(void)rightbtnClick
{
    SearchViewController *SearchVC = [[SearchViewController alloc] initWithTitle:@"第二" isNeedBack:YES btn_image:nil];
    [self.navigationController pushViewController:SearchVC animated:YES];
}
-(void)leftbtnClick
{
    [self presentLeftMenuViewController];
}
-(void)toinfoBtnClick
{
    infomationViewController *infoVC = [[infomationViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
    [self.navigationController pushViewController:infoVC animated:YES];
}
@end
