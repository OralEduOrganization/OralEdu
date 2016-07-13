//
//  SearchViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/23.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "SearchViewController.h"
#import "hisModel.h"
#import "hisView.h"
#import "searchcell.h"
static NSString *identfider = @"historycell";
static NSString *identfider2 = @"scarchcell";

@interface SearchViewController ()
{
    int a;//1搜索完成
}
@property (nonatomic,strong) UISearchBar *searchbar;
@property (nonatomic,strong) UITableView *history_tableview;
@property (nonatomic,strong) NSMutableArray *his_arr;
@property (nonatomic,strong) UIButton *hid_btn;
@property (nonatomic,strong) UILabel *m_label;
@property (nonatomic,strong) hisView *hisv;
@property (nonatomic,strong) NSMutableArray *array1;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    [self loadDataFromWeb];
    [self.navitionBar.title_label removeFromSuperview];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.hisv];
    [self.hisv.del_btn addTarget:self action:@selector(hidtableview) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchbar.frame = CGRectMake(45, 20, [UIScreen mainScreen].bounds.size.width-45, 35);
    [self.searchbar becomeFirstResponder];
    
    self.hid_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 65, 20, 20);
    self.history_tableview.frame = CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 200);
    self.m_label.frame = CGRectMake(0, 65, 150, 20);
    self.hisv.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
}

#pragma  mark - 数据源方法

-(void)loadDataFromWeb
{
    self.his_arr = [NSMutableArray array];
    hisModel *model = [[hisModel alloc] init];
    model.history_arr = @"123";
    [self.his_arr addObject:model.history_arr];
    hisModel *model2 = [[hisModel alloc] init];
    model2.history_arr = @"456";
    [self.his_arr addObject:model2.history_arr];
}

#pragma mark - getters

-(UISearchBar *)searchbar
{
    if(!_searchbar)
    {
        _searchbar = [[UISearchBar alloc] init];
        _searchbar.delegate = self;
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
        //设置背景图片
        [_searchbar setBackgroundImage:searchBarBg];
        //设置背景色
        [_searchbar setBackgroundColor:[UIColor clearColor]];
        //设置文本框背景
        //[_searchbar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        
    }
    return _searchbar;
}

-(hisView *)hisv
{
    if(!_hisv)
    {
        _hisv = [[hisView alloc] init];
        _hisv.his_tableview.dataSource = self;
        _hisv.his_tableview.delegate = self;
      
    }
    return _hisv;
}

#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (a==1) {
        return 1;
    }
    else
    {
    return self.his_arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(a==1){
        searchcell *cell = [tableView dequeueReusableCellWithIdentifier:identfider2];
        cell = [[searchcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider2];
        return cell;
    
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
            cell.textLabel.text = self.his_arr[indexPath.row];
        }
        
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (a==1) {
        return 200;
    }
    else
    {
        return 44;
    }
}

#pragma mark - 实现方法
-(void)leftbtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    NSLog(@"shouldBeginEditing");
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //点击搜索按钮
    [self.searchbar resignFirstResponder];
    [self.hisv setHidden:YES];
    a=1;
    NSLog(@"123");
    
    [self.view addSubview:self.history_tableview];
    
    
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        
           [self.history_tableview reloadData];
        
    });
    

    [self.hisv.his_tableview reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.hisv setHidden:YES];
}

-(void)keyboardHide
{
    [_searchbar resignFirstResponder];
}

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)hidtableview
{
    NSLog(@"123");
    [self.hisv setHidden:YES];
    [self.hisv removeFromSuperview];
}

-(UITableView *)history_tableview{
    if(!_history_tableview){
        _history_tableview = [[UITableView alloc] init];
        _history_tableview.delegate=self;
        _history_tableview.dataSource=self;
    }
    return _history_tableview;
}
@end
