//
//  AddStaffViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"
#import "AddPersonModel.h"

@interface AddStaffViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITableView *bgTable;

@property (strong, nonatomic) IBOutlet UIButton *managerTimeBtn;

@property (nonatomic,copy) NSString *shopId;//店铺id

@property (nonatomic,strong) AddPersonModel *personModel;

@property (nonatomic,copy) NSString *tag;

@property (nonatomic,copy) NSString *personID;

//出生年月
@property (nonatomic,strong) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIView *topBottom;

@property (nonatomic,strong) IBOutlet UIButton *sureBtn;

@property (nonatomic,strong) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong) IBOutlet UIDatePicker *datePicker;

- (IBAction)sureClick:(id)sender;

- (IBAction)cancelClick:(id)sender;

- (IBAction)managerTime:(id)sender;

@end
