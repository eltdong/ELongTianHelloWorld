//
//  BusinessHoursTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BusinessHoursTableViewCell.h"

@interface BusinessHoursTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *preViewBtn;


@end

@implementation BusinessHoursTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.preViewBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:YES];
 }




    










- (IBAction)startBtn:(id)sender {
}

- (IBAction)endBtn:(id)sender {
}
#pragma mark - 预览 yd
- (IBAction)previewBtn:(id)sender {
    NSLog(@"sdfsdf");
}

@end
