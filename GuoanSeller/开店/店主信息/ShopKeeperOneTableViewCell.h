//
//  ShopKeeperOneTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ShopKeeperOneTableViewCellDelegate<NSObject>

-(void)bottomClick:(UIButton *)button;

@end

@interface ShopKeeperOneTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *nameFiled;

@property (strong, nonatomic) IBOutlet UITextField *IDCardField;

@property (strong, nonatomic) IBOutlet UIImageView *imageOne;

@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;

@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic,assign) id <ShopKeeperOneTableViewCellDelegate> delegate;

- (IBAction)bottomPress:(id)sender;

@end
