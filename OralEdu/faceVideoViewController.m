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
#import "ChatCell.h"
#import "SRChatFrameInfo.h"
#import "SRChatModel.h"
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
@property (nonatomic, strong) UITableView *frientTableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *writeButton1;
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
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;
@property (nonatomic, strong) UILabel *voiceTextLabel;

@end

@implementation faceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawView=[[PIDrawerView alloc]init];
    drawView.backgroundColor=[UIColor clearColor];

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
    [self.view addSubview:self.inputView];
    _dataArr = [NSMutableArray arrayWithArray:arr];
    _dataSource = [[NSMutableArray alloc]init];
    [self reloadDataSourceWithNumber:20];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self addAllControl];
    [self.tacktableview setContentOffset:CGPointMake(0,self.tacktableview.bounds.size.height)];

    [self.view addSubview:self.tacktableview];

    [self.view addSubview:self.sview];
    
}
-(void)loadView{
    [super loadView];
    
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backGroundImageView.frame = CGRectMake(260, 0, screenHeight-260, screenWidth-50);
    
    drawView.frame = CGRectMake(screenHeight/4, 0, screenHeight-screenHeight/4, screenWidth-50);
    
    self.sview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
    
    self.studentView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/4, screenWidth/2);
    
    self.teacherView.frame=CGRectMake(0, 0, screenHeight/4, screenWidth/2);
    
    self.tacktableview.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width/4, screenWidth);

    self.backBtn.frame = CGRectMake(0, 0, 50, 50);
    
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
   // self.sview.pickImageButton.selected=!self.sview.pickImageButton.selected;
    self.sview.pickImageMenuBtn.selected =!self.sview.pickImageMenuBtn.selected;
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
    //[self addimage];
    
    //self.pickImageButton.selected=!self.pickImageButton.selected;
    
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
        [_tacktableview registerClass:[ChatCell class] forCellReuseIdentifier:@"Cell"];
        _tacktableview.backgroundColor = [UIColor orangeColor];
        _tacktableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tacktableview.allowsSelection = NO;
        _tacktableview.dataSource=self;
        _tacktableview.delegate=self;
        _tacktableview.showsVerticalScrollIndicator = NO;
        _tacktableview.contentInset = UIEdgeInsetsMake(12,0, 0, 0);
        [_tacktableview setHidden:YES];
      //  NSIndexPath * index  = [NSIndexPath indexPathForRow:1 inSection:0];
//        [_tacktableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_tacktableview addSubview:self.refreshControl];
        
    }
    return _tacktableview;
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

//加载datasource
-(void)reloadDataSourceWithNumber:(long)count{
    _dataSource = [[NSMutableArray alloc]init];
    long dataCount = _dataArr.count;
    if (dataCount>=count) {
        long j=0;
        long m=count;
        for (long i=count; i >0; i--) {
            
            [_dataSource insertObject:_dataArr[dataCount-m] atIndex:j];
            m--;
            j++;
        }
    }else{
        for (int i=0; i<_dataArr.count; i++) {
            [_dataSource insertObject:_dataArr[i] atIndex:i];
        }
    }
}


//开始识别
- (void)startListenning:(id)sender{
    [self.iflyRecognizerView start];
    NSLog(@"开始识别");
}

//返回文字处理
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    NSLog(@"DIC:%@",dic);
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    //把相应的控件赋值为result.例如:label.text = result;
    if(self.voiceTextLabel.text){
        self.voiceTextLabel.text=[NSString stringWithFormat:@"%@%@",self.voiceTextLabel.text,result];
    }else{
        self.voiceTextLabel.text=result;
    }
    [self.voiceTextLabel removeFromSuperview];
    self.inputTextField.text = self.voiceTextLabel.text;
    
}
//出错处理
- (void)onError:(IFlySpeechError *)error{
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//加载所有控件
-(void)addAllControl{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.inputTextField.delegate = self;
    [self.view setBackgroundColor:UIChatViewColor];
    [self.view addSubview:self.chatView];
    
    
}

//代理实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long i= indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = _dataSource[i];
    SRChatModel *model = [[SRChatModel alloc]init];
    if ([object[@"senderID"] isEqualToString:self.senderID]) {
        model.isSender = 1;
    }else{
        model.isSender = 0;
    }
    model.senderID = object[@"senderID"];
    model.chatText = object[@"chatText"];
    model.chatContent = object[@"chatContent"];
    model.chatPictureUrl = object[@"chatPictureUrl"];
    ChatCell *cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    
    return cell.height+30*scaleH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获得dataSource；
    long i= indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *object = _dataSource[i];
    SRChatModel *model = [[SRChatModel alloc]init];
    if ([object[@"senderID"] isEqualToString:self.senderID]) {
        model.isSender = 1;
    }else{
        model.isSender = 0;
    }
    model.senderID = object[@"senderID"];
    model.chatText = object[@"chatText"];
    model.chatContent = object[@"chatContent"];
    model.chatPictureUrl = object[@"chatPictureUrl"];
    ChatCell *cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Model:model];
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击键盘中send时的事件。
    NSString *innerText = textField.text;
    int count = 0;
    for (int i=0; i<_dataArr.count; i++) {
        count = i+1;
    }
    NSDictionary *dictionary = @{@"senderID":self.senderID,@"chatText":innerText,@"chatContent":@"text",@"chatPictureUrl":@""};
    [_dataArr insertObject:dictionary atIndex:count];
    textField.text = nil;
    //    int nowCount = (int)_dataSource.count;
    [self reloadDataSourceWithNumber:20];
    
    [self.tacktableview reloadData];
    NSIndexPath * index  = [NSIndexPath indexPathForRow:_dataSource.count-1 inSection:0];
    [self.tacktableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    return YES;
}


//发送语音按钮的点击时间
-(void)turnToCall:(id)sender{
    
    [self.inputView removeFromSuperview];
    [self.callButton removeFromSuperview];
    self.inputTextField.text = nil;
    [self.bottomView addSubview:self.writeButton];
    [self.bottomView addSubview:self.spokenButton];
}


-(void)startSpoken{
    
    //[self addVoiceDiscriminate];
}


-(void)turnToWrite:(id)sender{
    
    [self.spokenButton removeFromSuperview];
    [self.writeButton removeFromSuperview];
    [self.bottomView addSubview:self.callButton];
    [self.bottomView addSubview:self.inputView];
   // [self.inputTextField becomeFirstResponder];
    
}

-(void)hideKeyboard:(id)sender{
    
    [self.inputTextField resignFirstResponder];
}

-(void)showFace:(id)sender{
    
    
}

-(void)addImage:(id)sender{
    
    
}

-(void)showPersonInformation:(id)sender{
    
    
}

-(void)keyboardWillShow:(NSNotification*)notification{
    //    NSDictionary*info=[notification userInfo];
    //调整UI位置
    self.bottomView.transform = CGAffineTransformMakeTranslation(0, -271);
    
    self.chatView.transform = CGAffineTransformMakeTranslation(0, -271);
   // self.tacktableview.frame = CGRectMake(0, 0, screenW, 911*scaleH);
}
-(void)keyboardWillHide:(NSNotification*)notification{
    //self.tacktableview.frame = CGRectMake(0, 0*scaleH, screenW, 911*scaleH);
    self.bottomView.transform = CGAffineTransformIdentity;
    self.chatView.transform = CGAffineTransformIdentity;
    //在这里调整UI位置
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    long count = _dataSource.count;
    [self reloadDataSourceWithNumber:count+10];
    [self.tacktableview reloadData];
    [refresh endRefreshing];
}


//个人信息按钮
-(UIButton *)personButton{
    
    if (!_personButton) {
        _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _personButton.frame = CGRectMake(570*scaleW, 65*scaleH, 38*scaleW, 38*scaleH);
        [_personButton setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [_personButton addTarget:self action:@selector(showPersonInformation:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personButton;
}


//底端输入文字的view
-(UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 1036*scaleH, screenW, 100*screenH)];
        [_bottomView setBackgroundColor:[UIColor blackColor]];
        [_bottomView addSubview:self.callButton];
        [_bottomView addSubview:self.inputView];
        [_bottomView addSubview:self.addImageButton];
        [_bottomView addSubview:self.faceButton];
    }
    return _bottomView;
}


-(NSArray *)getData{
    
    NSArray *arr= @[
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""},      @{@"senderID":@"0001",@"chatText":@"你好韦富钟",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"这段文字要很长很长，因为我要测试他能不能多换几行",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"这段儿短点",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0002",@"chatText":@"嗯哼",@"chatContent":@"text",@"chatPictureUrl":@""},
                    @{@"senderID":@"0001",@"chatText":@"发几个表情符号～～～～～～～～ － 。－",@"chatContent":@"text",@"chatPictureUrl":@""}
                    ];
    return arr;
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

-(UILabel *)voiceTextLabel{
    
    if (!_voiceTextLabel) {
        _voiceTextLabel = [[UILabel alloc]init];
        _voiceTextLabel.backgroundColor = [UIColor grayColor];
        _voiceTextLabel.alpha = 0.8 ;
        _voiceTextLabel.font = [UIFont systemFontOfSize:50*scaleW];
        _voiceTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _voiceTextLabel;
}

@end
