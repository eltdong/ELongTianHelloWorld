//
//  HomeViewCollectionViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "HomeViewCollectionViewCell.h"

@implementation HomeViewCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.masksToBounds =YES;
    self.bgView.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
    self.bgView.layer.borderWidth = 1.0f;
    
    // Here it‘s you dead place
    
}

@end
