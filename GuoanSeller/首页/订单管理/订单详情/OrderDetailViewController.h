//
//  OrderDetailViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/5.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *bgTable;
#pragma mark - 订单Id yd
@property (nonatomic,copy) NSString * order_id;
@end
