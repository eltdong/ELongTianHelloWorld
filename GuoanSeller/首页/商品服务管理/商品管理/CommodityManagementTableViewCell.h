//
//  CommodityManagementTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol commodityManagementDelelgate <NSObject>
@optional
-(void)secondbtnClicked;

@end


@interface CommodityManagementTableViewCell : UITableViewCell

#pragma mark - second yd
@property (weak, nonatomic) IBOutlet UIButton *classficationBtn;
- (IBAction)classficationBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selgoBtn;
- (IBAction)selgoBtn:(id)sender;

#pragma mark - third yd
@property (weak, nonatomic) IBOutlet UIButton *OffTheShelfBtn;
- (IBAction)OffTheShelfBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ReplenishmentBtn;
- (IBAction)ReplenishmentBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ForSaleBtn;
- (IBAction)ForSaleBtm:(id)sender;
#pragma mark - fourth yd
@property (weak, nonatomic) IBOutlet UIButton *addTimeBtn;
- (IBAction)addtimeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIButton *salesVolume;
- (IBAction)salesVolume:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sort2Btn;


@property (nonatomic,assign) id<commodityManagementDelelgate>delegate;

@end
