//
//  OrderDetailFiveCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailFiveCell : UITableViewCell
@property (nonatomic,strong)  OrderModel * oModel;

@property (weak, nonatomic) IBOutlet UILabel *total_priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *freight;
@property (weak, nonatomic) IBOutlet UILabel *coupon_id;
@property (weak, nonatomic) IBOutlet UILabel *amount;
 
@end
