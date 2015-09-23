//
//  MyIncomeViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/4.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

@interface MyIncomeViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic,assign) NSInteger myAccount;

- (IBAction)button:(id)sender;

@end
