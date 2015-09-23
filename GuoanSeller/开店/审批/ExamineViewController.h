//
//  ExamineViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopManagementViewController.h"
@interface ExamineViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *bottomClick;
@property (nonatomic, strong) NSString * shop_id;
@property (strong, nonatomic) IBOutlet UILabel *date;



- (IBAction)bottomClick:(id)sender;
@end
