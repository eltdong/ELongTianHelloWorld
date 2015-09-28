//
//  CJTabButton.m
//  TangRen
//
//  Created by 易龙天 on 15/6/11.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "CJTabButton.h"

@implementation CJTabButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 31, frame.size.height)];
        _titleL.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _up_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleL.frame.size.width + _titleL.frame.origin.x, frame.size.height / 2 - 9, 10, 10)];
        _down_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleL.frame.size.width + _titleL.frame.origin.x, frame.size.height / 2, 10, 10)];
        
//        _titleL.backgroundColor = [UIColor redColor];
        
        
//        _titleL.translatesAutoresizingMaskIntoConstraints = NO;
//        _up_imgView.translatesAutoresizingMaskIntoConstraints = NO;
//        _down_imgView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_titleL];
        [self addSubview:_up_imgView];
        [self addSubview:_down_imgView];
    
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
