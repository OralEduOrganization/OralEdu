//
//  infomationViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "infomationViewController.h"
#import "infoCell1.h"
#import "infoCell2.h"
#import "infoCell3.h"
#import "infoModel.h"
#import "ZCYlocation.h"
#import "faceVideoViewController.h"
#import "passwordViewController.h"
@interface infomationViewController ()
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) infoModel *model1;
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) UILabel *name_label;
@property (nonatomic,strong) UIButton *left_btn;
@property (nonatomic,strong) UIButton *go_viewbtn;
@end

@implementation infomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.navitionBar.left_btn removeFromSuperview];
    
//     self.navitionBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
   // self.navitionBar.title_label.text = @"李老师";
    [self loadDataFromWeb];
    [self.view addSubview:self.infotableview];
    [self.view addSubview:self.pic_image];
    [self.view addSubview:self.name_label];
    [self.view addSubview:self.left_btn];
    [self.view addSubview:self.go_viewbtn];

    [self.navitionBar.left_btn setTitle:@"个人信息" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.infotableview.frame = CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width, 150);
    self.left_btn.frame = CGRectMake(10, 50, 30, 30);
    self.pic_image.frame = CGRectMake(50, 30, 70, 70);
    self.name_label.frame = CGRectMake(160, 70, 100, 30);
    self.go_viewbtn.frame = CGRectMake(15, 380, [UIScreen mainScreen].bounds.size.width-30, 50);
}
#pragma  mark - 数据源方法
-(void)loadDataFromWeb
{
    _model1 = [[infoModel alloc] init];
    _model1.pic_imageurlstr = @"http://ww1.sinaimg.cn/crop.3.45.1919.1919.1024/6b805731jw1em0hze051hj21hk1isn5k.jpg";
    _model1.name_str = @"李老师";
    _model1.address_str = @"新东方在职讲师，以带过超过100个申请出国的高中生，大学生。为大家圆一个出国梦";
    _model1.identfid_str = @"老师";
}

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] init];
        _infotableview.delegate = self;
        _infotableview.dataSource = self;
        //_infotableview.backgroundColor = [UIColor orangeColor];
        _infotableview.scrollEnabled =NO;
    }
    return _infotableview;
}


-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
        _pic_image.backgroundColor = [UIColor greenColor];
        _pic_image.layer.masksToBounds = YES;
        _pic_image.layer.cornerRadius = 35;
       NSURL *url = [NSURL URLWithString:self.model1.pic_imageurlstr];
       _pic_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    }
    return _pic_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        //_name_label.backgroundColor = [UIColor greenColor];
        _name_label.textAlignment = NSTextAlignmentCenter;
        _name_label.text = self.model1.name_str;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
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
    static NSString *identfider = @"infocell1";
    static NSString *identfider3 = @"infocell3";
//    if (indexPath.section == 0) {
//        infoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
//        if(!cell)
//        {
//            cell = [[infoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
//            cell.pic_image.layer.masksToBounds = YES;
//            cell.pic_image.layer.cornerRadius = 40;
//            cell.name_label.text = _model1.name_str;
//            cell.identity_label.text = _model1.identfid_str;
//            NSURL *url = [NSURL URLWithString:_model1.pic_imageurlstr];
//            cell.pic_image.image =[ UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//        }
//        return cell;
//    }
//    else
//    {
//        static NSString *identfider2 = @"infocell2";
//        infoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identfider2];
//        if(!cell)
//        {
//            cell = [[infoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider2];
//            cell.label1.text = @"地区";
//            cell.label2.text = _model1.address_str;
//        }
//        return cell;
//    }
    
    if (indexPath.section == 0) {
        infoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
        if (!cell) {
            cell = [[infoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
            cell.label1.text = @"个人简介";
            cell.label2.text = _model1.address_str;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        infoCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identfider3];
        if (!cell) {
            cell = [[infoCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider3];
            cell.label1.text = @"累计授课";
            cell.label2.text = @"200次";
        }
        return cell;
    }
    return nil;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else
    {
    return 45.0f;
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
    faceVideoViewController *myFaceVideoController=[[faceVideoViewController alloc]init];
    myFaceVideoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:myFaceVideoController animated:YES completion:^{
        
    }];
}
@end
