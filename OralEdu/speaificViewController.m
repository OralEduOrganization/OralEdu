//
//  speaificViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "speaificViewController.h"

@interface speaificViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *add_btn;
@property (nonatomic,strong) UITableView *image_tableview;
@end

@implementation speaificViewController{
    
     CGFloat nowImgViewFrameY;
      int imageName;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.right_btn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];

    
    
    
    
    [self.view addSubview:self.add_btn];
    [self.view addSubview:self.showImageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.add_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-100, 50, 50);
    self.showImageView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 400);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getters


-(UITableView *)image_tableview
{
    if(!_image_tableview)
    {
        _image_tableview = [[UITableView alloc] init];
        _image_tableview.dataSource = self;
        _image_tableview.delegate = self;
        
    }
    return _image_tableview;
}




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

-(UIImageView *)showImageView
{
    if(!_showImageView)
    {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = [UIColor greenColor];
    }
    return _showImageView;
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
    
  
    
    
    self.showImageView.image = image;
 //   [self saveImage:image withName:@"currentImage.png"];
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
