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
@interface materViewController ()
@property (nonatomic,strong) UITableView *matertableview;
@property (nonatomic,strong) NSMutableArray *mater_arr;
@property (nonatomic,strong) NSString *str;
@property (nonatomic,strong) UILabel *homelabel;
@property (nonatomic,strong) DWBubbleMenuButton* upMenuView;
@end

@implementation materViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navitionBar.left_btn setTitle:@"返回" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.matertableview];
    [self.navitionBar.right_btn removeFromSuperview];
    self.navitionBar.title_label.text = @"素材库";
    self.mater_arr = [NSMutableArray arrayWithObjects:@"1",@"2" ,@"3",@"4",nil];
    
    self.homelabel = [self createHomeButtonView];
    
    [self.view addSubview:self.upMenuView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.matertableview.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    
}
#pragma mark - getters

-(DWBubbleMenuButton *)upMenuView
{
    if(!_upMenuView)
    {
        _upMenuView = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.homelabel.frame.size.width - 20.f,
                                                                           self.view.frame.size.height - self.homelabel.frame.size.height - 20.f,
                                                                           self.homelabel.frame.size.width,
                                                                           self.homelabel.frame.size.height) expansionDirection:DirectionUp];
        
    }
    _upMenuView.homeButtonView = self.homelabel;
    [_upMenuView addButtons:[self createDemoButtonArray]];

    return _upMenuView;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfider];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfider];
    cell.textLabel.text = self.mater_arr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
    speaificViewController *specVC = [[speaificViewController alloc] initWithTitle:@"详细"isNeedBack:YES btn_image:nil];
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
            // 可以在这里对textfield进行定制，例如改变背景色
            //textField.backgroundColor = [UIColor orangeColor];
            //self.str = [[NSString alloc] init];
           // self.str = textField.text;
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

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    self.str=textField.text;
   // NSLog(@"%@",textField.text);
    // Enforce a minimum length of >= 5 characters for secure text alerts.
    //self.secureTextAlertAction.enabled = textField.text.length >= 5;
}

#pragma mark - 悬浮按钮方法 
- (UILabel *)createHomeButtonView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C", @"D", @"E"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}

- (void)test:(UIButton *)sender {
    if (sender.tag == 0) {
        NSLog(@"0");
    }
    if (sender.tag == 1) {
        NSLog(@"1");
    }
    if (sender.tag == 2) {
        NSLog(@"2");
    }
    if(sender.tag == 3)
    {
        NSLog(@"2333");
    }
    if (sender.tag == 4) {
        NSLog(@"444");
    }
}

- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (BOOL)prefersStatusBarHidden {
    return true;
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
@end
