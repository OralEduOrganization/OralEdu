//
//  pickImageView.m
//  OralEdu
//
//  Created by 刘芮东 on 16/7/4.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "pickImageView.h"
#import "imageCollectionViewCell.h"
#import "Datebase_materallist.h"

@interface pickImageView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *image_collectionview;
@property (nonatomic,strong) NSMutableArray *image_arr;
@property (nonatomic,strong) NSMutableArray *need_arr;

@end

static NSString *collectionview = @"imagecell";

@implementation pickImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.image_arr = [NSMutableArray array];
        [self addTheCollectionView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toReturnDocument:) name:@"returnSelectDocument" object:nil];
        
        
        
    }
    return self;
}

//创建uicollectionview

-(void)addTheCollectionView{
    
    //=======================1===========================
    //创建一个块状表格布局对象
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    //格子的大小 (长，高)
    flowL.itemSize = CGSizeMake(80,80);
    //横向最小距离
    //flowL.minimumInteritemSpacing = 1.f;
    //    flowL.minimumLineSpacing=60.f;//代表的是纵向的空间间隔
    //设置，上／左／下／右 边距 空间间隔数是多少
    //flowL.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //如果有多个 区 就可以拉动
    [flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    //可以左右拉动
    // [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.image_collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-30, self.bounds.size.height) collectionViewLayout:flowL];
    //设置代理为当前控制器
    self.image_collectionview.delegate = self;
    self.image_collectionview.dataSource = self;
    //设置背景
    self.image_collectionview.backgroundColor =[UIColor whiteColor];
    

    [self.image_collectionview registerClass:[imageCollectionViewCell class] forCellWithReuseIdentifier:collectionview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(clickCollectionView:)];
    //    tap.cancelsTouchesInView = NO;
    [self.image_collectionview addGestureRecognizer:tap];
    //添加视图
    [self addSubview:self.image_collectionview];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.image_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionview forIndexPath:indexPath];
    cell.imageview.image = self.image_arr[indexPath.item];
    return cell;
}


#pragma mark - privateMethod

-(void)toReturnDocument:(NSNotification *)notification{
    
    NSString *receiveStr=(NSString *)[notification object];
    
    self.need_arr = [Datebase_materallist readmateraldetailsWithuser_id:@"12136" Name:receiveStr];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for(int i=0;i<self.need_arr.count;i++){
        materal_model *need_model=self.need_arr[i];
        NSString *needPatch=[NSString stringWithFormat:@"%@%@",docDir,need_model.materal_imagepath];
        UIImage *image= [[UIImage alloc]initWithContentsOfFile:needPatch];
        [self.image_arr addObject:image];
    }
    [self.image_collectionview reloadData];
    
    
}
- (void)clickCollectionView:(id)sender
{
    CGPoint pointTouch = [sender locationInView:self.image_collectionview];
    NSIndexPath *indexPath = [self.image_collectionview indexPathForItemAtPoint:pointTouch];
    if (indexPath != nil)
    {
//        [self collectionView:self.image_collectionview didSelectItemAtIndexPath:indexPath];
        NSLog(@"%@",indexPath);
        imageCollectionViewCell *imageCell=[[imageCollectionViewCell alloc]init];
        imageCell=(imageCollectionViewCell *)[self.image_collectionview cellForItemAtIndexPath:indexPath];
        UIImage *image=imageCell.imageview.image;
        NSLog(@"%@",image);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"returnImage" object:image];
    }
    
}
@end
