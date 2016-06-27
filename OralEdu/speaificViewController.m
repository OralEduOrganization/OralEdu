//
//  speaificViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "speaificViewController.h"
#import "CocoaPickerViewController.h"
@interface speaificViewController ()<CocoaPickerViewControllerDelegate>
@property(nonatomic,strong) UIImageView *showImageView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIButton *btn;
@end

@implementation speaificViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.right_btn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
    
//
//    UIImageView *imageView =[[ UIImageView  alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
//    
//    imageView.frame = self.view.bounds;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];

    
    
    [self.view addSubview:self.btn];
    [self.view addSubview:self.scrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 200);
}

#pragma mark - getters

-(UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _btn.bounds = CGRectMake(0, 0, 90, 90);
        _btn.backgroundColor = [UIColor colorWithRed:211/255.0 green:44/255.0 blue:37/255.0 alpha:1];
        _btn.tintColor = [UIColor whiteColor];
        _btn.layer.cornerRadius = 45;
        _btn.clipsToBounds = YES;
        _btn.layer.masksToBounds = NO;
        _btn.layer.shadowColor = [UIColor blackColor].CGColor;
        _btn.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
        _btn.layer.shadowOpacity = 0.5f;
        _btn.center = CGPointMake(self.view.bounds.size.width/2.0, CGRectGetHeight(self.view.bounds) - 100);
        [_btn setTitleColor:[UIColor redColor] forState:normal];
        [_btn addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchUpInside];
        [_btn addTarget:self action:@selector(touchDownAnamation:) forControlEvents:UIControlEventTouchDown];
    }
    return _btn;
}

-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
         _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(0, 0);
        
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.layer.shadowColor = [UIColor blackColor].CGColor;
        _scrollView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
        _scrollView.layer.shadowOpacity = 0.5f;
    }
    return _scrollView;
}



#pragma mark - 弹出图片选择器

- (void)present:(UIButton*)button {
    
    button.bounds = CGRectMake(0, 0, 90, 90);
    [UIView animateWithDuration:0.25 animations:^{
        button.layer.cornerRadius = 45;
        
    }completion:^(BOOL finished) {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明
        CocoaPickerViewController *transparentView = [[CocoaPickerViewController alloc] init];
        transparentView.delegate = self;
        transparentView.modalPresentationStyle = UIModalPresentationOverFullScreen;
        transparentView.view.frame=self.view.frame;
        //        transparentView.view.superview.backgroundColor = [UIColor clearColor];
        [self presentViewController:transparentView animated:YES completion:nil];
    }];
    
    
    
}

//你所选择的图片
#pragma mark 图片将传到这里 根据自己的需求处理
- (void)CocoaPickerViewSendBackWithImage:(NSArray *)imageArray andString:(NSString *)str{
    NSLog(@"收到 :%@",str);
    
    for (UIImage *image  in imageArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        float image_W = image.size.width/(image.size.height / _scrollView.bounds.size.height);
        imageView.bounds = CGRectMake(0, 0, image_W, 200);
        imageView.frame = CGRectMake(_scrollView.contentSize.width, 0, image_W, _scrollView.bounds.size.height);
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width + image_W, _scrollView.bounds.size.height);
        [_scrollView addSubview:imageView];
    }
    
    //    调整  contentOffset
    if (_scrollView.contentSize.width > self.view.bounds.size.width) {
        [UIView  animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width - self.view.bounds.size.width, 0);
        }];
    }
}


- (void)touchDownAnamation:(UIButton* )button{
    button.bounds = CGRectMake(0, 0, 100, 100);
    
    [UIView animateWithDuration:0.25 animations:^{
        button.layer.cornerRadius = 50;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
