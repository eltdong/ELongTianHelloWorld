//
//  ELTBuyersCommentsTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELTReviewModel.h"
@interface ELTBuyersCommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsContent;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;


@property (nonatomic,copy) NSString * content;
@property (nonatomic,assign) NSInteger cellHeight;//动态高度
@property (nonatomic,strong) ELTReviewModel * review;
@end
