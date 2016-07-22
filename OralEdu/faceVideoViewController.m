//
//  faceVideoViewController.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/1.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

//屏幕宽高
#define  screenW     [UIScreen mainScreen].bounds.size.width
#define  screenH     [UIScreen mainScreen].bounds.size.height

//设置比例
#define  scaleW  414/640
#define scaleH   736/1136

//设置图片大小
#define kPictureImageViewMaxWidth 200*scaleW
#define kPictureImageViewMaxHeight 200*scaleW

//RGB设置
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIThemeColor UIColorFromRGB(0x26252A) //背景黑色
#define UIBottomViewColor UIColorFromRGB(0xF2F2F5) //底部白色
#define UIChatViewColor UIColorFromRGB(0xE6E6E6) //聊天窗口白色

#import "faceVideoViewController.h"
#import "PIDrawerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "videoRightView.h"
#import "Datebase_materallist.h"
#import "pickImageView.h"
#import "materal_finder.h"
#import "imageMenuView.h"
#import "setview.h"
#import "tackCell.h"
#import "tackCell2.h"
#import "SVPullToRefresh.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface faceVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,IFlyRecognizerViewDelegate,AVCaptureFileOutputRecordingDelegate,AVAudioRecorderDelegate>{
    NSInteger screenWidth;
    NSInteger screenHeight;
    PIDrawerView *drawView;
}
@property (nonatomic,strong) UIButton           *backBtn;
@property (nonatomic,strong) UIView             *teacherView;
@property (nonatomic,strong) UIView             *studentView;
@property (nonatomic,strong) UIButton           *writeButton;
@property (nonatomic,strong) UIButton           *pickColorButton;
@property (nonatomic,strong) UIButton           *clearBtn;
@property (nonatomic,strong) UIButton           *eraseBtn;
@property (nonatomic,strong) UIButton           *pickImageMenuBtn;
@property (nonatomic,strong) UIColor            *selectedColor;
@property (nonatomic,strong) UIImageView        *backGroundImageView;
@property (nonatomic,strong) UIView             *hubView;
@property (nonatomic,strong) videoRightView     *rightView;
@property (nonatomic,strong) pickImageView      *imageSelectView;
@property (nonatomic,strong) imageMenuView      *imageMenuView;
@property (nonatomic,strong) UIButton           *camerabtn;
@property (nonatomic,strong) UIView             *hidview;
@property (nonatomic,strong) setview            *sview;
@property (nonatomic,strong) UIButton           *rigntbtn;
@property (nonatomic,strong) UITableView        *tacktableview;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UIButton *addImageButton;
@property (nonatomic, strong) UIButton *personButton;
@property (nonatomic, strong) UIButton *spokenButton;
@property (nonatomic, strong) UIView *chatView;
@property (nonatomic, strong) UITapGestureRecognizer *tapToHideKeyboard;
@property (nonatomic, assign) NSString * senderID;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) NSMutableArray *tackarray;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic,strong) UITableView *languageTableview;
@property (nonatomic,strong) NSMutableArray *languagearr;

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (strong, nonatomic)  UIButton *takeButton;//拍照按钮
@property (strong, nonatomic)  UIButton *flashAutoButton;//自动闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOnButton;//打开闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOffButton;//关闭闪光灯按钮
@property (strong, nonatomic)  UIImageView *focusCursor; //聚焦光标

@end

@implementation faceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawView=[[PIDrawerView alloc]init];
    drawView.backgroundColor=[UIColor clearColor];
    self.languagearr = [NSMutableArray arrayWithObjects:@"中文",@"English",@"русский",@"español",@"日本语",@"français",@"한국어",@"عربي/عربى", nil];
    
    [self.view addSubview:self.teacherView];
    
    [self.view addSubview:self.studentView];
    
    [self.view addSubview:self.backGroundImageView];
    
    [self.view addSubview:drawView];
    
    [self.view addSubview:self.pickImageMenuBtn];
    
    [self.view addSubview:self.imageSelectView];
    
    //[self.view addSubview:self.backBtn];

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
    
    self.senderID = @"0001";
    NSArray *arr = [self getData];
    _dataArr = [NSMutableArray arrayWithArray:arr];
    
    self.tackarray = [NSMutableArray array];
    
    [self.view addSubview:self.tacktableview];
    
    [self.view addSubview:self.sview];
    
    [self.view addSubview:self.languageTableview];
}
-(void)loadView{
    [super loadView];
    
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
}

-(void) refreshView:(UIRefreshControl *)refresh
{
   // long count = _dataSource.count;
   // [self reloadDataSourceWithNumber:count+1];
//    [self.chatTableView reloadData];
    [refresh endRefreshing];
}


////加载datasource
//-(void)reloadDataSourceWithNumber:(long)count{
//    _dataSource = [[NSMutableArray alloc]init];
//    long dataCount = _dataArr.count;
//    if (dataCount>=count) {
//        long j=0;
//        long m=count;
//        for (long i=count; i >0; i--) {
//            
//            [_dataSource insertObject:_dataArr[dataCount-m] atIndex:j];
//            m--;
//            j++;
//        }
//    }else{
//        for (int i=0; i<_dataArr.count; i++) {
//            [_dataSource insertObject:_dataArr[i] atIndex:i];
//        }
//    }
//}

-(UIRefreshControl *)refreshControl{
    
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
        [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松开加载更多"]];
        
    }
    return _refreshControl;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backGroundImageView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth-50);

    drawView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth);
    
    self.sview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
    
    self.studentView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-50)/2,screenHeight/4 , (screenWidth-50)/2);

    self.teacherView.frame = CGRectMake(0, 0, screenHeight/4, (screenWidth-50)/2);
    
    self.tacktableview.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-50)/2, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.height/2-50);
    
    self.backBtn.frame = CGRectMake(0, 0, 50, 50);
    
    self.languageTableview.frame = CGRectMake(screenHeight, 0, screenHeight/4, screenWidth);
    
    
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得前置摄像头
    if (!captureDevice) {
        NSLog(@"取得前置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    

    CALayer *layer=self.studentView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    //[layer addSublayer:_captureVideoPreviewLayer];
    
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
    [self setFlashModeButtonStatus];
    
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
    self.sview.pickImageMenuBtn.selected =!self.sview.pickImageMenuBtn.selected;
}

-(void)toReturnDocument:(NSNotification *)notification{
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
    drawView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth);
    [self.view addSubview:drawView];
    [self.view bringSubviewToFront:self.sview];
    drawView.selectedColor=self.selectedColor;
    [drawView setDrawingMode:DrawingModePaint];
    
}

//挂断通话，返回上个界面

-(void)backBtnClick{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"确定要挂掉通话吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    
    [control addAction:action1];
    [control addAction:action2];
    
    [self presentViewController:control animated:YES completion:nil];
}

-(void)writeBtnClick{
    [drawView setDrawingMode:DrawingModePaint];
}

-(void)imageMenuPickClick{
    
    self.sview.pickImageMenuBtn.selected=!self.sview.pickImageMenuBtn.selected;
    if(!self.pickImageMenuBtn.selected){
        
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
    
    if(!self.pickImageMenuBtn.selected){
        
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
    self.sview.pickColorButton.selected=!self.sview.pickColorButton.selected;
    if(!self.pickColorButton.selected){
        
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
    [UIView animateWithDuration:0.3 animations:^{
        self.languageTableview.transform =CGAffineTransformIdentity;
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

-(setview *)sview
{
    if(!_sview)
    {
        _sview = [[setview alloc] init];
        _sview.backgroundColor = [UIColor blackColor];
        _sview.alpha = 0.8;
        _sview.pickColorButton.selected=true;
        _sview.pickImageMenuBtn.selected=true;
        [_sview.writeButton addTarget:self action:@selector(writeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.eraseBtn addTarget:self action:@selector(eraseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.pickColorButton addTarget:self action:@selector(pickColorBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.pickImageMenuBtn addTarget:self action:@selector(imageMenuPickClick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.leftbtn addTarget:self action:@selector(suofang) forControlEvents:UIControlEventTouchUpInside];
        [_sview.tackbtn addTarget:self action:@selector(tackbenclick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.speakbackbtn addTarget:self action:@selector(speakbackbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.languagebtn addTarget:self action:@selector(languagexuanze) forControlEvents:UIControlEventTouchUpInside];
        [_sview.stopbtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sview;
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
        _teacherView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"student.jpg"]];
    }
    return _teacherView;
}

-(UIView *)studentView{
    if(!_studentView){
        _studentView=[[UIView alloc]init];
        _studentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"teacher.jpg"]];
    }
    return _studentView;
}

-(UIImageView *)backGroundImageView{
    if(!_backGroundImageView){
        _backGroundImageView=[[UIImageView alloc]init];
    }
    return _backGroundImageView;
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


//聊天界面的tableview
-(UITableView *)tacktableview{
    
    if (!_tacktableview) {
        _tacktableview=[[UITableView alloc]init];
        _tacktableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tacktableview.allowsSelection = NO;
        _tacktableview.dataSource=self;
        _tacktableview.delegate=self;
        _tacktableview.tableFooterView = [[UIView alloc]init];
        _tacktableview.showsVerticalScrollIndicator = NO;
        [_tacktableview setHidden:YES];
        [_tacktableview addSubview:self.refreshControl];
        
        if (_tacktableview.contentSize.height > _tacktableview.frame.size.height)
        {
            CGPoint offset = CGPointMake(0, _tacktableview.contentSize.height - _tacktableview.frame.size.height);
            [_tacktableview setContentOffset:offset animated:YES];
        }
    }
    return _tacktableview;
}


-(UITableView *)languageTableview
{
    if(!_languageTableview)
    {
        _languageTableview = [[UITableView alloc] init];
        _languageTableview.dataSource = self;
        _languageTableview.delegate = self;
    }
    return _languageTableview;
}

-(videoRightView*)rightView{
    
    if (!_rightView) {
        _rightView = [[videoRightView alloc]initWithFrame:CGRectMake(screenHeight, 0,200, screenWidth)];
        [_rightView setCurrentSelectedColor:self.selectedColor];
    }
    return _rightView;
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

-(void)suofang
{
    _rigntbtn = [[UIButton alloc] init];
    [_rigntbtn setImage:[UIImage imageNamed:@"外拉"] forState:UIControlStateNormal];
    _rigntbtn.frame = CGRectMake(screenHeight-30, screenWidth-30, 30, 30);
    [_rigntbtn addTarget:self action:@selector(huanyuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rigntbtn];
    _rigntbtn.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.sview.transform = CGAffineTransformMakeTranslation(screenHeight, 0);
        _rigntbtn.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
}

-(void)languagexuanze
{
    [UIView animateWithDuration:0.3 animations:^{
        self.languageTableview.transform =CGAffineTransformMakeTranslation(-screenHeight/4, 0);
    }completion:^(BOOL finished) {
        
    }];
    [self.view addSubview:self.hubView];
    [self.view bringSubviewToFront:self.languageTableview];
    
}

-(void)huanyuan
{
    [UIView animateWithDuration:0.5 animations:^{
        self.sview.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {
        //[self.view addSubview:self.rigntbtn];
        [self.rigntbtn removeFromSuperview];
    }];
    
}

-(void)tackbenclick
{
    [self.sview.speakbtn setHidden:NO];
    [self.sview.camerabtn setHidden:YES];
    [self.sview.tackbtn setHidden:YES];
    [self.sview.speakbackbtn setHidden:NO];
    [self.studentView setHidden:YES];
    [self.tacktableview setHidden:NO];
    [self.sview.languagebtn setHidden:YES];
}

-(void)speakbackbtnclick
{
    [self.sview.speakbtn setHidden:YES];
    [self.sview.speakbackbtn setHidden:YES];
    [self.sview.tackbtn setHidden:NO];
    [self.sview.camerabtn setHidden:NO];
    [self.studentView setHidden:NO];
    [self.tacktableview setHidden:YES];
    [self.sview.languagebtn setHidden:NO];
}

#pragma mark - tableview DataSource

//代理实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.languageTableview) {
        return self.languagearr.count;
    }
    else
    {
        return self.dataArr.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.languageTableview )
    {
        return screenWidth/self.languagearr.count;
    }
    else
    {
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic=self.dataArr[indexPath.row];
    NSString *string=dic[@"chatText"];
    CGRect rect=[self getObjectFrameOfTextViewWithInfo:string];
    NSLog(@"%f~~~~~%f",rect.size.height,rect.size.width);
    return rect.size.height+5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";

    if (tableView==self.languageTableview) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
            cell.textLabel.text = self.languagearr[indexPath.row];
        }
        return cell;
    }
    else
    {
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic=self.dataArr[indexPath.row];
    NSString *string=dic[@"chatText"];
    NSLog(@"%@",string);
    
    NSDictionary *dic2 = [[NSDictionary alloc] init];
    dic2=self.dataArr[indexPath.row];
    NSString *sender = dic2[@"senderID"];
    NSLog(@"%@",sender);
    
    if ([sender isEqual:@"0001"]) {
        tackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[tackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tacklabel.text = string;
        CGRect rect=[self getObjectFrameOfTextViewWithInfo:string];
        
        
        cell.tacklabel.frame=rect;
        
        
        //cell.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:cell.tacklabel];
        
        
        return cell;
    }
    else
    {
        tackCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        cell = [[tackCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        cell.tacklabel.text = string;
        CGRect rect=[self getObjectFrameOfTextViewWithInfo2:string];
        
        
        cell.tacklabel.frame=rect;
        // cell.backgroundColor = [UIColor greenColor];
        [cell.contentView addSubview:cell.tacklabel];
        
        
        return cell;
    }
    }
    return nil;
}

-(NSArray *)getData{
    
    NSArray *arr= @[
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟"},
                    @{@"senderID":@"0002",@"chatText":@"行"},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点"},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼"},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－"},
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟"},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行"},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点"},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼"},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－"},
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟"},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行"},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点"},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼"},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－"}
                    ];
    return arr;
}

-(CGRect )getObjectFrameOfTextViewWithInfo:(NSString *)info{
    
    //如果发送内容为文字，计算文字高度。
    CGSize textLabelSize;
    
    textLabelSize = [info boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} context:nil].size;
    
    CGRect needRect=CGRectMake(5, 5, textLabelSize.width, textLabelSize.height);
    
    return needRect;
    
}

-(CGRect )getObjectFrameOfTextViewWithInfo2:(NSString *)info{
    
    //如果发送内容为文字，计算文字高度。
    CGSize textLabelSize;
    
    textLabelSize = [info boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} context:nil].size;    
    CGRect needRect=CGRectMake(screenW/4-textLabelSize.width-5, 5, textLabelSize.width, textLabelSize.height);
    
    return needRect;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.languageTableview) {
        if (indexPath.row==0) {
            NSLog(@"中文");
            [self.sview.languagebtn setTitle:@"中" forState:UIControlStateNormal];
        }
        if (indexPath.row==1) {
            NSLog(@"英文");
            [self.sview.languagebtn setTitle:@"英" forState:UIControlStateNormal];

        }
        if (indexPath.row==2) {
            NSLog(@"俄语");
            [self.sview.languagebtn setTitle:@"俄" forState:UIControlStateNormal];

        }
        if (indexPath.row==3) {
            NSLog(@"西班牙语");
            [self.sview.languagebtn setTitle:@"西" forState:UIControlStateNormal];

        }
        if (indexPath.row==4) {
            NSLog(@"日语");
            [self.sview.languagebtn setTitle:@"日" forState:UIControlStateNormal];

        }
        if (indexPath.row==5) {
            NSLog(@"法语");
            [self.sview.languagebtn setTitle:@"法" forState:UIControlStateNormal];

        }
        if (indexPath.row==6) {
            NSLog(@"韩语");
            [self.sview.languagebtn setTitle:@"韩" forState:UIControlStateNormal];

        }
        if (indexPath.row==7) {
            NSLog(@"阿拉伯语");
            [self.sview.languagebtn setTitle:@"阿" forState:UIControlStateNormal];

        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

-(void)dealloc{
    [self removeNotification];
}
#pragma mark - UI方法
#pragma mark 拍照
- (void)takeButtonClick:(UIButton *)sender {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image=[UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     
        }
        
    }];
}
#pragma mark 切换前后摄像头
- (void)toggleButtonClick:(UIButton *)sender {
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput]) {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
    
    [self setFlashModeButtonStatus];
}

#pragma mark 自动闪光灯开启
- (void)flashAutoClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeAuto];
    [self setFlashModeButtonStatus];
}
#pragma mark 打开闪光灯
- (void)flashOnClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeOn];
    [self setFlashModeButtonStatus];
}
#pragma mark 关闭闪光灯
- (void)flashOffClick:(UIButton *)sender {
    [self setFlashMode:AVCaptureFlashModeOff];
    [self setFlashModeButtonStatus];
}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.studentView addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.studentView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置闪光灯按钮状态
 */
-(void)setFlashModeButtonStatus{
    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
    AVCaptureFlashMode flashMode=captureDevice.flashMode;
    if([captureDevice isFlashAvailable]){
        self.flashAutoButton.hidden=NO;
        self.flashOnButton.hidden=NO;
        self.flashOffButton.hidden=NO;
        self.flashAutoButton.enabled=YES;
        self.flashOnButton.enabled=YES;
        self.flashOffButton.enabled=YES;
        switch (flashMode) {
            case AVCaptureFlashModeAuto:
                self.flashAutoButton.enabled=NO;
                break;
            case AVCaptureFlashModeOn:
                self.flashOnButton.enabled=NO;
                break;
            case AVCaptureFlashModeOff:
                self.flashOffButton.enabled=NO;
                break;
            default:
                break;
        }
    }else{
        self.flashAutoButton.hidden=YES;
        self.flashOnButton.hidden=YES;
        self.flashOffButton.hidden=YES;
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}


@end
