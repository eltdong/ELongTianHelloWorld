//
//  BusinessHoursTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BusinessHoursTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *weekName;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UIButton *endBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;


- (IBAction)previewBtn:(id)sender;

- (IBAction)chooseBtn:(id)sender;
@end
