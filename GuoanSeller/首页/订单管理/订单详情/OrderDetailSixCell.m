//
//  OrderDetailSixCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/10.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "OrderDetailSixCell.h"

@interface OrderDetailSixCell ()<UIActionSheetDelegate>

@end

@implementation OrderDetailSixCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.customerServiceHotline addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)tap{
    NSString *tel = @"工作时间：每天9:00 - 18:00";
    UIActionSheet *phoneSheet = [[UIActionSheet alloc] initWithTitle:tel delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫400-677-6280" otherButtonTitles:nil];
    [phoneSheet showInView:self.vc.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0){
        
        [[UIApplication sharedApplication] openURL:
         [ NSURL URLWithString:@"tel://400-677-6280"]];
    }
}

@end
