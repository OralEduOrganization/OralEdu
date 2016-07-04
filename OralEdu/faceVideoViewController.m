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

@interface faceVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    NSInteger screenWidth;
    NSInteger screenHeight;
    
}

    @property (nonatomic,strong) UIButton           *backBtn;
    @property (nonatomic,strong) UIView             *teacherView;
    @property (nonatomic,strong) UIView             *studentView;

    @property (nonatomic,strong) PIDrawerView       *drawView;
    @property (nonatomic,strong) UIButton           *writeButton;
    @property (nonatomic,strong) UIButton           *pickColorButton;
    @property (nonatomic,strong) UIButton           *pickEraserButton;
    @property (nonatomic,strong) UIButton           *pickImageButton;
    @property (nonatomic,strong) UIButton           *clearBtn;
    @property (nonatomic,strong) UIColor            *selectedColor;
    @property (nonatomic,strong) UIImageView        *backGroundImageView;

    @property (nonatomic,strong) UIView             *hubView;
    @property (nonatomic,strong) videoRightView     *rightView;

@end

@implementation faceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.teacherView];
    [self.view addSubview:self.studentView];
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.pickImageButton];
    [self.view addSubview:self.writeButton];
    [self.view addSubview:self.pickColorButton];
    [self.view addSubview:self.backBtn];
    
    self.selectedColor = [UIColor redColor];
    self.drawView.selectedColor=self.selectedColor;
    [self.view addSubview:self.rightView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnColor:) name:@"returnColor" object:nil];
    
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
    
    
    
    self.backBtn.frame = CGRectMake(400, 100, 190, 40);
    self.backGroundImageView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    self.drawView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    self.pickImageButton.frame = CGRectMake(260, screenWidth-50, 100, 50);
    self.writeButton.frame=CGRectMake(380, screenWidth-50, 100, 50);
    self.pickColorButton.frame=CGRectMake(500, screenWidth-50, 100, 50);
    
}
#pragma mark - Observer
-(void)toReturnColor:(NSNotification *)notification{
    
    UIColor *receiveColor=(UIColor *)[notification object];
    self.selectedColor=receiveColor;
    self.drawView.selectedColor=self.selectedColor;
    [self.hubView removeFromSuperview];
    self.hubView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    
    
}
#pragma mark - click
-(void)clearBtnClick{
    
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
    [self.drawView setDrawingMode:DrawingModePaint];
}
-(void)imagePickClick{
    [self addimage];
}

-(void)pickColorBtnClick{
    
    self.pickColorButton.selected=!self.pickColorButton.selected;
    
    if(self.pickColorButton.selected){
        
        [self.view addSubview:self.hubView];
        [self.view bringSubviewToFront:self.rightView];
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
    [self pickColorBtnClick];
    
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

-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.titleLabel.font=[UIFont systemFontOfSize:45];
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
-(PIDrawerView *)drawView{
    if(!_drawView){
        _drawView=[[PIDrawerView alloc]init];
        _drawView.backgroundColor=[UIColor clearColor];
    }
    return _drawView;
}

-(UIButton *)pickImageButton{
    if(!_pickImageButton){
        _pickImageButton=[[UIButton alloc]init];
        [_pickImageButton addTarget:self action:@selector(imagePickClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickImageButton setTitle:@"选取图片" forState:UIControlStateNormal];
        _pickImageButton.titleLabel.font=[UIFont systemFontOfSize:20];
        [_pickImageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _pickImageButton;
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
        [_clearBtn setTitle:@"清空涂鸦" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _clearBtn;
}



@end
