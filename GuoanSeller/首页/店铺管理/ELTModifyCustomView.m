//
//  ELTModifyCustomView.m
//  GuoanSeller
//
//  Created by elongtian on 15/9/16.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTModifyCustomView.h"

@implementation ELTModifyCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(ELTModifyCustomView *)instanceView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ELTModifyCustomView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _view.layer.cornerRadius = 5.0;
        _sureBtn.layer.cornerRadius = 5.0;
        _cancelBtn.layer.cornerRadius = 5.0;
    }
    return self;
}

-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _view.layer.cornerRadius = 5.0;
    _sureBtn.layer.cornerRadius = 5.0;
    _cancelBtn.layer.cornerRadius = 5.0;
    
}

- (IBAction)buttonClick:(id)sender {
    
    [self.delegate modifyNameClick:sender];
    
}
@end
