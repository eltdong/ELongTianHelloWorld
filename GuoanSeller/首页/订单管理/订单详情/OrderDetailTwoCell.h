//
//  OrderDetailTwoCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customer_id;
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *consigneeName;

@property (weak, nonatomic) IBOutlet UILabel *consignee_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *evaluation_comment;


@property (nonatomic,strong)  OrderModel * oModel;

@end
