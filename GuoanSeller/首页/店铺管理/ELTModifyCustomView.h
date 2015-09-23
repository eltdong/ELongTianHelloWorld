//
//  ELTModifyCustomView.h
//  GuoanSeller
//
//  Created by elongtian on 15/9/16.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELTModifyCustomViewDelegate <NSObject>

-(void)modifyNameClick:(UIButton *)button;

@end

@interface ELTModifyCustomView : UIView

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@property (nonatomic,strong) IBOutlet UIView *view;

@property (nonatomic,strong) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong) IBOutlet UIButton *sureBtn;

@property (nonatomic,weak) id<ELTModifyCustomViewDelegate>delegate;

- (IBAction)buttonClick:(id)sender;

+(ELTModifyCustomView *)instanceView;

@end
