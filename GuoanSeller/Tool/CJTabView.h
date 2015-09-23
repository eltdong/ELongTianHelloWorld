//
//  CJTabView.h
//  TangRen
//
//  Created by 易龙天 on 15/6/11.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJTabButton.h"

@protocol CJTabViewDelegate <NSObject>

- (void)btnClicked:(NSString *)sort;

@end

@interface CJTabView : UIView<UIScrollViewDelegate>
{
    
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray *_viewArray;                     //主视图的子视图数组
}

@property (nonatomic, assign) id<CJTabViewDelegate>delegate;

@property (nonatomic, retain) UIScrollView   * topScrollView;
@property (nonatomic, retain) UIColor        *tabItemNormalColor;
@property (nonatomic, retain) UIColor        *tabItemSelectedColor;
@property (nonatomic, retain) UIImage        *tabItemNormalBackgroundImage;
@property (nonatomic, retain) UIImage        *tabItemSelectedBackgroundImage;
@property (nonatomic, retain) UIImage        *shadowImage;
@property (nonatomic, retain) NSMutableArray *btnArray;

-(void)tabArrayWithTitle:(NSMutableArray *)titleArray;
@end
