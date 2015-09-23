//
//  OrderDetailThreeCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderDetailThreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *amount;


@property (nonatomic,strong)  OrderModel * oModel;
 
@end
