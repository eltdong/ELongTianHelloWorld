//
//  OrderManagerTwoCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface OrderManagerTwoCell : UITableViewCell
#pragma mark - 参数
@property (weak, nonatomic) IBOutlet UILabel *commodity_name;
@property (weak, nonatomic) IBOutlet UILabel *amount;


#pragma mark - 接受数据
@property (nonatomic,strong)  ProductModel * productModel;
@end
