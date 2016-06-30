//
//  speaificViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "speaificViewController.h"
#import "imageTableViewCell.h"
#import "Datebase_materallist.h"
#import "materal_model.h"
#import "imageCollectionViewCell.h"
@interface speaificViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *add_btn;
@property (nonatomic,strong) UITableView *image_tableview;
@property (nonatomic,strong) NSMutableArray *name_arr;
@property (nonatomic,strong) NSMutableArray *image_arr;
@property (nonatomic,strong) NSMutableArray *time_arr;
@property (nonatomic,strong) imageTableViewCell *cell;
@property (nonatomic,strong) materal_model *m_model;
@property (nonatomic,strong) NSMutableArray *need_arr;
@property (nonatomic,strong) UICollectionView *image_collectionview;
@end
static NSString *collectionview = @"imagecell";
@implementation speaificViewController{
    
     CGFloat nowImgViewFrameY;
      int imageName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.need_arr=[[NSMutableArray alloc]init];
     self.m_model = [[materal_model alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.right_btn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];

    
    self.image_arr = [NSMutableArray array];
    [self addTheCollectionView];
    
    [self.view addSubview:self.add_btn];
    self.need_arr = [Datebase_materallist readmateraldetailsWithuser_id:@"12136" Name:@"22222"];
    
    for(int i=0;i<self.need_arr.count;i++){
        materal_model *need_model=self.need_arr[i];
        UIImage *image= [[UIImage alloc]initWithContentsOfFile:need_model.materal_imagepath];
        [self.image_arr addObject:image];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.add_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-100, 50, 50);
    
    self.image_tableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getters


-(UIButton *)add_btn
{
    if(!_add_btn)
    {
        _add_btn = [[UIButton alloc] init];
        _add_btn.backgroundColor = [UIColor grayColor];
        [_add_btn setTitle:@"add" forState:UIControlStateNormal];
        [_add_btn addTarget:self action:@selector(addimage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add_btn;
}

//-(UITableView *)image_tableview
//{
//    if(!_image_tableview)
//    {
//        _image_tableview = [[UITableView alloc] init];
//        _image_tableview.backgroundColor = [UIColor grayColor];
//        _image_tableview.dataSource = self;
//        _image_tableview.delegate = self;
//    }
//    return _image_tableview;
//}



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.image_arr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *idconfiger = @"imageviewcell";
//    self.cell = [tableView dequeueReusableCellWithIdentifier:idconfiger];
//    if (!_cell) {
//        _cell = [[imageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idconfiger];
//        _cell.name_label.text = self.name_arr[indexPath.row];
//        _cell.specific_imageview.image = self.image_arr[indexPath.row];
//    }
//    return self.cell;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.image_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionview forIndexPath:indexPath];
    cell.imageview.image = self.image_arr[indexPath.item];
    return cell;
}


////cell的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80.0f;
//}


-(void)addTheCollectionView{
    
    //=======================1===========================
    //创建一个块状表格布局对象
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    //格子的大小 (长，高)
    flowL.itemSize = CGSizeMake(90, 90);
    //横向最小距离
    //flowL.minimumInteritemSpacing = 1.f;
    //    flowL.minimumLineSpacing=60.f;//代表的是纵向的空间间隔
    //设置，上／左／下／右 边距 空间间隔数是多少
    //flowL.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //如果有多个 区 就可以拉动
    [flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    //可以左右拉动
    // [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _image_collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:flowL];
    //设置代理为当前控制器
    _image_collectionview.delegate = self;
    _image_collectionview.dataSource = self;
    //设置背景
    _image_collectionview.backgroundColor =[UIColor grayColor];
    
#pragma mark -- 注册单元格
    [_image_collectionview registerClass:[imageCollectionViewCell class] forCellWithReuseIdentifier:collectionview];
    //添加视图
    [self.view addSubview:_image_collectionview];
    
}



-(void)addimage
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
    
  
    [self.image_arr addObject:image];
    [self.image_tableview reloadData];
    NSString *user_id = @"12136";
    //int x =  arc4random() % 100;
    NSString *needTime;
    needTime=[self getCurrentTime];
    [self saveImage:image withName:[NSString stringWithFormat:@"%@_%@.png",user_id,needTime]];
    
   
    
    self.m_model.materal_id = user_id;
    self.m_model.materal_name = @"22222";
    self.m_model.materal_time = needTime;
    
    
    [Datebase_materallist savemateraldetails:self.m_model];
    [self.image_collectionview reloadData];
    
}
//获取时间
-(NSString *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//保存图片
-(void)saveImage:(UIImage *)currentImage withName:(NSString *)needImageName{
    
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);
    NSString *path = self.navitionBar.title_label.text;
    NSString *user_id = @"12136";
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",user_id,path]]stringByAppendingPathComponent:needImageName];
    [imageData writeToFile:fullPath atomically:NO];
    
    self.m_model.materal_imagepath = fullPath;
}

//获取图片路径
-(NSString *)getImagepath
{
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
   
    
    return nil;
}
#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
