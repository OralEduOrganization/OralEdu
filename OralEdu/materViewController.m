//
//  materViewController.m
//  OralEdu
//
//  Created by 王俊钢 on 16/6/25.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "materViewController.h"
#import "AppDelegate.h"
#import "materalCell.h"
#import "speaificViewController.h"
#import "DWBubbleMenuButton.h"
#import "NSString+SZYKit.h"
#import "materal_finder.h"
#import "Datebase_materallist.h"
@interface materViewController ()
@property (nonatomic,strong) UITableView *matertableview;
@property (nonatomic,strong) NSMutableArray *mater_arr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UILabel *homelabel;
@property (nonatomic,strong) UIButton *add_btn;
@property (nonatomic,strong) NSString *add_str;

@property (nonatomic,strong) materal_finder *m_finder;
@property (nonatomic,strong) UITableViewCell *cell;
@end

@implementation materViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.matertableview];
    [self.navitionBar.right_btn removeFromSuperview];

    
    self.navitionBar.title_label.text = @"素材库";
    //self.mater_arr = [NSMutableArray arrayWithObjects:@"1",@"2" ,@"3",@"4",nil];
    self.mater_arr = [NSMutableArray array];
    [self.view addSubview:self.add_btn];
    
    _m_finder = [[materal_finder alloc] init];
    
    NSMutableArray *listArr = [NSMutableArray array];
    listArr  =  [Datebase_materallist readmaderallist];
    
    for (int i=0; i<listArr.count; i++) {
        materal_finder *arr=listArr[i];
        [_mater_arr addObject:arr.materal_finder_name];
    }
    
    
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.matertableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    self.add_btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-100, 50, 50);
    
}
#pragma mark - getters

-(UIButton *)add_btn
{
    if(!_add_btn)
    {
        _add_btn = [[UIButton alloc] init];
        _add_btn.backgroundColor = [UIColor grayColor];
        [_add_btn setTitle:@"add" forState:UIControlStateNormal];
        [_add_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _add_btn.layer.masksToBounds = YES;
        _add_btn.layer.cornerRadius = 25;
        [_add_btn addTarget:self action:@selector(addanew) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add_btn;
}

-(UITableView *)matertableview
{
    if(!_matertableview)
    {
        _matertableview = [[UITableView alloc] init];
        _matertableview.delegate = self;
        _matertableview.dataSource = self;
        _matertableview.backgroundColor = [UIColor orangeColor];
        
    }
    return _matertableview;
}

#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mater_arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfider = @"materalCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identfider];
    
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfider];
    _cell.textLabel.text = self.mater_arr[indexPath.row];
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
    
    speaificViewController *specVC = [[speaificViewController alloc] initWithTitle:self.mater_arr[indexPath.row] isNeedBack:YES btn_image:nil];
    [self.navigationController pushViewController:specVC animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        
        // 1. 更新数据
        self.cell=[self.matertableview cellForRowAtIndexPath:indexPath];
       // NSString *aaa=self.cell.textLabel.text;
        [Datebase_materallist deletematerallist:self.cell.textLabel.text];
        
        [self deleteFileWithObjetName:self.cell.textLabel.text];
        
        [_mater_arr removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    // 删除一个置顶按钮
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了置顶");
        // 1. 更新数据
        
        [_mater_arr exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        
        // 2. 更新UI
        
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
    }];
    
    topRowAction.backgroundColor = [UIColor blueColor];
    
    // 添加一个更多按钮
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        NSLog(@"点击了重命名");
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"重命名" message:@"重新命名课程名字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
       // UITextField *renameTextField = [[UITextField alloc]init];
        
        [control addTextFieldWithConfigurationHandler:^(UITextField *textField) {
           
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
              [_mater_arr replaceObjectAtIndex:indexPath.row withObject:self.str];//指定索引修改
            [self.matertableview reloadData];
            
        }];
        
        [control addAction:action1];
        [control addAction:action2];
        
        [self presentViewController:control animated:YES completion:nil];
        
       
        
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 将设置好的按钮放到数组中返回
    
    return @[deleteRowAction, topRowAction, moreRowAction];
    
    //return @[deleteRowAction,moreRowAction];
    
}

#pragma mark - 实现方法

-(void)leftbtnClick
{
    [self presentLeftMenuViewController];
}

- (void) presentLeftMenuViewController{
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    self.str=textField.text;
}

//添加文件夹分类
-(void)addanew
{
    NSLog(@"沙盒路径：%@",NSHomeDirectory());
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加" message:@"请输入分类名" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:UITextFieldTextDidChangeNotification object:nil];
        [self.mater_arr addObject:self.add_str];
        [self.matertableview reloadData];
        //新建文件夹
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/%@/%@", pathDocuments,@"12136",self.add_str];
        NSLog(@"str = %@",self.add_str);
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            
        } else {
            NSLog(@"FileDir is exists.");
            
        }
        _m_finder.materal_finder_id = @"33";
        _m_finder.materal_finder_name = self.add_str;

        [Datebase_materallist savematerallist:_m_finder];

    }]; 

    [control addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification2:) name:UITextFieldTextDidChangeNotification object:textField];
        
     
    }];

    [control addAction:action1];
    [control addAction:action2];
    [self presentViewController:control animated:YES completion:nil];
    
    
    
}

- (void)handleTextFieldTextDidChangeNotification2:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSLog(@"%@",textField.text);
    self.add_str=textField.text;
}

//销毁观察者模式
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)deleteFileWithObjetName:(NSString *)name {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}
@end
