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
#import "voiceViewController.h"
#import "HttpTool.h"
#import "MBProgressHUD+XMG.h"
@interface homeViewController ()
{
     int currentClickIndex;
}
@property (nonatomic,strong) UITableView *homeTableview;
@property (nonatomic,strong) NSMutableArray *homearr;
@property (nonatomic,strong) NSMutableArray *titlearr;
@property (nonatomic,strong) homeCell *cell;
@property (nonatomic,strong) UIButton *m_btn;
@property (nonatomic,strong) UITableViewRowAction *rowAction1;
@property (strong,nonatomic) UIRefreshControl *refresh;
@property (nonatomic,strong) NSString *url1;
@property (nonatomic,strong) NSString *name1;
@property (nonatomic,strong) homeModel *model;
@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentClickIndex = -1;
  
    //导航栏加载
    self.navitionBar.left_btn.layer.masksToBounds = YES;
    self.navitionBar.left_btn.layer.cornerRadius = 15;
    [self.navitionBar.right_btn setImage:[UIImage imageNamed:@"加号.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.homeTableview];
    __weak homeViewController *weakSelf = self;
    // setup pull-to-refresh
    [self.homeTableview addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:@"login" object:nil];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
  
}

-(void)login{
    [self loadDataFromWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.homeTableview triggerPullToRefresh];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.homeTableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    //验证登录信息
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    if (name == nil) {
        [self go_login];
        //[self loadDataFromWeb];
    }else{
        //数据加载
        [self loadDataFromWeb];
    }
  
}

- (void)insertRowAtTop {
    __weak homeViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.homeTableview beginUpdates];
 
        
        [weakSelf.homeTableview.pullToRefreshView stopAnimating];
        
    });
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    if (name==nil) {
      self.navitionBar.title_label.text = @"请登录";
    [self.navitionBar.left_btn setTitle:@"请登录" forState:UIControlStateNormal];
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
        self.titlearr = [NSMutableArray array];
        titleModel *tinfo1 = [[titleModel alloc] initWithtitle_imageurl:_url1 title_name:_name1];
        [_titlearr addObject:tinfo1];
        titleModel *titlein = self.titlearr[0];
        NSURL *url = [NSURL URLWithString:titlein.title_imageurl];
        [self.navitionBar.left_btn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]] forState:UIControlStateNormal];
        self.navitionBar.title_label.text = titlein.title_name;
        self.navitionBar.title_label.text=_name1;
        
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
        //实际上这里进行网络调用
        if ([name isEqualToString:@""]) {
            self.homearr = [NSMutableArray array];
        }
        else
        {
            self.homearr = [NSMutableArray array];
        NSDictionary *para2=@{@"user_moblie":name};
        [HttpTool postWithparamsWithURL:@"Contact/UserContact?" andParam:para2 success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"dic11= %@",dic);
            
            NSArray *dit11 = [dic objectForKey:@"data"];
            
            NSLog(@"dit11 = %@",dit11);
            if ([[dic objectForKey:@"code"]isEqualToString:@"500"])
            {
                
            }
            else
            {
                for (int i=0; i<dit11.count; i++) {
                    
                    self.model=[[homeModel alloc]init];
                    
                    NSDictionary *aaa=dit11[i];
                    
                    self.model.home_name=aaa[@"user_nickname"];
                    self.model.home_head_imageurl = aaa[@"user_url"];
                    self.model.home_time = aaa[@"last_time"];
                    self.model.home_infomation = aaa[@"user_introduction"];
                    self.model.home_phone = aaa[@"user_moblie"];
                    
                    [self.homearr addObject:self.model];
                    [self.homeTableview reloadData];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"失败");
        }];
        }
    }
   
    
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
        _homeTableview.backgroundColor = [UIColor lightGrayColor];
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
        
        [_cell setCellClickBlock:^(NSString *str) {
            
            NSLog(@"%@",str);
            
            infomationViewController *infoVC = [[infomationViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
            
            [infoVC getInfo:str];
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }];
        
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
        homeModel *model=self.homearr[indexPath.row];
        NSString *str = model.home_phone;
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSDictionary *para=@{@"user_moblie":name,@"user_contacts":str};
        [HttpTool postWithparamsWithURL:@"Contacts/contactsDelete" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            
            [MBProgressHUD showSuccess:@"删除成功"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"请检查网络"];
            
        }];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    return @[deleteRowAction];
    
}


//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    
    
    
    voiceViewController *voiceController=[[voiceViewController alloc]init];
//    faceVideoViewController *myFaceVideoController=[[faceVideoViewController alloc]init];
//    myFaceVideoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:voiceController animated:YES completion:^{
//        
//    }];
    [self.navigationController pushViewController:voiceController animated:YES];
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

-(BOOL)shouldAutorotate
{
    return YES;
}
@end
