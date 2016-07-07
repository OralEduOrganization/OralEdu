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

@interface voiceViewController ()<IFlySpeechRecognizerDelegate>

@property (nonatomic, strong) UIButton   *returnBtn;
@property (nonatomic, strong) UIButton   *voiceBtn;
@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
//@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象

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
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"577ca611",@"20000"];
    
         //所有服务启动前，需要确保执行createUtility
         [IFlySpeechUtility createUtility:initString];
         _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
         _iFlySpeechUnderstander.delegate = self;
    
}
#pragma mark - privateMethod

- (void)startListenning:(id)sender{
   // [self.iflyRecognizerView start];
    
    
    
    NSLog(@"开始识别");
}

-(void)startBtnClick{
//    self.iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
//    self.iflyRecognizerView.delegate = self;
//
//    [self.view addSubview:self.iflyRecognizerView];
//    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//    //asr_audio_path保存录音文件名,默认目录是documents
//    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//    //设置返回的数据格式为默认plain
//    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//    
//
//    [self startListenning:self.iflyRecognizerView];//可以建一个按钮,点击按钮调用此方法
    self.resultLabel.text=@"";
    
    BOOL ret = [_iFlySpeechUnderstander startListening];
    
    if (ret) {

    }else{
//        [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        NSLog(@"oooo");
    }

    
    
}
-(void)cancelBtnClick{
    //[self.iflyRecognizerView cancel];
    [_iFlySpeechUnderstander cancel];
    
    
}
-(void)returnBtnClick{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//返回数据处理
//- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
//{
//    NSMutableString *result = [NSMutableString new];
//    NSDictionary *dic = [resultArray objectAtIndex:0];
//    NSLog(@"DIC:%@",dic);
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    //把相应的控件赋值为result.例如:label.text = result;
//    if(self.resultLabel.text){
//        self.resultLabel.text=[NSString stringWithFormat:@"%@%@",self.resultLabel.text,result];
//    }else{
//        self.resultLabel.text=result;
//    }
//    
//}
-(void)finishBtnClick{
    [_iFlySpeechUnderstander stopListening];
}

- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%@",error);
}

//- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
//{
//    NSMutableString *result = [[NSMutableString alloc] init];
//    NSDictionary *dic = results [0];
//    
//    for (NSString *key in dic) {
//        [result appendFormat:@"%@",key];
//    }
//    
//    NSLog(@"听写结果：%@",result);
//    
//    if(self.resultLabel.text){
//        self.resultLabel.text=[NSString stringWithFormat:@"%@%@",self.resultLabel.text,result];
//    }else{
//        self.resultLabel.text=result;
//    }
//
//}


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
                //self.content.text = str;
            }
        // self.resultLabel.text = str;
     if(self.resultLabel.text){
         self.resultLabel.text=[NSString stringWithFormat:@"%@%@",self.resultLabel.text,str];
     }else{
         self.resultLabel.text=str;
     }

    }



#pragma mark - getters

-(UIButton *)voiceBtn{
    if(!_voiceBtn){
        _voiceBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 100, 50)];
//        [_voiceBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [_voiceBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchDragOutside];
        
        [_voiceBtn setTitle:@"点击录音" forState:UIControlStateNormal];
        _voiceBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _voiceBtn.backgroundColor=[UIColor lightGrayColor];
        [_voiceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    return _voiceBtn;
}
-(UILabel *)resultLabel{
    if(!_resultLabel){
        _resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width, 50)];
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
        [_returnBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchDown];
        
        [_returnBtn setTitle:@"点击返回" forState:UIControlStateNormal];
        _returnBtn.titleLabel.font=[UIFont systemFontOfSize:20];
        _returnBtn.backgroundColor=[UIColor lightGrayColor];
        [_returnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        

    }
    return _returnBtn;
}

@end
