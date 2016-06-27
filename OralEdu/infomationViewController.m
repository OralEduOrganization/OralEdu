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
#import "infoModel.h"
@interface infomationViewController ()
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) infoModel *model1;
@end

@implementation infomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.right_btn removeFromSuperview];
    [self loadDataFromWeb];
    [self.view addSubview:self.infotableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.infotableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 280);
}
#pragma  mark - 数据源方法
-(void)loadDataFromWeb
{
    _model1 = [[infoModel alloc] init];
    _model1.pic_imageurlstr = @"http://ww1.sinaimg.cn/crop.3.45.1919.1919.1024/6b805731jw1em0hze051hj21hk1isn5k.jpg";
    _model1.name_str = @"李老师";
    _model1.address_str = @"中国天津";
    _model1.identfid_str = @"老师";
}
-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] init];
        _infotableview.delegate = self;
        _infotableview.dataSource = self;
        _infotableview.backgroundColor = [UIColor orangeColor];
        _infotableview.scrollEnabled =NO;
    }
    return _infotableview;
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
    if (indexPath.section == 0) {
        infoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
        if(!cell)
        {
            cell = [[infoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
            cell.pic_image.layer.masksToBounds = YES;
            cell.pic_image.layer.cornerRadius = 40;
            cell.name_label.text = _model1.name_str;
            cell.identity_label.text = _model1.identfid_str;
            NSURL *url = [NSURL URLWithString:_model1.pic_imageurlstr];
            cell.pic_image.image =[ UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        }
        return cell;
    }
    else
    {
        static NSString *identfider2 = @"infocell2";
        infoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identfider2];
        if(!cell)
        {
            cell = [[infoCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider2];
            cell.label1.text = @"地区";
            cell.label2.text = _model1.address_str;
        }
        return cell;
    }
    return nil;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // return @"标题";
    if (section == 0) {
        return @"   ";
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


@end
