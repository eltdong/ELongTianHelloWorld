//
//  ELTBuyersCommentsTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/9/15.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTBuyersCommentsTableViewCell.h"

@implementation ELTBuyersCommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReview:(ELTReviewModel *)review{
    _review = review;
    switch ([review.evaluation_value integerValue]) {
        case 1:
        {
            [self.iconImage setImage:[UIImage imageNamed:@"fav"]];
        }
            break;
        case 2:
        {
            [self.iconImage setImage:[UIImage imageNamed:@"favhalf"]];
        }
            break;
        case 3:
        {
            [self.iconImage setImage:[UIImage imageNamed:@"bad"]];
        }
            break;
            
        default:
            break;
    }
    [self.titleLabel setText:review.service_name];
    [self.commentsContent setText:review.evaluation_content];
    [self.usernameLabel setText:review.content_user];
    [self.dataLabel setText:review.create_time];
}
@end
