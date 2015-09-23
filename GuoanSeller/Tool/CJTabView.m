//
//  CJTabView.m
//  TangRen
//
//  Created by 易龙天 on 15/6/11.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "CJTabView.h"
#import "Const.h"
#define SCREENWIDTH      CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT      CGRectGetHeight([UIScreen mainScreen].bounds)
#define TAG 1000
@implementation CJTabView
BOOL isRed_Black = YES;
NSInteger tag = TAG;
static const CGFloat kHeightOfTopScrollView = 44.0f;
CGFloat kWidthOfTopScrollView = 16.0f;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        kWidthOfTopScrollView = frame.size.width;
        [self initValues];
    }
    return self;
}
#pragma mark - 初始化参数

- (void)initValues
{
    isRed_Black = YES;
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidthOfTopScrollView, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topScrollView];
    
}
-(void)tabArrayWithTitle:(NSMutableArray *)titleArray{
    NSInteger count = titleArray.count;
    CGFloat width = kWidthOfTopScrollView / count;
    for (int i = 0; i < count; i++) {
        CJTabButton *btn = [[CJTabButton alloc]initWithFrame:CGRectMake(width*i, 0, width, self.frame.size.height)];
//        btn.frame = CGRectMake(width*i, 0, width, 49);
        btn.tag = TAG + i;
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleL.font = [UIFont boldSystemFontOfSize:15.0f];
        btn.titleL.textColor = UIColorFromRGB(0x999999);
        //btn.up_imgView.image = [UIImage imageNamed:@"up_black"];
        //btn.down_imgView.image = [UIImage imageNamed:@"down_black"];
        if(i == 0){
            //btn.down_imgView.image = [UIImage imageNamed:@"down_red"];
            btn.titleL.textColor = UIColorFromRGB(0xff0102);
        }
        btn.titleL.text = titleArray[i];
        
        [_topScrollView addSubview:btn];
    }
}
- (void)btnClicked:(CJTabButton *)sender{

    if (tag == sender.tag) {
        isRed_Black = !isRed_Black;
        if (isRed_Black == NO) {
            //sender.up_imgView.image = [UIImage imageNamed:@"up_red"];
            //sender.down_imgView.image = [UIImage imageNamed:@"down_black"];
            if (sender.tag == TAG) {
                
                [self.delegate btnClicked:@"3"];
                
            }else if (sender.tag == TAG + 1){
                
                [self.delegate btnClicked:@"1"];
                
            }else{
                
                [self.delegate btnClicked:@"5"];
                
            }
        }else{
            //sender.up_imgView.image = [UIImage imageNamed:@"up_black"];
            //sender.down_imgView.image = [UIImage imageNamed:@"down_red"];
            if (sender.tag == TAG) {
                
                [self.delegate btnClicked:@"4"];
                
            }else if (sender.tag == TAG + 1){
                
                [self.delegate btnClicked:@"2"];
                
            }else{
                
                [self.delegate btnClicked:@"6"];
                
            }
        }
        
        
        
    }else{
        isRed_Black = YES;
        CJTabButton * btn = (CJTabButton *)[_topScrollView viewWithTag:tag];
        btn.titleL.textColor = UIColorFromRGB(0x999999);
        //btn.up_imgView.image = [UIImage imageNamed:@"up_black"];
        //btn.down_imgView.image = [UIImage imageNamed:@"down_black"];
        
        sender.titleL.textColor = UIColorFromRGB(0xff0102);
        tag = sender.tag;
        //sender.up_imgView.image = [UIImage imageNamed:@"up_black"];
        //sender.down_imgView.image = [UIImage imageNamed:@"down_red"];
        if (sender.tag == TAG) {
            
            [self.delegate btnClicked:@"4"];
            
        }else if (sender.tag == TAG + 1){
            
            [self.delegate btnClicked:@"2"];
            
        }else{
            
            [self.delegate btnClicked:@"6"];
            
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
