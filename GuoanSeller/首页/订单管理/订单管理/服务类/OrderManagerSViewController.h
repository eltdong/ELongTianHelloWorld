//
//  OrderManagerSViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderManagerSViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *bgTable;

@property (strong, nonatomic) IBOutlet UIButton *buttonOne;

@property (strong, nonatomic) IBOutlet UIButton *buttonTwo;

@property (strong, nonatomic) IBOutlet UIButton *buttonThree;

@property (strong, nonatomic) IBOutlet UIButton *buttonFour;

@property (strong, nonatomic) IBOutlet UIView *lineView;

- (IBAction)buttonClick:(id)sender;
#pragma mark - 店铺Id
@property (nonatomic,copy) NSString * shop_id; 
@end
