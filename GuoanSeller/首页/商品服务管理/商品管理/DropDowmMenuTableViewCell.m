//
//  DropDowmMenuTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "DropDowmMenuTableViewCell.h"

@implementation DropDowmMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}
-(void)setCModel:(ClassificationModel *)cModel{
    _cModel = cModel;
    [self.mainClassLabel setText:cModel.modules_name];
//    operty (nonatomic,copy) NSString * modules_name;//酒类
//    @property (nonatomic,copy) NSString * auto_code;//1000
//    @property (nonatomic,strong)  NSMutableArray * sub;
}
-(void)setCsModel:(ClassificationSecModel *)csModel{
    _csModel = csModel;
    [self.smallClassLabel setText:csModel.modules_name];
}
@end
