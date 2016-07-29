//
//  materViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "materViewController.h"
#import "AppDelegate.h"
#import "materalCell.h"
#import "speaificViewController.h"
#import "DWBubbleMenuButton.h"
#import "NSString+SZYKit.h"
#import "materal_finder.h"
#import "Datebase_materallist.h"
#import "HttpTool.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "materal_model.h"
#import "MBProgressHUD+XMG.h"
#import "UIAlertController+SZYKit.h"
#import "DWBubbleMenuButton.h"
@interface materViewController ()
@property (nonatomic,strong) UITableView *matertableview;
@property (nonatomic,strong) NSMutableArray *mater_arr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UILabel *homelabel;
@property (nonatomic,strong) UIButton *add_btn;
@property (nonatomic,strong) NSString *add_str;

@property (nonatomic,strong) materal_finder *m_finder;
@property (nonatomic,strong) UITableViewCell *cell;
@property (nonatomic,strong) NSMutableArray *delete_arr;

@property (nonatomic,strong) UIButton *uploadBtn;

@end

@implementation materViewController{
     MBProgressHUD *HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"bai"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.matertableview];
    [self.navitionBar.right_btn removeFromSuperview];
    self.delete_arr = [[NSMutableArray alloc]init];
    self.navitionBar.title_label.text = @"素材库";
    self.mater_arr = [NSMutableArray array];

    _m_finder = [[materal_finder alloc] init];
    
    NSMutableArray *listArr = [NSMutableArray array];
    listArr  =  [Datebase_materallist readmaderallist];
    
    for (int i=0; i<listArr.count; i++) {
        materal_finder *arr=listArr[i];
        [_mater_arr addObject:arr.materal_finder_name];
    }
    
    UILabel *homeLabel = [self createHomeButtonView];
    // Create up menu button
    homeLabel = [self createHomeButtonView];
    
    DWBubbleMenuButton *upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - homeLabel.frame.size.width - 20.f,
                                                                                          self.view.frame.size.height - homeLabel.frame.size.height - 20.f,
                                                                                          homeLabel.frame.size.width,
                                                                                          homeLabel.frame.size.height)
                                                            expansionDirection:DirectionUp];
    upMenuView.homeButtonView = homeLabel;
    
    [upMenuView addButtons:[self createDemoButtonArray]];
    
    [self.view addSubview:upMenuView];

    
   }

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.matertableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
   
}

#pragma mark - getters


-(UITableView *)matertableview
{
    if(!_matertableview)
    {
        _matertableview = [[UITableView alloc] init];
        _matertableview.delegate = self;
        _matertableview.dataSource = self;
        
        _matertableview.tableFooterView = [[UIView alloc]init];
        
        _matertableview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groud3.jpg"]];
        _matertableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _matertableview;
}

#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mater_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfider = @"materalCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identfider];
    
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfider];
    _cell.backgroundColor=[UIColor clearColor];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *needview=[[UIView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width)*0.075, 5,
                                                             ([UIScreen mainScreen].bounds.size.width)*0.85, _cell.bounds.size.height-3)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, -8, 100, 50)];
    label.text=self.mater_arr[indexPath.row];
    needview.backgroundColor=[UIColor lightGrayColor];
    needview.layer.cornerRadius = 5;
    needview.layer.masksToBounds = YES;
    
    [needview addSubview:label];
    [_cell addSubview:needview];
    [self.delete_arr addObject:label.text];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
    
    speaificViewController *specVC = [[speaificViewController alloc] initWithTitle:self.mater_arr[indexPath.row] isNeedBack:YES btn_image:nil];
    [self.navigationController pushViewController:specVC animated:YES];
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
        self.cell=[self.matertableview cellForRowAtIndexPath:indexPath];

        [Datebase_materallist deletematerallist:self.mater_arr[indexPath.row]];
        
        NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *user_id = [defaultes objectForKey:@"name"];
        
        NSString *pa = [NSString stringWithFormat:@"%@/%@/%@",paths,user_id,self.mater_arr[indexPath.row]];
        
        [self deleteFileWithObjetName:self.mater_arr[indexPath.row] andNeedPatch:pa];
        
        
        NSString *str = self.mater_arr[indexPath.row];
        
        NSDictionary *pare=@{@"user_moblie":user_id,@"file_name":str};
        
        [HttpTool postWithparamsWithURL:@"Pic/FileDelete" andParam:pare success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        
        } failure:^(NSError *error) {
            NSLog(@"ERROR");
        }];
        
        [self.matertableview reloadData];
        // 2. 更新UI
        [_mater_arr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
       
    }];
     deleteRowAction.backgroundColor = [UIColor clearColor];

    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        NSLog(@"点击了重命名");
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"重命名" message:@"重新命名课程名字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
       // UITextField *renameTextField = [[UITextField alloc]init];
        
        [control addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
              [_mater_arr replaceObjectAtIndex:indexPath.row withObject:self.str];//指定索引修改
            [self.matertableview reloadData];
            
        }];
        
        [control addAction:action1];
        [control addAction:action2];
        
        [self presentViewController:control animated:YES completion:nil];
        
       
        
    }];
    moreRowAction.backgroundColor = [UIColor clearColor];
    
    //moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 将设置好的按钮放到数组中返回
    
    return @[deleteRowAction, moreRowAction];
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

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    self.str=textField.text;
}

//添加文件夹分类
-(void)addanew
{
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加" message:@"请输入分类名" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextDidChangeNotification object:nil];
        [self.mater_arr addObject:self.add_str];
        [self.matertableview reloadData];
        //新建文件夹
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *user_id = [defaultes objectForKey:@"name"];
        
        NSString *createPath = [NSString stringWithFormat:@"%@/%@/%@", pathDocuments,user_id,self.add_str];
        NSLog(@"str = %@",self.add_str);
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            
        } else {
            NSLog(@"FileDir is exists.");
            
        }

        _m_finder.materal_finder_id = user_id;
        _m_finder.materal_finder_name = self.add_str;

        [Datebase_materallist savematerallist:_m_finder];

    }]; 

    [control addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification2:) name:UITextFieldTextDidChangeNotification object:textField];
        
     
    }];

    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:nil];
    
    
    
}

- (void)handleTextFieldTextDidChangeNotification2:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSLog(@"%@",textField.text);
    self.add_str=textField.text;
}

//销毁观察者模式
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)deleteFileWithObjetName:(NSString *)name andNeedPatch:(NSString *) patch{
    NSFileManager* fileManager=[NSFileManager defaultManager];

    //文件名
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:patch];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:patch error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

#pragma mark -----上传

-(void)uploadBtnClick
{
    [UIAlertController showAlertAtViewController:self withMessage:@"确定上传本地素材库吗？（建议wifi情况下上传）" cancelTitle:@"取消" confirmTitle:@"上传" cancelHandler:^(UIAlertAction *action) {
    } confirmHandler:^(UIAlertAction *action) {
        
        //初始化hud 置于当前view中
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //设置对话框文字
        HUD.labelText = @"数据上传中";
        //显示对话框
        [HUD show:YES];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaultes objectForKey:@"name"];
        NSLog(@"%@",docDir);
        NSLog(@"%@",name);
        
        NSDictionary *para=@{@"user_moblie":name};
        [HttpTool postWithparamsWithURL:@"Pic/PicAllDelete?" andParam:para success:^(id responseObject) {
            
            NSLog(@"清空");
        } failure:^(NSError *error) {
            NSLog(@"清空失败");
        }];
        
        NSString *path=[NSString stringWithFormat:@"%@/%@",docDir,name];
        NSString *basePath=[NSString stringWithFormat:@"%@/%@",docDir,name];
        //    NSArray *fileNameList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSFileManager *myFileManager=[NSFileManager defaultManager];
        
        NSDirectoryEnumerator *myDirectoryEnumerator;
        
        myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
        
        //列举目录内容，可以遍历子目录
        
        NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
        
        while((path=[myDirectoryEnumerator nextObject])!=nil)
            
        {
            NSArray *result_arr=[path componentsSeparatedByString:@"."];
            NSInteger length=result_arr.count;
            NSString *str=result_arr[length-1];
            if( [str isEqualToString:@"png"]){
                
                NSLog(@"%@",path);
                
                NSString *urlStr=[NSString stringWithFormat:@"%@/%@",basePath,path];
                
                NSLog(@"%@",urlStr);
                
                UIImage *image= [[UIImage alloc]initWithContentsOfFile:urlStr];
                
                NSArray *name_arr=[path componentsSeparatedByString:@"/"];
                
                NSString *pic_name=name_arr[1];
                
                NSString *document_name=name_arr[0];
                
                NSLog(@"%@",pic_name);
                
                
                [self uploadImage:image andDocumentname:document_name withName:pic_name];
                
                NSString *url4Str=[NSString stringWithFormat:@"file:///Applications/XAMPP/xamppfiles/htdocs/OralEduServer/uploadImg/%@",pic_name];
                
                
                [self addfile:name andDocument:document_name andURL:url4Str];
                
                
            }

        }
    }];
}

-(void)addfile:(NSString *)user_phone andDocument:(NSString *)doc andURL:(NSString *)url{


    NSDictionary *para=@{@"user_moblie":user_phone,@"file_name":doc,@"picture_url":url};
    [HttpTool postWithparamsWithURL:@"Pic/PicAdd?" andParam:para success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [HUD removeFromSuperview];
        [MBProgressHUD showSuccess:@"数据上传成功"];
        NSLog(@"dic = %@",dic);
    } failure:^(NSError *error) {
        NSLog(@"失败");
        [MBProgressHUD showError:@"数据未变或已上传成功"];
        
    }];

}

-(void)uploadImage:(UIImage *)img andDocumentname:(NSString *)docName withName:(NSString *)name{
    
    UIImage *image = img;
    
    NSURL *URL = [NSURL URLWithString:@"http://127.0.0.1/OralEduServer/cload_upload.php"];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager setSecurityPolicy:securityPolicy];
    [manager POST:URL.absoluteString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //获取当前时间所闻文件名，防止图片重复
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        
        
        [formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@"image/png"];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    
}

-(NSString *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)downbtnclick
{
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaultes objectForKey:@"name"];
    NSDictionary *para=@{@"user_moblie":user_id};
    
    [HttpTool postWithparamsWithURL:@"Pic/PicSearch" andParam:para success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic = %@",dic);
        
        NSString *resultData=[dic objectForKey:@"code"];
        
        if(![resultData isEqualToString:@"500"]){
        
            NSMutableArray *dit = [dic objectForKey:@"data"];
            
            
            NSLog(@"dit  = %@",dit);
            
            self.mater_arr = [NSMutableArray array];
            self.mater_arr = dit;
            [self.matertableview reloadData];
            
            _m_finder.materal_finder_id = user_id;
            
            for (int i =0; i<self.mater_arr.count; i++) {
                
                _m_finder.materal_finder_name = self.mater_arr[i];
                [Datebase_materallist savematerallist:_m_finder];
                
                //新建文件夹
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *createPath = [NSString stringWithFormat:@"%@/%@/%@", pathDocuments,user_id,self.mater_arr[i]];
                // 判断文件夹是否存在，如果不存在，则创建
                if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
                    [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
                    
                } else {
                    NSLog(@"FileDir is exists.");
                    
                }
                
                NSDictionary *pare=@{@"user_moblie":user_id,@"file_name":self.mater_arr[i]};
                
                [HttpTool postWithparamsWithURL:@"Pic/FileSearch" andParam:pare success:^(id responseObject) {
                    
                    NSData *data = [[NSData alloc] initWithData:responseObject];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"dic2 = %@",dic);
                    
                    NSMutableArray *dit = [dic objectForKey:@"data"];
                    NSLog(@"dit2  = %@",dit);
                    for (int j=0; j<dit.count; j++) {
                        
                        NSString *fileurlStr=dit[j];
                        NSArray *qwe=[fileurlStr componentsSeparatedByString:@"/"];
                        
                        NSString *realName=qwe[qwe.count-1];
                        
                        NSURL *url = [NSURL URLWithString:dit[j]];
                        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                        
                        
                        NSData *imageData=UIImageJPEGRepresentation(img, 0.1);
                        
                        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
                        NSString *user_id = [defaultes objectForKey:@"name"];
                        
                        NSString *zxc=self.mater_arr[i];
                        
                        
                        NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",user_id,zxc]]stringByAppendingPathComponent:realName];
                        
                        NSString *savePath=[NSString stringWithFormat:@"/%@/%@/%@",user_id,zxc,realName];
                        
                        [imageData writeToFile:fullPath atomically:NO];
                        
                        materal_model *model = [[materal_model alloc]init];
                        
                        model.materal_id = user_id;
                        model.materal_name = zxc;
                        model.materal_imagepath=savePath;
                        model.materal_time=@"";
                        
                        [Datebase_materallist savemateraldetails:model];
                        
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
                
            }
        
            [MBProgressHUD showSuccess:@"数据同步成功！"];
        
        }else{
        
            [MBProgressHUD showError:@"您还没有云端数据"];
        
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 60.f)];
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"add", @"up", @"down"]) {
//        for (NSString *title in @[[UIImage imageNamed:@"add"], [UIImage imageNamed:@"Unknown"], [UIImage imageNamed:@"Unknown2"]]) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 50.f, 50.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsMutable addObject:button];
    }
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender {
    if (sender.tag==0) {
        [self addanew];
    }
    if (sender.tag==1) {
        
        [self uploadBtnClick];
    }
    if (sender.tag==2) {
        [self downbtnclick];
    }
}

- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

@end
