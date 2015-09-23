//
//  AddStaffTableViewTwoCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStaffTableViewTwoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *nameField;//姓名

@property (strong, nonatomic) IBOutlet UITextField *ageField;//年龄

@property (strong, nonatomic) IBOutlet UITextField *IDCardField;//身份证

@property (strong, nonatomic) IBOutlet UITextField *addressField;//籍贯

@property (strong, nonatomic) IBOutlet UITextField *telField;//手机号

@property (strong, nonatomic) IBOutlet UITextField *workAge;//从业年限

@property (strong, nonatomic) IBOutlet UILabel *describeLabel;

@property (strong, nonatomic) IBOutlet UITextView *describeTextView;//描述TextView

@property (nonatomic,strong) IBOutlet UIButton *button;
@end
