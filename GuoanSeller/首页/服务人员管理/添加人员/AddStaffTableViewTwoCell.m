//
//  AddStaffTableViewTwoCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "AddStaffTableViewTwoCell.h"

@interface AddStaffTableViewTwoCell()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation AddStaffTableViewTwoCell

- (void)awakeFromNib {
    // Initialization code
    self.describeTextView.delegate = self;
    _IDCardField.delegate = self;
    [_ageField setKeyboardType:UIKeyboardTypeNumberPad];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([textView.text length] == 0) {
        _describeLabel.hidden = NO;
    }
    else
    {
        _describeLabel.hidden = YES;
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger length = textField.text.length;
    if (length >= 18 && string.length >0)
    {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
