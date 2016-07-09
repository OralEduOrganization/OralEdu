//
//  voiceViewController.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/6.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "voiceViewController.h"
#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyMSC.h"

@interface voiceViewController ()<IFlyRecognizerViewDelegate>

//@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) UIButton   *returnBtn;
@property (nonatomic, strong) UIButton   *voiceBtn;
//@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
//@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象

@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation voiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.voiceBtn];
    [self.view addSubview:self.resultLabel];
    [self.view addSubview:self.returnBtn];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

    
    
    
    self.iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:CGPointMake(200, 200)];
    self.iflyRecognizerView.delegate = self;
    

}
#pragma mark - privateMethod
-(void)voiceBtnClick{
    [self.view addSubview:self.iflyRecognizerView];
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [self startListenning:self.iflyRecognizerView];//可以建一个按钮,点击按钮调用此方法
}
- (void)startListenning:(id)sender{
    [self.iflyRecognizerView start];
    NSLog(@"开始识别");
}
//返回数据处理
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

- (void)onError:(IFlySpeechError *)error
{
    
}

-(void)startBtnClick{

    
    
}
-(void)cancelBtnClick{
    //[self.iflyRecognizerView cancel];
//    [_iFlySpeechUnderstander cancel];
    
    
}
-(void)returnBtnClick{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishBtnClick{
//    [_iFlySpeechUnderstander stopListening];
}




#pragma mark - getters

-(UIButton *)voiceBtn{
    if(!_voiceBtn){
        _voiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 50)];

        [_voiceBtn addTarget:self action:@selector(voiceBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_voiceBtn setTitle:@"点击读写" forState:UIControlStateNormal];
        _voiceBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _voiceBtn.backgroundColor=[UIColor lightGrayColor];
        [_voiceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    return _voiceBtn;
}
-(UILabel *)resultLabel{
    if(!_resultLabel){
        _resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width, 50)];
        _resultLabel.backgroundColor=[UIColor orangeColor];
    }
    return _resultLabel;
}
-(UIButton *)returnBtn{
    if(!_returnBtn){
        _returnBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 200, 100, 50)];
        //点击之后滑动到其他地方进行取消的过程
//        [_returnBtn addTarget:self action:@selector(retuenBtnClick) forControlEvents:UIControlEventTouchDragOutside];
        //点击之后抬起！！后进行执行
//        [_returnBtn addTarget:self action:@selector(retuenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //点击即执行！
        [_returnBtn addTarget:self action:@selector(returnBtnClick) forControlEvents:UIControlEventTouchDown];
        
        [_returnBtn setTitle:@"点击返回" forState:UIControlStateNormal];
        _returnBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _returnBtn.backgroundColor=[UIColor lightGrayColor];
        [_returnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        

    }
    return _returnBtn;
}

@end
