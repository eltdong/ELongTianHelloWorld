//
//  DropDownMenuView.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#define FIRSTCELLHEIGHT 42.5F
#define SECONDCELLHEIGHT 36.F
#define ADDTIONALCELLHEIGHT 25.F
#import <UIKit/UIKit.h>

typedef enum {
    
    DropDownMenuViewDefault,//默认，
    
    DropDownMenuViewRemoveAll//登录，注册，订单提交，背景透明
    
}DropDownMenuViewType;

@protocol DropDownMenuViewDelegate <NSObject>
@optional
-(void)didSelectRowAtIndexPathWithText:(NSString *)text andAuto_code:(NSString *)auto_code;

@end
typedef void(^heightBlock)(CGFloat  height);//下拉菜单高度
typedef void(^currentBtn)(BOOL  isDrop);
typedef void(^selecteValue)(NSString * text);

@interface DropDownMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,copy) NSString *isClicked;
#pragma mark - 静态方法创建
+(DropDownMenuView *)instanceView:(NSMutableArray *)dataArr;
- (DropDownMenuView *)instanceCustomView:(NSMutableArray *)dataArr;
@property (nonatomic,assign) id<DropDownMenuViewDelegate>delegate;
#pragma mark - tableview距离最上面的距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

#pragma mark - boloc yd
@property (nonatomic,strong)  NSMutableArray * dataArr;

@property (nonatomic,copy) heightBlock block;
@property (nonatomic,copy) currentBtn currentBtnblock; @property (nonatomic,assign) DropDownMenuViewType  dropDownMenuViewType;//居然用assign修饰

@property (nonatomic,assign) NSInteger allRows;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;//高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewLeftConstraint;// 左侧约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewRightConstraint; //右侧约束
@end
