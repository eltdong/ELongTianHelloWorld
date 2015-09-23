//
//  BusinessHoursSecTableViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/11.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BusinessHoursSecDeleagate <NSObject>

-(void)addBtn;
- (void)requestRemoveWithID:(NSInteger)ID;

- (void)requestAddWithData:(NSString *)data;
@end



@interface BusinessHoursSecTableViewCell : UITableViewCell
@property (nonatomic,assign) id<BusinessHoursSecDeleagate>delegate;

#pragma mark - 初始化cell
@property (nonatomic,weak) UIViewController * vc;
@property (nonatomic,weak) UITableView * tableView; 
+ (instancetype)cellWithTableView:(UITableView *)tableView  ;

//@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSString * received;

@end
