//
//  ShopListCollectionViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//


#import "ShopListCollectionViewCell.h"
@implementation ShopListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setShoplistModel:(ShopListModel *)shoplistModel{
    _shoplistModel =shoplistModel;
    [self.bottomImage setImageWithURL:[NSURL URLWithString:shoplistModel.content_img] placeholderImage:[UIImage imageNamed:CUSTOMPLACEHOLDERIMAGE]];
    self.nameLabel.text = shoplistModel.name;
    [self.topImage setImage:[UIImage  imageNamed:@"mypass"]]; 
    if ([shoplistModel.publish isEqualToString:@"1"]) {
        self.topImage.hidden = YES; 
    }
    else{
        self.topImage.hidden = NO;
    }
}
@end
