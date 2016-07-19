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
@interface faceVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,IFlyRecognizerViewDelegate>{
    
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
    
    [self.view addSubview:self.backBtn];
    
    
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
    
    drawView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth-50);
    
    self.sview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
    
    self.studentView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/4, screenWidth/2);
    
    self.teacherView.frame=CGRectMake(0, 0, screenHeight/4, screenWidth/2);
    
    self.tacktableview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.height/2-50);
    

    self.backBtn.frame = CGRectMake(0, 0, 50, 50);
   
    self.languageTableview.frame = CGRectMake(screenHeight, 0, screenHeight/4, screenWidth);
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
        [_sview.microphone addTarget:self action:@selector(languagexuanze) forControlEvents:UIControlEventTouchUpInside];
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
        //_tacktableview.backgroundColor = [UIColor orangeColor];
        _tacktableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tacktableview.allowsSelection = NO;
        _tacktableview.dataSource=self;
        _tacktableview.delegate=self;
        
        _tacktableview.tableFooterView = [[UIView alloc]init];

        _tacktableview.showsVerticalScrollIndicator = NO;
        //_tacktableview.contentInset = UIEdgeInsetsMake(12,0, 0, 0);
        [_tacktableview setHidden:YES];
        [_tacktableview addSubview:self.refreshControl];
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
       // [_languageTableview setHidden:YES];
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
}

-(void)speakbackbtnclick
{
    [self.sview.speakbtn setHidden:YES];
    [self.sview.speakbackbtn setHidden:YES];
    [self.sview.tackbtn setHidden:NO];
    [self.sview.camerabtn setHidden:NO];
    [self.studentView setHidden:NO];
    [self.tacktableview setHidden:YES];
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
    if (tableView == self.languageTableview ) {
        return 60;
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
    
    textLabelSize = [info boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:15]} context:nil].size;    //    self.textLabelWidth =
    CGRect needRect=CGRectMake(screenW/4-textLabelSize.width-5, 5, textLabelSize.width, textLabelSize.height);
    
    return needRect;
    
}

@end
