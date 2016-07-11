//
//  setCell5.m
//  OralEdu
//
//  Created by 温丹华 on 9/7/16.
//  Copyright © 2016年 wangjungang. All rights reserved.
//

#import "setCell5.h"

@implementation setCell5

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
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.image_qingli];
        [self.contentView addSubview:self.label_qingli];
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
    self.label_qingli.frame = CGRectMake(widht *0.3, (height-20)/2, 80, 20);
    self.image_qingli.frame = CGRectMake(widht*0.2, (height-20)/2, 20, 20);
}
#pragma mark - getter
-(UIImageView *)image_qingli
{
    if (!_image_qingli) {
        _image_qingli = [[UIImageView alloc]init];
    }
    return _image_qingli;
}
-(UILabel *)label_qingli
{
    if (!_label_qingli) {
        _label_qingli = [[UILabel alloc]init];
    }
    return _label_qingli;
}
@end
