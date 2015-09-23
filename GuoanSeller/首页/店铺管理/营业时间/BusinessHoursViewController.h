//
//  BusinessHoursViewController.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^myBlock)(NSMutableArray * time,NSMutableArray * date);
@interface BusinessHoursViewController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView_one;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView_two;

@property (strong, nonatomic) IBOutlet UIView *pickerView_bjView;
@property (nonatomic, strong) NSMutableArray * dataTimeArr;
@property (nonatomic, strong) NSMutableArray * cellArr;

@property (nonatomic, copy) NSString * shoppe_id;

@property (nonatomic, copy) myBlock block;

@property (nonatomic, assign) BOOL isEdit;
@end
