//
//  MessageTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *picImage;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *orderNumLabel;

@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@end
