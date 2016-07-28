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
#import "PersonalsignatureViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "HttpTool.h"
#import "IndividualitysignatureViewController.h"
#import "MBProgressHUD.h"
#import "loginViewController.h"
#import "MBProgressHUD+XMG.h"
@interface myinfoViewController ()
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) NSMutableArray *infoarr;
@property (nonatomic,strong) NSMutableArray *picarr;
@property (nonatomic,strong) picModel *picM;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) infoTableViewCell1 *cell;
@property (nonatomic,strong) NSString *createPa;
@property (nonatomic,strong) UIImage *saveImage;
@property (nonatomic,strong) UIImageView *pic_image;
@property (nonatomic,strong) UILabel *name_label;
@property (nonatomic,strong) UIButton *left_btn;
@property (nonatomic,strong) UILabel *signature_label;
@property (nonatomic,strong) NSString *url;
@end

@implementation myinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadDataFromWeb];

    [self.navitionBar.left_btn removeFromSuperview];
//    [self.navitionBar.title_label removeFromSuperview];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.view addSubview:self.infotableview];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];
    
    self.infoarr = [NSMutableArray arrayWithObjects:@"用户名",@"个性签名",@"性别",@"地址",@"身份注册",@"个人简介",@"退出登录", nil];
    [self.view addSubview:self.pic_image];
    [self.view addSubview:self.name_label];
    [self.view addSubview:self.left_btn];
    [self.view addSubview:self.signature_label];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameasd:) name:@"username" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sigenasd:) name:@"usersigen" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personasd:) name:@"userperson" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addressasd:) name:@"useraddress" object:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.infotableview.frame = CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-130);
    self.left_btn.frame = CGRectMake(10, 33, 30, 30);
    self.pic_image.frame = CGRectMake(50, 30, 70, 70);
    self.name_label.frame = CGRectMake(160, 70, 100, 30);
    self.signature_label.frame = CGRectMake(160, 64, 180, 50);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    
    
    if (name==nil) {
        _picM = [[picModel alloc] init];
        _picM.image_urlstr = self.url;
        self.arr = [NSMutableArray array];
        _picM.name_str = @"无";
        _picM.signature_str = @"无";
        _picM.address_str = @"无";
        _picM.gender_str = @"无";
        _picM.user_introduction = @"无";
        _picM.identity =@"无";
        
        [self.arr addObject:_picM.name_str];
        [self.arr addObject:_picM.gender_str];
        [self.arr addObject:_picM.address_str];
        [self.arr addObject:_picM.signature_str];
        [self.arr addObject:_picM.user_introduction];
        [self.arr addObject:_picM.identity];
        [self.infotableview reloadData];
        
    }
    else
    {
    NSDictionary *para=@{@"user_moblie":name};
    [HttpTool postWithparamsWithURL:@"Userpage/UserpageShow?" andParam:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic = %@",dic);
        
        NSDictionary *dit = [dic objectForKey:@"data"];
       
        NSLog(@"dit = %@",dit);
        self.url = [dit objectForKey:@"url"];
        NSString *user_address = [dit objectForKey:@"user_address"];
        NSString *user_gender = [dit objectForKey:@"user_gender"];
        NSString *identity = [dit objectForKey:@"user_identity"];
        NSString *user_introduction = [dit objectForKey:@"user_introduction"];
        NSString *user_nickname = [dit objectForKey:@"user_nickname"];
        NSString *user_signed = [dit objectForKey:@"user_signed"];
        
        
        NSLog(@"username = %@",user_nickname);
        _picM = [[picModel alloc] init];
        _picM.image_urlstr = self.url;
        self.arr = [NSMutableArray array];
        _picM.name_str = user_nickname;
        _picM.signature_str = user_signed;
        _picM.address_str = user_address;
        _picM.gender_str = user_gender;
        _picM.user_introduction = user_introduction;
        _picM.identity =identity;
        
        NSLog(@"identy = %@",identity);
        
        [self.arr addObject:_picM.name_str];
        [self.arr addObject:_picM.gender_str];
        [self.arr addObject:_picM.address_str];
        [self.arr addObject:_picM.signature_str];
        [self.arr addObject:_picM.user_introduction];
        [self.arr addObject:_picM.identity];
        
        
         NSURL *url = [NSURL URLWithString:self.picM.image_urlstr];
        
        UIImage *img= [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
         self.pic_image.image =img;
         self.name_label.text = self.picM.name_str;
         self.signature_label.text = self.picM.signature_str;
         [self.infotableview reloadData];
        
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

#pragma mark - getters

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] init];
        _infotableview.dataSource = self;
        _infotableview.delegate = self;
        _infotableview.backgroundColor = [UIColor clearColor];
    }
    return _infotableview;
}

-(UIImageView *)pic_image
{
    if(!_pic_image)
    {
        _pic_image = [[UIImageView alloc] init];
       // _pic_image.backgroundColor = [UIColor greenColor];
        _pic_image.layer.masksToBounds = YES;
        _pic_image.layer.cornerRadius = 35;
        
        //点击图片事件
        UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagereplace)];
        TapGestureTecognizer.cancelsTouchesInView=NO;
        _pic_image.userInteractionEnabled = YES;
        [_pic_image addGestureRecognizer:TapGestureTecognizer];
    }
    return _pic_image;
}

-(UILabel *)name_label
{
    if(!_name_label)
    {
        _name_label = [[UILabel alloc] init];
        _name_label.textAlignment = NSTextAlignmentCenter;
        _name_label.textColor = [UIColor whiteColor];
        
    }
    return _name_label;
}

-(UILabel *)signature_label
{
    if(!_signature_label)
    {
        _signature_label = [[UILabel alloc] init];
        _signature_label.font = [UIFont systemFontOfSize:14];

        _signature_label.lineBreakMode = NSLineBreakByWordWrapping;
        _signature_label.numberOfLines = 0;
    }
    return _signature_label;
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

#pragma mark - UITableViewDataSource
//分组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.infoarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *cellidentfic2 = @"infoTableViewCell2";
        infoTableViewCell2 *cell  =  [tableView dequeueReusableCellWithIdentifier:cellidentfic2];
    
            cell = [[infoTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentfic2];
            cell.m_label1.text = self.infoarr[indexPath.row];
            if([cell.m_label1.text isEqualToString:@"退出登录"]){
                [cell getChange];
                cell.m_label3.text=@"退出登录";
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==1) {
                cell.m_label2.text = _picM.signature_str;
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
            if (indexPath.row == 4) {
                
                cell.m_label2.text = _picM.identity;
            }
            if(indexPath.row == 5)
            {
                cell.m_label2.text = _picM.user_introduction;
            }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row==0)
    {
        nameViewController *nameVC = [[nameViewController alloc] initWithTitle:@"用户名" isNeedBack:YES btn_image:nil];
        
        [nameVC setName:_picM.name_str];
        
        [self.navigationController pushViewController:nameVC animated:YES];

    }
    if(indexPath.row == 1)
    {
        NSLog(@"个性签名");
        IndividualitysignatureViewController *individVC = [[IndividualitysignatureViewController alloc] initWithTitle:@"个性签名" isNeedBack:YES btn_image:nil];
        
        [individVC setindividure:_picM.signature_str];
        
        [self.navigationController pushViewController:individVC animated:YES];
    }
    if(indexPath.row == 2)
    {
        [self Modifygender];
    }
    if(indexPath.row == 3)
    {
        addressViewController *addressVC = [[addressViewController alloc] initWithTitle:@"修改地址" isNeedBack:YES btn_image:nil];
        
        [self.navigationController pushViewController:addressVC animated:YES];

    }
    if(indexPath.row == 4)
    {
        [self shenfeng];
    }
    if(indexPath.row == 5)
    {
        PersonalsignatureViewController *PersonVC = [[PersonalsignatureViewController alloc] initWithTitle:@"个人简介" isNeedBack:YES btn_image:nil];
        [PersonVC setperson:_picM.user_introduction];
        [self.navigationController pushViewController:PersonVC animated:YES];
        
    }
    if (indexPath.row == 6)
    {
        [self Logout];
    }
}

#pragma mark - 实现方法

-(void)leftclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imagereplace
{
    [self changeIcon];
}

//修改性别

-(void)Modifygender
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"修改性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSString *newgender = @"男";
        
        NSDictionary *para=@{@"user_moblie":name,@"user_newgender":newgender};
        
        [HttpTool postWithparamsWithURL:@"Update/GenderUpdate?" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            _picM.gender_str = @"男";
            [self.infotableview reloadData];
            
            [MBProgressHUD showSuccess:@"修改成功"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"请检查网络"];
        }];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSString *newgender = @"女";
        
        NSDictionary *para=@{@"user_moblie":name,@"user_newgender":newgender};
        
        [HttpTool postWithparamsWithURL:@"Update/GenderUpdate?" andParam:para success:^(id responseObject) {
            
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            NSLog(@"%@",dic);
            
            [MBProgressHUD showSuccess:@"修改成功"];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"请检查网络"];
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    [control addAction:action3];

    [self presentViewController:control animated:YES completion:nil];
}

- (void)changeIcon
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"请选择做为头像的图片" preferredStyle:    UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击拍照");
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"请选择做为头像的图片" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 选择图片后,回调选择

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.pic_image.image = image;

    NSURL *URL = [NSURL URLWithString:@"http://127.0.0.1/OralEduServer/upload.php"];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager setSecurityPolicy:securityPolicy];
    [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //获取当前时间所闻文件名，防止图片重复
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";

        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        
        [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"image/png"];
        
        NSString *str = [NSString stringWithFormat:@"file:///Applications/XAMPP/xamppfiles/htdocs/OralEduServer/uploadImg/%@.jpg",name];
        
        NSDictionary *para=@{@"user_moblie":name,@"user_newurl":str};
        
        [HttpTool postWithparamsWithURL:@"Update/UrlUpdate" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@",dic);
            
            
      
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
              [[NSNotificationCenter defaultCenter]postNotificationName:@"userurl" object:self.picM.image_urlstr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark - 退出登录
-(void)Logout
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"您确定要退出登录吗" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //清除登录信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        
        [self loadDataFromWeb];
        [self.infotableview reloadData];
        
        loginViewController *loginVC = [[loginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }];
    
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];
}

-(void)login{
    [self loadDataFromWeb];
}

-(void)shenfeng
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"选择身份" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"老师" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSString *newgender = @"老师";
        
        NSDictionary *para=@{@"user_moblie":name,@"user_newidentity":newgender};
        
        [HttpTool postWithparamsWithURL:@"Update/IdentityUpdate?" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            _picM.identity = @"老师";
            [self.infotableview reloadData];
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"请检查网络"];
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSString *newgender = @"学生";
        
        NSDictionary *para=@{@"user_moblie":name,@"user_newidentity":newgender};
        
        [HttpTool postWithparamsWithURL:@"Update/IdentityUpdate?" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dic);
            _picM.identity = @"学生";
            [self.infotableview reloadData];
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"请检查网络"];
            
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [control addAction:action1];
    [control addAction:action2];
    [control addAction:action3];
    [self presentViewController:control animated:YES completion:nil];

}

-(void)nameasd:(NSNotification *)notifocation
{
    NSString *name = (NSString *)[notifocation object];
    _picM.name_str = name;
    [self.infotableview reloadData];
}

-(void)sigenasd:(NSNotification *)notifocation
{
    NSString *sigen = (NSString *)[notifocation object];
    _picM.signature_str = sigen;
    [self.infotableview reloadData];
}

-(void)personasd:(NSNotification *)notifocation
{
    NSString *person = (NSString *)[notifocation object];
    _picM.user_introduction = person;
    [self.infotableview reloadData];
}

-(void)addressasd:(NSNotification *)notifocation
{
    NSString *address = (NSString *)[notifocation object];
    _picM.address_str = address;
    [self.infotableview reloadData];
}


-(void)refresh{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaultes objectForKey:@"name"];
    NSDictionary *para=@{@"user_moblie":name};
    [HttpTool postWithparamsWithURL:@"Userpage/UserpageShow?" andParam:para success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic = %@",dic);
        
        NSDictionary *dit = [dic objectForKey:@"data"];
        
        NSLog(@"dit = %@",dit);
        self.url = [dit objectForKey:@"url"];
        NSString *user_address = [dit objectForKey:@"user_address"];
        NSString *user_gender = [dit objectForKey:@"user_gender"];
        NSString *identity = [dit objectForKey:@"user_identity"];
        NSString *user_introduction = [dit objectForKey:@"user_introduction"];
        NSString *user_nickname = [dit objectForKey:@"user_nickname"];
        NSString *user_signed = [dit objectForKey:@"user_signed"];
        
        
        NSLog(@"username = %@",user_nickname);
        _picM = [[picModel alloc] init];
        _picM.image_urlstr = self.url;
        self.arr = [NSMutableArray array];
        _picM.name_str = user_nickname;
        _picM.signature_str = user_signed;
        _picM.address_str = user_address;
        _picM.gender_str = user_gender;
        _picM.user_introduction = user_introduction;
        _picM.identity =identity;
        
        NSLog(@"identy = %@",identity);
        
        [self.arr addObject:_picM.name_str];
        [self.arr addObject:_picM.gender_str];
        [self.arr addObject:_picM.address_str];
        [self.arr addObject:_picM.signature_str];
        [self.arr addObject:_picM.user_introduction];
        [self.arr addObject:_picM.identity];
        
        
        NSURL *url = [NSURL URLWithString:self.picM.image_urlstr];
        
        UIImage *img= [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        self.pic_image.image =img;
        self.name_label.text = self.picM.name_str;
        self.signature_label.text = self.picM.signature_str;
        [self.infotableview reloadData];
        
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

    [self.infotableview reloadData];
}

@end
