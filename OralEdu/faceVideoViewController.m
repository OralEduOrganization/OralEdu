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
#import <RongIMLib/RongIMLib.h>

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "NSString+HBWmd5.h"


#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyMSC.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechUnderstander.h"



typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface faceVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,AVAudioRecorderDelegate,RCIMClientReceiveMessageDelegate,IFlySpeechRecognizerDelegate>
{
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
@property (nonatomic, strong) UITableView *languageTableview;
@property (nonatomic, strong) NSMutableArray *languagearr;

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层

@property (strong, nonatomic)  UIButton *takeButton;//拍照按钮
@property (strong, nonatomic)  UIButton *flashAutoButton;//自动闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOnButton;//打开闪光灯按钮
@property (strong, nonatomic)  UIButton *flashOffButton;//关闭闪光灯按钮
@property (strong, nonatomic)  UIImageView *focusCursor; //聚焦光标


@property (nonatomic,strong) NSString *cellMessageID;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *target_id;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *userIdentifier;


@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic)         BOOL                  isCanceled;
@property (nonatomic,strong) NSString               *result;
@property (nonatomic, strong) UILabel *resultLabel;


@end

@implementation faceVideoViewController



- (instancetype)initWithUserId:(NSString *)userId andTargedId:(NSString *)targetId
{
    self = [super init];
    if (self) {
        [self setUserMessage:userId andTarget:targetId];
    }
    return self;
}

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
    
    self.selectedColor = [UIColor redColor];
    drawView.selectedColor=self.selectedColor;
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.imageMenuView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnColor:) name:@"returnColor" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnImage:) name:@"returnImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnDocument:) name:@"returnSelectDocument" object:nil];
    
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.view.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);


    NSArray *arr = [self getData];
    _dataArr = [NSMutableArray arrayWithArray:arr];
    
    self.tackarray = [NSMutableArray array];
    
    [self.view addSubview:self.tacktableview];
    
    [self.view addSubview:self.sview];
    
    [self.view addSubview:self.languageTableview];
    
    
//    self.userIdentifier = @"TRANSTOR";
//    
//    self.user_id = @"aaa";
//    self.target_id = @"aa";
//    self.senderID = self.user_id;
//    [self getTokenWithUserID:self.user_id];        //获取token并且登录融云服务器
//
//    
//    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
   
    NSString *appid = @"577ca611";//自己申请的appId
    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
    [IFlySpeechUtility createUtility:initString];

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [super viewWillDisappear:animated];
}


-(void)setUserMessage:(NSString *)userId andTarget:(NSString *)targetId{

    self.userIdentifier = @"TRANSTOR";
    self.user_id=userId;
    self.target_id=targetId;
    self.senderID = self.user_id;
    [self getTokenWithUserID:self.user_id];        //获取token并且登录融云服务器
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];

}


-(void)loadView{
    [super loadView];
    
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    
    [refresh endRefreshing];
}


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
    
    self.sview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width-50, [UIScreen mainScreen].bounds.size.height, 50);
    
    self.studentView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.width-50)/2,screenHeight/4 , (screenWidth-50)/2);

    self.teacherView.frame = CGRectMake(0, 0, screenHeight/4, (screenWidth-50)/2);
    
    self.tacktableview.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.width-50)/2, [UIScreen mainScreen].bounds.size.height/4, [UIScreen mainScreen].bounds.size.width/2-50);
 
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
    
    [self sendTextMessageMethodWithString:@"ceshishuju"];
//    [drawView removeFromSuperview];
//    drawView=[[PIDrawerView alloc]init];
//    drawView.backgroundColor=[UIColor clearColor];
//    drawView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth);
//    [self.view addSubview:drawView];
//    [self.view bringSubviewToFront:self.sview];
//    drawView.selectedColor=self.selectedColor;
//    [drawView setDrawingMode:DrawingModePaint];
    
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
        [_sview.speakbtn addTarget:self action:@selector(speakbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_sview.speakbtn addTarget:self action:@selector(speakbtntouchdown) forControlEvents:UIControlEventTouchDown];
        
    }
    return _sview;
}

-(UIButton *)backBtn
{
    if(!_backBtn){
        _backBtn=[[UIButton alloc]init];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        [_backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIView *)teacherView
{
    if(!_teacherView){
        _teacherView=[[UIView alloc]init];
        _teacherView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"student.jpg"]];
    }
    return _teacherView;
}

-(UIView *)studentView{
    if(!_studentView){
        _studentView=[[UIView alloc]init];
        _studentView.transform = CGAffineTransformMakeRotation(M_PI/2);
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
    CGRect needRect=CGRectMake(screenH/4-textLabelSize.height-30, 5, textLabelSize.width, textLabelSize.height);
    
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


//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {   //设置样式
    
    
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden { //设置隐藏显示
    return YES;
}


#pragma mark - 融云->链接融云服务器 & 获取token

-(void)connectRongCloudServerWithToken:(NSString *)token{
    //融云
    [[RCIMClient sharedRCIMClient]initWithAppKey:@"82hegw5uhhmgx"];
    [[RCIMClient sharedRCIMClient] connectWithToken:token
                                            success:^(NSString *userId) {
                                                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                            } error:^(RCConnectErrorCode status) {
                                                NSLog(@"登陆的错误码为:%ld", (long)status);
                                            } tokenIncorrect:^{
                                                //token过期或者不正确。
                                                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                [self getTokenWithUserID:self.user_id];//重新获取token;
                                                NSLog(@"token错误");
                                            }];
}

-(void)getTokenWithUserID:(NSString *)userID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlstr =@"https://api.cn.rong.io/user/getToken.json";
    NSDictionary *dic =@{@"userId":userID,
                         @"name":userID,
                         @"portraitUri":@""
                         };
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString * appkey = @"82hegw5uhhmgx";
    NSString * Signature = [[NSString stringWithFormat:@"%@%@%@",appkey,nonce,timestamp] sha1];//sha1对签名进行加密
    //以下拼接请求内容
    [manager.requestSerializer setValue:appkey forHTTPHeaderField:@"App-Key"];
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    [manager.requestSerializer setValue:@"dcT8Jah7TP" forHTTPHeaderField:@"appSecret"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //开始请求
    [manager POST:urlstr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@" %@", responseObject);
        
        NSLog(@"%@",responseObject[@"token"]);
        
        [self connectRongCloudServerWithToken:responseObject[@"token"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"%@",error);
    }];
    
}

#pragma mark - 融云


-(NSDictionary *)getRCMessageDictionaryWithExtra:(NSString *)extra{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray  * array= [extra componentsSeparatedByString:@"&"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *depStr = array[i];
        NSArray *arr = [depStr componentsSeparatedByString:@":"];
        [dic setObject:arr[1] forKey:arr[0]];
    }
    
    return dic;
}


////发送一条语音消息
//-(void)sendAWebVoice:(NSString *)extra{
//    
//    NSDictionary *dict = [self getRCMessageDictionaryWithExtra:extra];
//    
//    
//    NSURL *URL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:self.cellMessageID]];
//    
//    RCVoiceMessage *voiceMessage = [RCVoiceMessage messageWithAudio:[NSData dataWithContentsOfURL:URL] duration:[dict[@"audioSecond"] intValue]];
//    
//    voiceMessage.extra = extra;
//    
//    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.target_id content:voiceMessage pushContent:nil pushData:nil success:^(long messageId) {
//        NSLog(@"发送成功。当前消息ID：%ld", messageId);
//    } error:^(RCErrorCode nErrorCode, long messageId) {
//        NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
//    }];
//    
//}
//发送一条文本消息
-(void)sendAwebMessage:(NSString *)extra{
    // 构建消息的内容，这里以文本消息为例。
    RCTextMessage *testMessage = [RCTextMessage messageWithContent:@"Extra已经携带一切信息"];
    // 调用RCIMClient的sendMessage方法进行发送，结果会通过回调进行反馈。
    testMessage.extra = extra;
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
                                      targetId:self.target_id
                                       content:testMessage
                                   pushContent:nil
                                      pushData:nil
                                       success:^(long messageId) {
                                           NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                       } error:^(RCErrorCode nErrorCode, long messageId) {
                                           NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)nErrorCode);
                                       }];
}

//接收文本以及语音消息
- (void)onReceived:(RCMessage *)message
              left:(int)nLeft
            object:(id)object {
    
    
    if ([self.target_id isEqualToString:message.senderUserId]) {
        if ([message.content isMemberOfClass:[RCTextMessage class]]) {
            RCTextMessage *testMessage = (RCTextMessage *)message.content;
            
            NSLog(@"消息内容：%@,附带消息内容---%@asdasdas----%@", testMessage.content,testMessage.extra,message.senderUserId);
            
            NSDictionary *dict = [self getRCMessageDictionaryWithExtra:testMessage.extra];
            NSLog(@"消息信息》》》%@",dict);
            ///////////////////////////////////////////
            ///////////
            //////
            
            
            
            
            
            NSInteger count = self.dataArr.count;
            
            [self.dataArr insertObject:dict atIndex:count];
            //////
            /////////
            ////////////
            ////////////////////////////
        }
        
        
        
        if ([message.content isMemberOfClass:[RCVoiceMessage class]]) {
            
            RCVoiceMessage *voiceMessage = (RCVoiceMessage *)message.content;
            
            NSLog(@"时长：%ld,附带消息内容---%@asdasdas----%@", voiceMessage.duration,voiceMessage.extra,voiceMessage.wavAudioData);
            
            //语音存在本地，并且加入展示数组⬇️
            NSDictionary *dic = [self getRCMessageDictionaryWithExtra:voiceMessage.extra];
            NSURL *uurl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:dic[@"messageID"]]];
            [voiceMessage.wavAudioData writeToURL:uurl atomically:NO];
            NSLog(@"sccczsc...%@df%@",dic,uurl);
            
            NSInteger count = self.dataArr.count;
            [self.dataArr insertObject:dic atIndex:count];

            
            
            
            
        }
        
    }else{
        NSLog(@"对话的人已经改变了！");
    }
    
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}


//获取当前时间string
-(NSString *)getCurerentTimeString{
    
    
    NSDate *currentTime = [NSDate date];
    
    NSString *dateString = [self fromDateToNSString:currentTime];
    
    return dateString;
}
//Date转化为Nsstring方法
//格式为：2016-04-0813:15:10" 把这个字符串传进去 @"yyyy-MM-ddHH:mm:ss"
-(NSString *)fromDateToNSString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-ddHH-mm-ss"];
    
    
    NSString *dateNSString = [formatter stringFromDate:date];
    
    
    return dateNSString;
}



-(void)sendTextMessageMethodWithString:(NSString *)text{
    
    NSString *currentDateString = [self getCurerentTimeString];
    self.cellMessageID = currentDateString;
    
    NSInteger count = self.dataArr.count;
    
    NSDictionary *dict = @{@"senderID":self.senderID,
                           @"chatTextContent":text,
                           @"chatContentType":@"text",
                           @"chatPictureURLContent":@"",
                           @"messageID":self.cellMessageID,
                           @"senderImgPictureURL":@"",
                           @"chatAudioContent":self.cellMessageID,
                           @"audioSecond":@"",
                           @"sendIdentifier":self.userIdentifier,
                           @"AVtoStringContent":@"",
                           @"sendTime":self.cellMessageID};
    
    
    NSString *extra = [self getRCMessageExtraStringWithsenderID:dict[@"senderID"] chatTextContent:dict[@"chatTextContent"] chatContentType:dict[@"chatContentType"] chatPictureURLContent:dict[@"chatPictureURLContent"] messageID:dict[@"messageID"] senderImgPictureURL:dict[@"senderImgPictureURL"] chatAudioContent:dict[@"chatAudioContent"] audioSecond:dict[@"audioSecond"] sendIdentifier:dict[@"sendIdentifier"] AVtoStringContent:dict[@"AVtoStringContent"] sendTime:dict[@"sendTime"]];
    [self sendAwebMessage:extra];
    
//    self.inputTextView.text = nil;
    [self.dataArr insertObject:dict atIndex:count];
    ///////////
    NSInteger cccount = self.dataSource.count;
    NSIndexPath *iindex = [NSIndexPath indexPathForRow:cccount - 1 inSection:0];
//    CGRect    rect = [self.bottomTableView rectForRowAtIndexPath:iindex];
//    CGFloat   cellMaxY = rect.origin.y + rect.size.height;
    ;
    
}

#pragma mark - extra自制定制方法

-(NSString *)getRCMessageExtraStringWithsenderID:(NSString *)senderID chatTextContent:(NSString *)chatTextContent chatContentType:(NSString *)chatContentType chatPictureURLContent:(NSString *)chatPictureURLContent messageID:(NSString *)messageID senderImgPictureURL:(NSString *)senderImgPictureURL chatAudioContent:(NSString *)chatAudioContent audioSecond:(NSString *)audioSecond sendIdentifier:(NSString *)sendIdentifier AVtoStringContent:(NSString *)AVtoStringContent sendTime:(NSString *)sendTime{
    
    NSString *one = [NSString stringWithFormat:@"senderID:%@",senderID];
    NSString *two = [NSString stringWithFormat:@"chatTextContent:%@",chatTextContent];
    NSString *three = [NSString stringWithFormat:@"chatContentType:%@",chatContentType];
    NSString *four = [NSString stringWithFormat:@"chatPictureURLContent:%@",chatPictureURLContent];
    NSString *five = [NSString stringWithFormat:@"messageID:%@",messageID];
    NSString *six = [NSString stringWithFormat:@"senderImgPictureURL:%@",senderImgPictureURL];
    NSString *seven = [NSString stringWithFormat:@"chatAudioContent:%@",chatAudioContent];
    NSString *eight = [NSString stringWithFormat:@"audioSecond:%@",audioSecond];
    NSString *nine = [NSString stringWithFormat:@"sendIdentifier:%@",sendIdentifier];
    NSString *ten = [NSString stringWithFormat:@"AVtoStringContent:%@",AVtoStringContent];
    NSString *eleven = [NSString stringWithFormat:@"sendTime:%@",sendTime];
    
    
    NSString *resultString = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@&%@&%@&%@",one,two,three,four,five,six,seven,eight,nine,ten,eleven];
    
    return resultString;
    
}




//聊天发送按钮事件
-(void)speakbtnclick
{
    
    [_iFlySpeechRecognizer stopListening];   //结束监听，并开始识别
    NSLog(@"抬起");
}
-(void)speakbtntouchdown
{
    self.resultLabel.text=@"";
    
    self.isCanceled = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    if (!ret) {
        NSLog(@"启动识别服务失败，请稍后重试");
        //可能是上次请求未结束，暂不支持多路并发
    }
    NSLog(@"启动识别失败!");
}
    





#pragma mark - IFlySpeechRecognizerDelegate
/**
 61  * @fn      onVolumeChanged
 62  * @brief   音量变化回调
 63  * @param   volume      -[in] 录音的音量，音量范围1~100
 64  * @see
 65  */
- (void) onVolumeChanged: (int)volume
{
    
}

/**
 72  * @fn      onBeginOfSpeech
 73  * @brief   开始识别回调
 74  * @see
 75  */
- (void) onBeginOfSpeech
{
    
}

/**
 82  * @fn      onEndOfSpeech
 83  * @brief   停止录音回调
 84  * @see
 85  */
- (void) onEndOfSpeech
{
    
}

/**
 92  * @fn      onError
 93  * @brief   识别结束回调
 94  * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 95  */

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    NSLog(@"DIC:%@",dic);
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    //把相应的控件赋值为result.例如:label.text = result;
    if(self.resultLabel.text){
        self.resultLabel.text=[NSString stringWithFormat:@"%@%@",self.resultLabel.text,result];
    }else{
        self.resultLabel.text=result;
    }
    
}

- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        
        text = @"识别成功";
        
    }
    else{
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
}

/**
 117  * @fn      onResults
 118  * @brief   识别结果回调
 119  * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 120  * @see
 121  */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSArray * temp = [[NSArray alloc]init];
    NSString * str = [[NSString alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
        
    }
    NSLog(@"听写结果：%@",result);
    //---------讯飞语音识别JSON数据解析---------//
    NSError * error;
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data: %@",data);
    NSDictionary * dic_result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray * array_ws = [dic_result objectForKey:@"ws"];
    //遍历识别结果的每一个单词
    for (int i=0; i<array_ws.count; i++) {
        temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        NSDictionary * dic_cw = [temp objectAtIndex:0];
        str = [str  stringByAppendingString:[dic_cw objectForKey:@"w"]];
        NSLog(@"识别结果:%@",[dic_cw objectForKey:@"w"]);
    }
    NSLog(@"最终的识别结果:%@",str);
    //去掉识别结果最后的标点符号
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
        NSLog(@"末尾标点符号：%@",str);
    }
    else{
        //                 self.resultLabel.text = str;
    }
    
    if(self.resultLabel.text){
        self.resultLabel.text=[NSString stringWithFormat:@"%@%@",self.resultLabel.text,str];
    }else{
        self.resultLabel.text=str;
    }
    
    NSString *need_result=self.resultLabel.text;
    
    NSLog(@"%@",need_result);
    
    //self.resultLabel.text = str;
}


-(UILabel *)resultLabel{
    if(!_resultLabel){
        _resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width, 50)];
        _resultLabel.backgroundColor=[UIColor orangeColor];
    }
    return _resultLabel;
}


-(void)initRecognizer
{
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    
    
}



@end
