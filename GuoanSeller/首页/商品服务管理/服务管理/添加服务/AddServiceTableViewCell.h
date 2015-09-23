//
//  AddServiceTableViewCell.h
//  GuoanSeller
//
//  Created by 易龙天 on 15/9/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddServiceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *format;

@end
