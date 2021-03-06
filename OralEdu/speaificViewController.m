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
#import "UIAlertController+SZYKit.h"
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)
#define fNavBarHeigth (IOS7==YES ? 64 : 44)
#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height)
@interface speaificViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,imageCollectionCellDelegate>
{
    
    CGFloat nowImgViewFrameY;
    int imageName;
    BOOL isEdit;
    
}

@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *add_btn;
@property (nonatomic,strong) UITableView *image_tableview;
@property (nonatomic,strong) NSMutableArray *name_arr;
@property (nonatomic,strong) NSMutableArray *image_arr;
@property (nonatomic,strong) NSMutableArray *url_arr;
@property (nonatomic,strong) NSMutableArray *time_arr;
@property (nonatomic,strong) materal_model *m_model;
@property (nonatomic,strong) NSMutableArray *need_arr;
@property (nonatomic,strong) UICollectionView *image_collectionview;
@property (nonatomic,strong) imageCollectionViewCell *cell;
@end
static NSString *collectionview = @"imagecell";

@implementation speaificViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isEdit=NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groud3"]];
     self.need_arr=[[NSMutableArray alloc]init];
     self.m_model = [[materal_model alloc] init];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回.png"] forState:UIControlStateNormal];
    [self.navitionBar.right_btn setTitle:@"编辑" forState:UIControlStateNormal];
    [self addTheCollectionView];
    [self.view addSubview:self.add_btn];
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteClick:) name:@"clickToDelete" object:nil];
    
    
    
}
-(void)reloadData{
    self.image_arr = [NSMutableArray array];
    self.name_arr = [NSMutableArray array];
    self.url_arr = [NSMutableArray array];
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaultes objectForKey:@"name"];
    self.need_arr = [Datebase_materallist readmateraldetailsWithuser_id:user_id Name:self.navitionBar.title_label.text];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for(int i=0;i<self.need_arr.count;i++){
        materal_model *need_model=self.need_arr[i];
        NSString *needPatch=[NSString stringWithFormat:@"%@%@",docDir,need_model.materal_imagepath];
        NSArray *needNameArr=[need_model.materal_imagepath componentsSeparatedByString:@"/"];
        NSString *name=needNameArr[3];
        UIImage *image= [[UIImage alloc]initWithContentsOfFile:needPatch];
        if (image!=nil) {
            [self.image_arr addObject:image];
            [self.name_arr addObject:name];
            [self.url_arr addObject:need_model.materal_imagepath];
            
        }else
        {
            NSLog(@"没有图片");
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.add_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-100, 40, 40);
    
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
        [_add_btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        _add_btn.backgroundColor=[UIColor clearColor];
        [_add_btn addTarget:self action:@selector(addimage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add_btn;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.image_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionview forIndexPath:indexPath];
    _cell.delegate = self;
    [_cell releaseView];
    if(isEdit==YES){
        [_cell changeView];
    }else{
        
        [_cell releaseView];
    }
    _cell.nameStr=self.name_arr[indexPath.item];
    _cell.nameUrl=self.url_arr[indexPath.item];

    _cell.imageview.image = self.image_arr[indexPath.item];
    return _cell;
}

//创建uicollectionview

-(void)addTheCollectionView{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.image_collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, fDeviceWidth, fDeviceHeight) collectionViewLayout:flowLayout];
    //设置代理
    self.image_collectionview.delegate = self;
    self.image_collectionview.dataSource = self;
    self.image_collectionview.backgroundColor = [UIColor clearColor];
    //注册cell和ReusableView（相当于头部）
    _image_collectionview.allowsMultipleSelection = YES;//默认为NO,是否可以多选

#pragma mark -- 注册单元格
    [_image_collectionview registerClass:[imageCollectionViewCell class] forCellWithReuseIdentifier:collectionview];
    [self.view addSubview:self.image_collectionview];
 
}

-(void)addimage
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:    UIAlertControllerStyleActionSheet];
        
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
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
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
    //[self.image_tableview reloadData];
    
    
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaultes objectForKey:@"name"];
    
    //int x =  arc4random() % 100;
    NSString *needTime;
    needTime=[self getCurrentTime];
    [self saveImage:image withName:[NSString stringWithFormat:@"%@_%@.png",user_id,needTime]];
    
    self.m_model.materal_id = user_id;
    
    self.m_model.materal_name = self.navitionBar.title_label.text;
    self.m_model.materal_time = needTime;
    [Datebase_materallist savemateraldetails:self.m_model];
    [self reloadData];
    [self.image_collectionview reloadData];
    
    
}
//获取时间
-(NSString *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//保存图片
-(void)saveImage:(UIImage *)currentImage withName:(NSString *)needImageName{
    
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);
    NSString *path = self.navitionBar.title_label.text;
    
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaultes objectForKey:@"name"];
    
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",user_id,path]]stringByAppendingPathComponent:needImageName];

    NSString *savePath=[NSString stringWithFormat:@"/%@/%@/%@",user_id,path,needImageName];
    [imageData writeToFile:fullPath atomically:NO];
    
    self.m_model.materal_imagepath = savePath;
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

-(void)rightbtnClick{
    isEdit=!isEdit;
    [self.image_collectionview reloadData];
    if (isEdit==NO) {
        [self.navitionBar.right_btn setTitle:@"编辑" forState:UIControlStateNormal];
    }else
    {
        [self.navitionBar.right_btn setTitle:@"取消" forState:UIControlStateNormal];
    }
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((fDeviceWidth-20)/3, (fDeviceWidth-20)/3);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //        cell.backgroundColor = [UIColor redColor];
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)moveImageBtnClick:(imageCollectionViewCell *)aCell{
    NSLog(@"delClick");
    NSLog(@"%@",aCell.nameStr);
    NSLog(@"%@",aCell.nameUrl);
    
    NSIndexPath * indexPath = [self.image_collectionview indexPathForCell:aCell];
    [_image_arr removeObjectAtIndex:indexPath.row];
    isEdit=!isEdit;
    [Datebase_materallist deletemateraldetails:aCell.nameUrl];
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
   
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaultes objectForKey:@"name"];
    
    
    NSString *pa = [NSString stringWithFormat:@"%@/%@/%@/%@",paths,user_id,self.navitionBar.title_label.text,aCell.nameStr];

    [self deleteFileWithObjetName:aCell.nameStr andNeedPatch:pa];
    
    [self.navitionBar.right_btn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.image_collectionview reloadData];

    

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
//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    _cell = [collectionView cellForItemAtIndexPath:indexPath];
    _cell.backgroundColor=[UIColor clearColor];
}


-(void)deleteClick:(NSNotification *)notification{
    
    
    [UIAlertController showAlertAtViewController:self withMessage:@"您确定要删除此图片吗" cancelTitle:@"取消" confirmTitle:@"删除" cancelHandler:^(UIAlertAction *action) {
    } confirmHandler:^(UIAlertAction *action) {
        
        
   
        
        
        
        imageCollectionViewCell *aCell=(imageCollectionViewCell *)[notification object];
        
        NSIndexPath * indexPath = [self.image_collectionview indexPathForCell:aCell];
        [_image_arr removeObjectAtIndex:indexPath.row];
        //    isEdit=!isEdit;
        [Datebase_materallist deletemateraldetails:aCell.nameUrl];
        
        NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        NSString *user_id = [defaultes objectForKey:@"name"];
        
        
        NSString *pa = [NSString stringWithFormat:@"%@/%@/%@/%@",paths,user_id,self.navitionBar.title_label.text,aCell.nameStr];
        
        [self deleteFileWithObjetName:aCell.nameStr andNeedPatch:pa];
        
        //    [self.navitionBar.right_btn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self.image_collectionview reloadData];
        
        
        
    }];
    
    

//    UIColor *receiveColor=(UIColor *)[notification object];
//    self.selectedColor=receiveColor;
//    drawView.selectedColor=self.selectedColor;
//    [self.hubView removeFromSuperview];
//    self.hubView = nil;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.rightView.transform =CGAffineTransformIdentity;
//    }completion:^(BOOL finished) {
//        
//    }];
//    
//}
}

@end
