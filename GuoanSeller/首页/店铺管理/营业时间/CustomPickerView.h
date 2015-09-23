//
//  CustomPickerView.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/11.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate <NSObject>

-(void)getCurrentDate:(NSString *)currentDate;
- (void)cancle;
@end

@interface CustomPickerView : UIView
@property (nonatomic,assign) id<CustomPickerViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;

#pragma mark - 静态方法创建
+(CustomPickerView *)instanceView;
@end
