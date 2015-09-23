
//
//  CustomPickerView.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/11.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "CustomPickerView.h"
#import <Foundation/Foundation.h>
@interface CustomPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end
@implementation CustomPickerView

+(CustomPickerView *)instanceView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CustomPickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // xib 写代码的地方
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    // 设置区域为中国简体中文
    
 
    
    // 设置picker的显示模式：只显示日期
    
//    _datePicker.datePickerMode = UIDatePickerModeDate;
//    10.3UIDatePicker需要监听值的改变
//    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
////    11.UIDatePicker使用教程二。
////    11.1日期范围
//    
////    你可以通过设置mininumDate 和 maxinumDate 属性，来指定使用的日期范围。如果用户试图滚动到超出这一范围的日期，表盘会回滚到最近的有效日期。两个方法都需要NSDate 对象作参数：
//    
//    NSDate* minDate = [[NSDate alloc]initWithString:@"1900-01-01 00:00:00 -0500"];
//    
//    NSDate* maxDate = [[NSDate alloc]initWithString:@"2099-01-01 00:00:00 -0500"];
//    
//    _datePicker.minimumDate = minDate;
//    
//    _datePicker.maximumDate = maxDate;
//    
////    11.2 如果两个日期范围属性中任何一个未被设置，则默认行为将会允许用户选择过去或未来的任意日期。这在某些情况下很有用处，比如，当选择生日时，可以是过去的任意日期，但终止与当前日期。如果你希望设置默认显示的日期，可以使用date属性：
//    
//    _datePicker.date = minDate;
//    
////    11.3 此外，你还可以用 setDate 方法。如果选择了使用动画，则表盘会滚动到你指定的日期：
//    
//    [ _datePicker setDate:maxDate animated:YES];
    
}

- (IBAction)determineBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentDate:)]) {
        NSDate *selected = [self.datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *destDateString = [dateFormatter stringFromDate:selected];
        [self.delegate getCurrentDate:destDateString];
    }
}
- (IBAction)cancelBtn:(id)sender {
    [self.delegate cancle];
}

@end
