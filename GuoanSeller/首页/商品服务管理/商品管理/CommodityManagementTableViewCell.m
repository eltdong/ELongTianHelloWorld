//
//  CommodityManagementTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "CommodityManagementTableViewCell.h"
#import "DropDownMenuView.h"
@implementation CommodityManagementTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 选择分类
- (IBAction)classficationBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(secondbtnClicked)]) {
        [self.delegate secondbtnClicked];
    }
}

- (IBAction)selgoBtn:(id)sender {
}
#pragma mark - third
- (IBAction)OffTheShelfBtn:(id)sender {
}
- (IBAction)ReplenishmentBtn:(id)sender {
}
- (IBAction)ForSaleBtm:(id)sender {
}
#pragma mark - fourth
- (IBAction)addtimeBtn:(id)sender {
}
- (IBAction)salesVolume:(id)sender {
}
@end
