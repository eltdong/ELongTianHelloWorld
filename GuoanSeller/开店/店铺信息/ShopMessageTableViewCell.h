//
//  ShopMessageTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopMessageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UITextField *detailTextfield;

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
