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
#import "HttpTool.h"
#import "infomationViewController.h"
static NSString *identfider = @"historycell";
static NSString *identfider2 = @"scarchcell";

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
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
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,strong) UILabel *searchlabel;
@property (nonatomic,strong) searchcell *cell;

@property (nonatomic,strong) UIButton *delbtn;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navitionBar.left_btn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    //[self loadDataFromWeb];
    [self.navitionBar.title_label removeFromSuperview];
    [self.navitionBar.right_btn removeFromSuperview];
    [self.view addSubview:self.searchbar];
    [self.view addSubview:self.hisv];
    [self.view addSubview:self.searchlabel];
    [self.view addSubview:self.delbtn];
    self.his_arr = [NSMutableArray array];
    
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    
    NSArray *arr=[defaultes objectForKey:@"history"];
    for(int i=0;i<arr.count;i++){
        [self.his_arr addObject:arr[i]];
    }
    
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
    self.history_tableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,
                                              self.view.frame.size.height-64);
    self.m_label.frame = CGRectMake(0, 65, 150, 20);
    self.hisv.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
    self.searchlabel.frame = CGRectMake(0, 80, self.view.frame.size.width, 40);
    self.delbtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 300, 200, 30);
}

#pragma mark - getters


-(UIButton *)delbtn
{
    if(!_delbtn)
    {
        _delbtn = [[UIButton alloc] init];
        [_delbtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [_delbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_delbtn addTarget:self action:@selector(delesearchhistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delbtn;
}



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
        [_searchbar setShowsCancelButton:NO];//搜索框取消按钮
        
    }
    return _searchbar;
}

-(hisView *)hisv
{
    if(!_hisv)
    {
        _hisv = [[hisView alloc] init];
        [_hisv.del_btn addTarget:self action:@selector(delesearchhistory) forControlEvents:UIControlEventTouchUpInside];
        _hisv.his_tableview.dataSource = self;
        _hisv.his_tableview.delegate = self;
        
    }
    return _hisv;
}

-(UILabel *)searchlabel
{
    if(!_searchlabel)
    {
        _searchlabel = [[UILabel alloc] init];
        [_searchlabel setHidden:YES];
        _searchlabel.text = @"没有找到";
        _searchlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _searchlabel;
}


#pragma mark - UITableViewDateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (a == 1) {
      return self.arr.count;
    }
    else
    {
        if(self.his_arr.count==0){
            return 1;
        }else{
            return self.his_arr.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(a == 1){
        
        self.cell = [tableView dequeueReusableCellWithIdentifier:identfider2];
        self.cell = [[searchcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider2];
        [_cell setCellDate:self.arr[indexPath.row]];
        return _cell;
    
    }
   else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
       
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfider];
            
            if(self.his_arr.count==0){
                cell.textLabel.text = @"暂无历史记录哦";
            }else{
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
    NSLog(@"search = %@",searchBar.text);
    [self.view addSubview:self.history_tableview];
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        
           [self.history_tableview reloadData];
        
    });
    NSString *str=searchBar.text;

    [self.his_arr addObject:str];
    NSLog(@"his_arr = %@",self.his_arr);
    NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
    [defaultes setObject:self.his_arr forKey:@"history"];
    [defaultes synchronize];
//     self.his_arr= [defaultes objectForKey:@"history"];
    NSLog(@"defaults = %@",self.his_arr);
    [self.hisv.his_tableview reloadData];
    
    [self.delbtn setHidden:NO];
    
}

//搜索框内输入信息
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText isEqualToString:@""]){
    
        [_searchbar setShowsCancelButton:YES animated:YES];
        [self.hisv setHidden:YES];
        a=1;
    
        [self.view addSubview:self.history_tableview];
        
        [self.history_tableview reloadData];
        
        NSDictionary *para=@{@"user_nickname":searchText};
        
        [HttpTool postWithparamsWithURL:@"Search/UserSearch" andParam:para success:^(id responseObject) {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dit  = [dic objectForKey:@"data"];
            
            NSString *code = [dic objectForKey:@"code"];
            
            if ([code isEqualToString:@"500"]) {
               
                [self.history_tableview setHidden:YES];
                [self.delbtn setHidden:YES];
                [self.searchlabel setHidden:NO];
            }
            else
            {
            
            hisModel *model = [[hisModel alloc] init];
            self.arr = [NSMutableArray array];
            
            for (int i=0; i<dit.count; i++) {
                
                NSDictionary *aaa=dit[i];
                
                model.name=aaa[@"user_nickname"];
                model.identity=aaa[@"user_identity"];
                model.pic_url=aaa[@"url"];
                model.sigen=aaa[@"user_introduction"];
                model.mobile=aaa[@"user_moblie"];
                
                [self.arr addObject:model];
                
            }
            
            [self.history_tableview reloadData];
            [self.history_tableview setHidden:NO];
            [self.hisv setHidden:YES];
            [self.hisv.his_tableview reloadData];
                
         
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    
    }else{
        a=0;
        [_searchbar setShowsCancelButton:NO animated:YES];
        [self.searchlabel setHidden:YES];
        [self.delbtn setHidden:NO];
        [self.hisv.his_tableview reloadData];
        [self.history_tableview setHidden:YES];
        [self.hisv setHidden:NO];
    }
    
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

//点击取消按钮

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED
{
    _searchbar.text=@"";
    
    a=0;
    [_searchbar setShowsCancelButton:NO animated:YES];
    [self.searchlabel setHidden:YES];
    [self.delbtn setHidden:NO];
    [self.hisv.his_tableview reloadData];
    [self.history_tableview setHidden:YES];
    [self.hisv setHidden:NO];
    
    
    [_searchbar setShowsCancelButton:NO animated:YES];
    NSLog(@"取消按钮");
}

-(UITableView *)history_tableview{
    if(!_history_tableview){
        _history_tableview = [[UITableView alloc] init];
        _history_tableview.delegate=self;
        _history_tableview.dataSource=self;
        _history_tableview.showsVerticalScrollIndicator = NO;
        _history_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _history_tableview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.hisv.his_tableview) {
        self.searchbar.text = self.his_arr[indexPath.row];
        
        [self searchBar:self.searchbar textDidChange:self.his_arr[indexPath.row]];
        
    }
    if (tableView==self.history_tableview) {
        
        NSUserDefaults *defaultes = [NSUserDefaults standardUserDefaults];
        
        [self.his_arr addObject:self.cell.xingming_label.text];
        
        [defaultes setObject:self.his_arr forKey:@"history"];
        [defaultes synchronize];
        
        [self.hisv.his_tableview reloadData];
        
        
        infomationViewController *infoVC = [[infomationViewController alloc] initWithTitle:@"个人信息" isNeedBack:YES btn_image:nil];
        [infoVC getInfo:self.cell.mobolelabel.text];
        
        infoVC.mark=@"TRUE";
        
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

-(void)delesearchhistory
{
    [self.delbtn setHidden:YES];
    [self.hisv setHidden:YES];
    
    //清除历史搜索
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
