//
//  setCell4.m
//  OralEdu
//
//  Created by 温丹华 on 9/7/16.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setCell4.h"

@implementation setCell4

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.label_bangzhu];
        [self.contentView addSubview:self.image_bangzhu];
        UITableView *tableview;
        tableview.tableFooterView = [[UIView alloc]init];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.frame.size.height;
    CGFloat widht = self.frame.size.width;
    NSLog(@"height = %f,widht = %f",height,widht);
    self.label_bangzhu.frame = CGRectMake(widht *0.3, (height-30)/2, 100, 30);
    self.image_bangzhu.frame = CGRectMake(widht*0.2, (height-20)/2, 50, 20);
}
#pragma mark - getter
-(UIImageView *)image_bangzhu
{
    if (!_image_bangzhu) {
        _image_bangzhu = [[UIImageView alloc]init];
        _image_bangzhu.backgroundColor = [UIColor blueColor];
    }
    return _image_bangzhu;
}
-(UILabel *)label_bangzhu
{
    if (!_label_bangzhu) {
        _label_bangzhu = [[UILabel alloc]init];
        _label_bangzhu.backgroundColor = [UIColor redColor];
    }
    return _label_bangzhu;
}
@end
