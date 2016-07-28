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
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechUnderstander.h"
#import "AFHTTPSessionManager.h"

@interface voiceViewController ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) UIButton   *returnBtn;
@property (nonatomic, strong) UIButton   *voiceBtn;
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;

@property (nonatomic)         BOOL                  isCanceled;
@property (nonatomic,strong) NSString               *result;
@property (nonatomic,strong) NSString               *str_result;
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
    
   
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"577ca611",@"20000"];
    
    [IFlySpeechUtility createUtility:initString];
    _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iFlySpeechUnderstander.delegate = self;
   // [self.view addSubview:self.speakbtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechUnderstander cancel];
    _iFlySpeechUnderstander.delegate = nil;
    //设置回非语义识别
    [_iFlySpeechUnderstander destroy];
    [super viewWillDisappear:animated];
}


#pragma mark - privateMethod

-(void)returnBtnClick{
    
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

//-(void)finishBtnClick{
////    [_iFlySpeechUnderstander stopListening];
//}

#pragma mark - getters

-(UIButton *)voiceBtn{
    if(!_voiceBtn){
        _voiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 50)];

        [_voiceBtn addTarget:self action:@selector(understand) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
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





- (void)understand {
   
    self.resultLabel.text=@"";
         bool ret = [_iFlySpeechUnderstander startListening];  //开始监听
         if (ret) {
                 self.isCanceled = NO;
             }
        else{
                 NSLog(@"启动识别失败!");
             }
     }

- (void)finish
{
        [_iFlySpeechUnderstander stopListening];   //结束监听，并开始识别
        NSLog(@"结束监听，并开始识别");
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

- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        if (_result.length==0) {
            text = @"无识别结果";
        }
        else{
            text = @"识别成功";
        }
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
        self.resultLabel.text = str;
    }
    _result = str;
}


@end
