//
//  OrderDetailFourCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface OrderDetailFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commodity_name;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *unit_price;

@property (nonatomic,strong)  ProductModel * pModel;
 
@end
