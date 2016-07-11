//
//  faceVideoViewController.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/1.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "faceVideoViewController.h"
#import "PIDrawerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "videoRightView.h"
#import "Datebase_materallist.h"
#import "pickImageView.h"
#import "materal_finder.h"
#import "imageMenuView.h"

@interface faceVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSInteger screenWidth;
    NSInteger screenHeight;
    PIDrawerView *drawView;
    
}

    @property (nonatomic,strong) UIButton           *backBtn;
    @property (nonatomic,strong) UIView             *teacherView;
    @property (nonatomic,strong) UIView             *studentView;
    @property (nonatomic,strong) UIButton           *writeButton;
    @property (nonatomic,strong) UIButton           *pickColorButton;
    @property (nonatomic,strong) UIButton           *pickEraserButton;
    @property (nonatomic,strong) UIButton           *clearBtn;
    @property (nonatomic,strong) UIButton           *eraseBtn;
    @property (nonatomic,strong) UIButton           *pickImageMenuBtn;
    @property (nonatomic,strong) UIColor            *selectedColor;
    @property (nonatomic,strong) UIImageView        *backGroundImageView;
    @property (nonatomic,strong) UIView             *hubView;
    @property (nonatomic,strong) videoRightView     *rightView;
    @property (nonatomic,strong) pickImageView      *imageSelectView;
    @property (nonatomic,strong) imageMenuView      *imageMenuView;

@property (nonatomic,strong) UIButton *camerabtn;


@property (nonatomic,strong) UIView *hidview;
@end

@implementation faceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawView=[[PIDrawerView alloc]init];
    drawView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:self.teacherView];
    [self.view addSubview:self.studentView];
    
    [self.view addSubview:self.hidview];
    
    [self.view addSubview:self.backGroundImageView];
    
    [self.view addSubview:drawView];
    
    
    [self.view addSubview:self.pickImageMenuBtn];
    
    [self.view addSubview:self.writeButton];
    [self.view addSubview:self.pickColorButton];
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.eraseBtn];
    [self.view addSubview:self.imageSelectView];
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.camerabtn];
    
    self.selectedColor = [UIColor redColor];
    drawView.selectedColor=self.selectedColor;
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.imageMenuView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnColor:) name:@"returnColor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnImage:) name:@"returnImage" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnDocument:) name:@"returnSelectDocument" object:nil];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
}
-(void)loadView{
    [super loadView];
    
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backGroundImageView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    drawView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    self.hidview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
    
    self.backBtn.frame = CGRectMake(0, 0, 50, 50);
    self.eraseBtn.frame = CGRectMake(screenHeight-300, screenWidth-50, 50, 50);

    self.writeButton.frame=CGRectMake(screenHeight-250, screenWidth-50, 50, 50);
    
    self.pickColorButton.frame=CGRectMake(screenHeight-200, screenWidth-50, 50, 50);
    
    self.clearBtn.frame=CGRectMake(screenHeight-150, screenWidth-50, 50, 50);
    
    self.pickImageMenuBtn.frame = CGRectMake(screenHeight-100, screenWidth-50, 50, 50);
    
    self.camerabtn.frame = CGRectMake(0, screenWidth-50, 50, 50);
}

#pragma mark - Observer

-(void)toReturnColor:(NSNotification *)notification{
    
    UIColor *receiveColor=(UIColor *)[notification object];
    self.selectedColor=receiveColor;
    drawView.selectedColor=self.selectedColor;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    
    
}
-(void)toReturnImage:(NSNotification *)notification{
    
    UIImage *receiveImage=(UIImage *)[notification object];
    self.backGroundImageView.image=receiveImage;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageSelectView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
  //  self.pickImageButton.selected=!self.pickImageButton.selected;
    
}
-(void)toReturnDocument:(NSNotification *)notification{
    
//    NSString *receiveStr=(NSString *)[notification object];
    
    [self imagePickClick];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageMenuView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    self.pickImageMenuBtn.selected=!self.pickImageMenuBtn.selected;
    
}

#pragma mark - click
-(void)eraseBtnClick{
    [drawView setDrawingMode:DrawingModeErase];
}

-(void)clearBtnClick{
    [drawView removeFromSuperview];
    drawView=[[PIDrawerView alloc]init];
    drawView.backgroundColor=[UIColor clearColor];
    drawView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    [self.view addSubview:drawView];
    drawView.selectedColor=self.selectedColor;
    [drawView setDrawingMode:DrawingModePaint];
}

-(void)backBtnClick{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)writeBtnClick{
    [drawView setDrawingMode:DrawingModePaint];
}

-(void)imageMenuPickClick{
    
    self.pickImageMenuBtn.selected=!self.pickImageMenuBtn.selected;
    
    if(self.pickImageMenuBtn.selected){
        
        [self.view addSubview:self.hubView];
        [self.view bringSubviewToFront:self.imageMenuView];
        [self.view bringSubviewToFront:self.backBtn];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageMenuView.transform =CGAffineTransformMakeTranslation(-200, 0);
        }completion:^(BOOL finished) {
            
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageMenuView.transform =CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
        
        
    }

}

-(void)imagePickClick{
    //[self addimage];
    
    
    
    //self.pickImageButton.selected=!self.pickImageButton.selected;
    
    if(self.pickImageMenuBtn.selected){
        
        [self.view addSubview:self.hubView];
        [self.view bringSubviewToFront:self.imageSelectView];
        [self.view bringSubviewToFront:self.backBtn];

        [UIView animateWithDuration:0.3 animations:^{
            self.imageSelectView.transform =CGAffineTransformMakeTranslation(-200, 0);
        }completion:^(BOOL finished) {
            
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.imageSelectView.transform =CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
        
        
    }
}

-(void)pickColorBtnClick{
    
    self.pickColorButton.selected=!self.pickColorButton.selected;
    
    if(self.pickColorButton.selected){
        
        [self.view addSubview:self.hubView];
        [self.view bringSubviewToFront:self.rightView];
        [self.view bringSubviewToFront:self.backBtn];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getColor" object:self.selectedColor];
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform =CGAffineTransformMakeTranslation(-200, 0);
        }completion:^(BOOL finished) {
            
        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.rightView.transform =CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            
        }];
        
        
    }
}



#pragma mark - methods

-(void)hideLoginView{
    
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.imageSelectView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.imageMenuView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    self.pickImageMenuBtn.selected=NO;
    self.pickColorButton.selected=NO;
    
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
        alertController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"选择背景图片" preferredStyle:UIAlertControllerStyleAlert];
        
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


#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
        {
            image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    self.backGroundImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters


-(UIView *)hidview
{
    if(!_hidview)
    {
        _hidview = [[UIView alloc] init];
        _hidview.backgroundColor = [UIColor blackColor];
        _hidview.alpha = 0.6;
    }
    return _hidview;
}


-(UIButton *)camerabtn
{
    if(!_camerabtn)
    {
        _camerabtn = [[UIButton alloc] init];
        [_camerabtn setImage:[UIImage imageNamed:@"摄像头－关"] forState:UIControlStateNormal];
    }
    return _camerabtn;
}

-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIView *)teacherView{
    if(!_teacherView){
        _teacherView=[[UIView alloc]init];
        _teacherView.frame=CGRectMake(0, 0, 250, 180);
        UIImageView *teacherImageView=[[UIImageView alloc]initWithFrame:_teacherView.bounds];
        teacherImageView.image=[UIImage imageNamed:@"student.jpg"];
        [_teacherView addSubview:teacherImageView];
    
    }
    return _teacherView;
}
-(UIView *)studentView{
    if(!_studentView){
        _studentView=[[UIView alloc]init];
        _studentView.frame=CGRectMake(0, 185, 250, 180);
        UIImageView *studentImageView=[[UIImageView alloc]initWithFrame:_teacherView.bounds];
        studentImageView.image=[UIImage imageNamed:@"teacher.jpg"];
        [_studentView addSubview:studentImageView];
        
    }
    return _studentView;
}



-(UIImageView *)backGroundImageView{
    if(!_backGroundImageView){
        _backGroundImageView=[[UIImageView alloc]init];
    }
    return _backGroundImageView;
}
-(UIButton *)writeButton{
    if(!_writeButton){
        _writeButton=[[UIButton alloc]init];
        [_writeButton addTarget:self action:@selector(writeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_writeButton setImage:[UIImage imageNamed:@"画笔"] forState:UIControlStateNormal];
        [_writeButton setTitle:@"开始涂鸦" forState:UIControlStateNormal];
        _writeButton.titleLabel.font=[UIFont systemFontOfSize:20];
        [_writeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _writeButton;
}

-(UIButton *)pickColorButton{
    if(!_pickColorButton){
        _pickColorButton=[[UIButton alloc]init];
        [_pickColorButton addTarget:self action:@selector(pickColorBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickColorButton setImage:[UIImage imageNamed:@"颜色"] forState:UIControlStateNormal];
        [_pickColorButton setTitle:@"选取颜色" forState:UIControlStateNormal];
        _pickColorButton.titleLabel.font=[UIFont systemFontOfSize:20];
        [_pickColorButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _pickColorButton;
}

-(UIView *)hubView{
    if (!_hubView){
        _hubView = [[UIView alloc]initWithFrame:self.view.bounds];
        _hubView.backgroundColor = [UIColor blackColor];
        _hubView.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLoginView)];
        [_hubView addGestureRecognizer:tap];
    }
    return _hubView;
}
-(videoRightView*)rightView{
    
    if (!_rightView) {
        _rightView = [[videoRightView alloc]initWithFrame:CGRectMake(screenHeight, 0,200, screenWidth)];
        [_rightView setCurrentSelectedColor:self.selectedColor];
    }
    return _rightView;
}

-(UIButton *)clearBtn{
    if(!_clearBtn){
        _clearBtn=[[UIButton alloc]init];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setImage:[UIImage imageNamed:@"clean"] forState:UIControlStateNormal];
        [_clearBtn setTitle:@"清空涂鸦" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _clearBtn;
}

-(UIButton *)eraseBtn{
    if(!_eraseBtn){
        _eraseBtn=[[UIButton alloc]init];
        [_eraseBtn addTarget:self action:@selector(eraseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_eraseBtn setImage:[UIImage imageNamed:@"橡皮"] forState:UIControlStateNormal];
        [_eraseBtn setTitle:@"橡皮" forState:UIControlStateNormal];
        _eraseBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_eraseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _eraseBtn;
}

-(pickImageView*)imageSelectView{
    
    if (!_imageSelectView) {
        _imageSelectView = [[pickImageView alloc]initWithFrame:CGRectMake(screenHeight, 0,200, screenWidth)];
    }
    return _imageSelectView;
}
-(imageMenuView*)imageMenuView{
    
    if (!_imageMenuView) {
        _imageMenuView = [[imageMenuView alloc]initWithFrame:CGRectMake(screenHeight, 0,200, screenWidth)];
    }
    return _imageMenuView;
}


-(UIButton *)pickImageMenuBtn{
    if(!_pickImageMenuBtn){
        _pickImageMenuBtn=[[UIButton alloc]init];
        [_pickImageMenuBtn addTarget:self action:@selector(imageMenuPickClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickImageMenuBtn setTitle:@"选取图片" forState:UIControlStateNormal];
        [_pickImageMenuBtn setImage:[UIImage imageNamed:@"图库"] forState:UIControlStateNormal];
        _pickImageMenuBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_pickImageMenuBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _pickImageMenuBtn;
}

@end
