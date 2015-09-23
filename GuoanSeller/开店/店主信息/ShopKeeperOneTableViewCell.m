//
//  ShopKeeperOneTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ShopKeeperOneTableViewCell.h"
#import "ShopMessageViewController.h"

@implementation ShopKeeperOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bottomBtn.layer.cornerRadius = 5.0;
    self.bottomBtn.layer.masksToBounds =YES;
    self.bottomBtn.layer.borderColor = UIColorFromRGB(0xc61f2e).CGColor;
    self.bottomBtn.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bottomPress:(id)sender {
    
    [self.delegate bottomClick:sender];
    NSLog(@"11111111111");
    
}
@end
