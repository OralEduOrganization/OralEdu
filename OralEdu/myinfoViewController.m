//
//  myinfoViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/24.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "myinfoViewController.h"
#import "infoTableViewCell1.h"
#import "infoTableViewCell2.h"
#import "picModel.h"
#import "addressViewController.h"
#import "passwordViewController.h"
#import "nameViewController.h"
@interface myinfoViewController ()
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) NSMutableArray *infoarr;
@property (nonatomic,strong) NSMutableArray *picarr;
@property (nonatomic,strong) picModel *picM;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) infoTableViewCell1 *cell;
@end

@implementation myinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDataFromWeb];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.view addSubview:self.infotableview];
    self.infoarr = [NSMutableArray arrayWithObjects:@"用户名",@"修改密码",@"性别",@"修改地址",@"修改签名", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.infotableview.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    _picM = [[picModel alloc] init];
    _picM.image_urlstr = @"http://ww1.sinaimg.cn/crop.0.0.1080.1080.1024/006cxmWbjw8evactf4t2ij30u00u0jtj.jpg";
    self.arr = [NSMutableArray array];
    _picM.name_str = @"涛桑";
    _picM.address_str = @"天津";
    _picM.gender_str = @"男";
    _picM.signature_str = @"12828274628";
    [self.arr addObject:_picM.name_str];
    [self.arr addObject:_picM.gender_str];
    [self.arr addObject:_picM.address_str];
    [self.arr addObject:_picM.signature_str];

}

#pragma mark - getters

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] init];
        _infotableview.dataSource = self;
        _infotableview.delegate = self;
        _infotableview.backgroundColor = [UIColor orangeColor];
    }
    return _infotableview;
}

#pragma mark - UITableViewDataSource
//分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // 第0组有多少行
        return 1;
    }else
    {
        // 第1组有多少行
        return self.infoarr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0)
    {
    static NSString *cellidentfic = @"infoTableViewCell1";
    _cell  =  [tableView dequeueReusableCellWithIdentifier:cellidentfic];
        if(!_cell)
        {
            _cell = [[infoTableViewCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentfic];
            _cell.m_label.text = @"头像";
            NSURL *url = [NSURL URLWithString:_picM.image_urlstr];
            _cell.pic_imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            _cell.pic_imageview.layer.masksToBounds = YES;
            _cell.pic_imageview.layer.cornerRadius = 40;
            _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
    return _cell;
    }
    else
    {
        static NSString *cellidentfic2 = @"infoTableViewCell2";
        infoTableViewCell2 *cell  =  [tableView dequeueReusableCellWithIdentifier:cellidentfic2];
        if(!cell)
        {
            cell = [[infoTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentfic2];
            cell.m_label1.text = self.infoarr[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row==1) {
                [cell.m_label2 removeFromSuperview];
            }
            if(indexPath.row == 0)
            {
                cell.m_label2.text = _picM.name_str;
            }
            if(indexPath.row == 2)
            {
                cell.m_label2.text = _picM.gender_str;
            }
            if(indexPath.row ==3)
            {
                cell.m_label2.text = _picM.address_str;
            }
            if(indexPath.row == 4)
            {
                cell.m_label2.text = _picM.signature_str;
            }
        }
        return cell;
    }
    return nil;
}

/**
 *  第section组头部显示什么标题
 *
 */
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
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section==0)
    {
        [self changeimage];
    }
    else
    {
    if(indexPath.row == 0)
    {
        nameViewController *nameVC = [[nameViewController alloc] initWithTitle:@"用户名" isNeedBack:YES btn_image:nil];
        [self presentViewController:nameVC animated:YES completion:^{
            
        }];
    }
    if(indexPath.row == 1)
    {
        NSLog(@"1");
        passwordViewController *passVC = [[passwordViewController alloc] initWithTitle:@"修改密码" isNeedBack:YES btn_image:nil];
        [self presentViewController:passVC animated:YES completion:^{
            
        }];
    }
    if(indexPath.row == 2)
    {
        [self Modifygender];
    }
    if(indexPath.row == 3)
    {
        NSLog(@"3");
        addressViewController *addressVC = [[addressViewController alloc] initWithTitle:@"修改地址" isNeedBack:YES btn_image:nil];
        [self presentViewController:addressVC animated:YES completion:^{
            

        }];
    }
    if(indexPath.row == 4)
    {
        
        NSLog(@"4");
    }
    }
}
#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择头像
-(void)changeimage
{
    UIAlertController *controll = [UIAlertController alertControllerWithTitle:@"头像" message:@"选择图片" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"back" style:    UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controll addAction:action2];
    [controll addAction:action1];
    [self presentViewController:controll animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.cell.pic_imageview.image = image;
}
//修改性别
-(void)Modifygender
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    [control addAction:action3];

    [self presentViewController:control animated:YES completion:nil];
}
@end
