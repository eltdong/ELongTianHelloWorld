//
//  OrderDetailSTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "ServiceModel.h"
@interface OrderDetailSTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *personTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *personLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *discountLabel;

@property (strong, nonatomic) IBOutlet UILabel *payLabel;

@property (nonatomic,strong)  OrderModel * orderModel;
@property (nonatomic,strong)  ServiceModel * serviceModel;


@end
