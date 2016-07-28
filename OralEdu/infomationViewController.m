//
//  infomationViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infomationViewController.h"
#import "infoCell2.h"
#import "infoModel.h"
#import "ZCYlocation.h"
#import "faceVideoViewController.h"
#import "passwordViewController.h"
#import "MBProgressHUD.h"
#import "HttpTool.h"
#import "MBProgressHUD+XMG.h"
@interface infomationViewController ()
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) infoModel *model1;
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) UILabel *name_label;
@property (nonatomic,strong) UIButton *left_btn;
@property (nonatomic,strong) UIButton *go_viewbtn;
@property (nonatomic,strong) NSDictionary *pata;
@property (nonatomic,strong) NSString *aaa;
@property (nonatomic,strong) infoCell2 *cell;
@property (nonatomic,strong) NSString *userphone;
@end

@implementation infomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.navitionBar.left_btn removeFromSuperview];
    [self.navitionBar.right_btn setTitle:@"添加" forState:UIControlStateNormal];
    
    [self.view addSubview:self.infotableview];
    [self.view addSubview:self.pic_image];
    [self.view addSubview:self.name_label];
    [self.view addSubview:self.left_btn];
    [self.view addSubview:self.go_viewbtn];
    self.name_label.frame = CGRectMake((self.view.frame.size.width-100)/2, 70, 100, 30);
    [self.navitionBar.left_btn setTitle:@"个人信息" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.infotableview.frame = CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 120);
    self.left_btn.frame = CGRectMake(10, 50, 30, 30);
    self.pic_image.frame = CGRectMake(50, 30, 70, 70);
    self.go_viewbtn.frame = CGRectMake(15, 380, [UIScreen mainScreen].bounds.size.width-30, 50);
}

#pragma  mark - 数据源方法

//-(void)loadDataFromWeb
//{
//    _model1 = [[infoModel alloc] init];
//    _model1.pic_imageurlstr = @"http://ww1.sinaimg.cn/crop.3.45.1919.1919.1024/6b805731jw1em0hze051hj21hk1isn5k.jpg";
//    _model1.name_str = @"李老师";
//    _model1.address_str = @"新东方在职讲师，以带过超过100个申请出国的高中生，大学生。为大家圆一个出国梦";
//    _model1.identfid_str = @"老师";
//}

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] init];
        _infotableview.delegate = self;
        _infotableview.dataSource = self;
        _infotableview.scrollEnabled =NO;
    }
    return _infotableview;
}


-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
        _pic_image.layer.masksToBounds = YES;
        _pic_image.layer.cornerRadius = 35;
    }
    return _pic_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        _name_label.textAlignment = NSTextAlignmentCenter;

            }
    return _name_label;
}

-(UIButton *)left_btn
{
    if(!_left_btn)
    {
        _left_btn = [[UIButton alloc] init];
        [_left_btn setImage:[UIImage imageNamed:@"白色返回.png"] forState:UIControlStateNormal];
        [_left_btn addTarget:self action:@selector(leftclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _left_btn;
}

-(UIButton *)go_viewbtn
{
    if(!_go_viewbtn)
    {
        _go_viewbtn = [[UIButton alloc] init];
        _go_viewbtn.backgroundColor = [UIColor brownColor];
        [_go_viewbtn setTitle:@"视频学习" forState:UIControlStateNormal];
        _go_viewbtn.layer.masksToBounds = YES;
        _go_viewbtn.layer.cornerRadius = 10;
        [_go_viewbtn addTarget:self action:@selector(goVideoViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _go_viewbtn;
}

#pragma mark - UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfider = @"infocell1";

        _cell = [tableView dequeueReusableCellWithIdentifier:identfider];
        if (!_cell) {
            _cell = [[infoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
            _cell.label1.text = @"个人简介";
           
        }
        return _cell;
 
  
    return nil;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

        return @"";
   
}

#pragma mark - 实现方法

-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goVideoViewController
{
    
    
    faceVideoViewController *myFaceVideoController=[[faceVideoViewController alloc]initWithUserId:@"001" andTargedId:@"002"];
    
    
    
    
    myFaceVideoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:myFaceVideoController animated:YES completion:^{
        
    }];
}


-(void)getInfo:(NSString *)phone{

    self.pata=@{@"user_moblie":phone};
    self.userphone = [NSString stringWithString:phone];
    
    self.aaa = [self.pata objectForKey:@"user_moblie"];
    
    [HttpTool postWithparamsWithURL:@"Userspage/HomepageShow?" andParam:self.pata success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSString *code=dic[@"code"];
        NSLog(@"%@",dic);
        NSDictionary *dit = [dic objectForKey:@"data"];
        NSLog(@"dit = %@",dit);
        _model1 = [[infoModel alloc] init];
        _model1.pic_imageurlstr = [dit objectForKey:@"user_url"];
        _model1.name_str = [dit objectForKey:@"user_nickname"];
        _model1.address_str = [dit objectForKey:@"user_introduction"];
        NSURL *url = [NSURL URLWithString:self.model1.pic_imageurlstr];
        _pic_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
         _cell.label2.text = _model1.address_str;
        _name_label.text = self.model1.name_str;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
 
}
-(void)rightbtnClick
{
    
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    
    self.pata=@{@"user_moblie":name,@"user_contacts":self.userphone};
    
    [HttpTool postWithparamsWithURL:@"Contacts/contactsAdd?" andParam:self.pata success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSString *code = [dic objectForKey:@"code"];
        NSLog(@"code = %@",code);
        if ([code isEqualToString:@"200"]) {
           [MBProgressHUD showError:@"好友已存在"];
        }
        else
        {
        [MBProgressHUD showSuccess:@"添加成功"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"请检查网络设置"];
        
    }];
}
@end
