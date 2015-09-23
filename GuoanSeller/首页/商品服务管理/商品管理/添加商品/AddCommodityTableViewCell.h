//
//  AddCommodityTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityListModel.h"
@class AddCommodityTableViewCell;
@protocol AddCommodityTableViewCellDelegate <NSObject>

@optional
-(void)pullDownBtnClick:(UIButton *)button;
-(void)getCustomParadic:(NSMutableDictionary *)paraDic;
-(void)onShelfCommodityBtn;
-(void)textViewDidEndEditing;

@end

typedef void (^getParaDic) (id objc); 
@interface AddCommodityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *longpressAlertLabel;

@property (strong, nonatomic) IBOutlet UIImageView *addPicImage;
@property (strong, nonatomic) IBOutlet UICollectionView *cell_collectionView;
@property (strong, nonatomic) IBOutlet UIView *cell_bjView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (nonatomic,strong) IBOutlet UIButton *pullDownBtn;

@property (nonatomic,strong) IBOutlet UITextField *inputField;

@property (nonatomic,assign) id<AddCommodityTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

- (IBAction)pullDownClick:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,strong)  CommodityListModel * clModel;

@property (weak, nonatomic) IBOutlet UIButton *onShelfCommodityBtn;
- (IBAction)onShelfCommodityBtn:(id)sender;






@end
