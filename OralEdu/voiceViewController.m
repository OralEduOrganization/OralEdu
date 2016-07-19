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
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

#import "AFHTTPSessionManager.h"
@interface voiceViewController ()<IFlyRecognizerViewDelegate>

//@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) UIButton   *returnBtn;
@property (nonatomic, strong) UIButton   *voiceBtn;
//@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
//@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象

@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic,strong) UIButton *speakbtn;

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
    //[self.view addSubview:self.speakbtn];
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


-(UIButton *)speakbtn
{
    if(!_speakbtn)
    {
        _speakbtn = [[UIButton alloc] init];
        _speakbtn.backgroundColor = [UIColor blueColor];
        _speakbtn.frame = CGRectMake(10, 10, 100, 100);
        [_speakbtn addTarget:self action:@selector(fanyi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakbtn;
}

-(void)fanyi
{
    [self TransStr:@"程序员" ToLanguage:@"en"];
}

-(void)TransStr:(NSString *) str ToLanguage:(NSString *)language
{
    if (str == nil || str.length ==0) {
       // self.resultLabel.placeholder =@"请输入...";
        self.resultLabel.text = @"请输入...";
        return;
    }


    
    NSString *need_str=[NSString stringWithFormat:@"20160714000025224%@1234567897XG4uEkp5GzKrVdOn_18",str];

    NSString *asd=[self md5:need_str];
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?q=%@&from=auto&to=%@&appid=20160714000025224&salt=123456789&sign=%@",str,language,asd];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    [mgr GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSArray *result = dict[@"trans_result"];
        NSDictionary *dd = [result firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = dd[@"dst"];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = [NSString stringWithFormat:@"翻译出错：%@",error];
        });

    }];

    
}


- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
