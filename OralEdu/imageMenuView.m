//
//  imageMenuView.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/5.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "imageMenuView.h"
#import "Datebase_materallist.h"


@interface imageMenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *matertableview;
@property (nonatomic,strong) UITableViewCell *cell;

@end

@implementation imageMenuView{
    NSMutableArray *dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr=[NSMutableArray array];;
        self.backgroundColor=[UIColor whiteColor];
        NSMutableArray *listArr = [NSMutableArray array];
        listArr  =  [Datebase_materallist readmaderallist];
        for (int i=0; i<listArr.count; i++) {
            materal_finder *receiveModel=listArr[i];
            NSLog(@"%@",receiveModel.materal_finder_name);
            [dataArr addObject:receiveModel.materal_finder_name];
        }
        [self addSubview:self.matertableview];

        [self.matertableview reloadData];
    }
    return self;
}


#pragma mark - UITableViewDateSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfider = @"materalCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identfider];
    
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfider];
    _cell.textLabel.text = dataArr[indexPath.row];
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *select=dataArr[indexPath.row];
    NSLog(@"点击%@",select);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"returnSelectDocument" object:select];
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableView *)matertableview
{
    if(!_matertableview)
    {
        _matertableview = [[UITableView alloc] initWithFrame:self.bounds];
        _matertableview.delegate = self;
        _matertableview.dataSource = self;
        //_matertableview.backgroundColor = [UIColor orangeColor];
        _matertableview.backgroundColor = [UIColor whiteColor];
    }
    return _matertableview;
}


@end
