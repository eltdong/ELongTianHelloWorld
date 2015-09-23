//
//  OrderDetailSViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailSViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *bgTable;

@property (nonatomic,assign) int tag;

@property (nonatomic,copy) NSString * order_id;
@end
