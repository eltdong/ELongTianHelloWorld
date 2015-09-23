//
//  BusinessHoursSecTableViewCell.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/11.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "BusinessHoursSecTableViewCell.h"
#import "Const.h"
#import <CoreAudio/CoreAudioTypes.h>
#import "CustomPickerView.h"

@interface BusinessHoursSecTableViewCell ()<CustomPickerViewDelegate>{
    CustomPickerView * cpv;
    NSInteger count;
    UIAlertView * _alertView;
}

@end



@implementation BusinessHoursSecTableViewCell

//-(NSMutableArray *)dataArr{
//    if (!_dataArr) {
//         _dataArr = [[NSMutableArray alloc]init];
//            }
//    return _dataArr;
//}



-(void)setReceived:(NSString *)received{
    _received = received;
    if (received) {
        [[ELTDataArr dataArr].dataArr addObject:received];
//        [self createButton];
        
    }
}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
 
    // Configure the view for the selected state
}

-(void)setSelectedBackgroundView:(UIView *)selectedBackgroundView{
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}
- (void)dataArrRemove:(NSNotification *)not{
    
    if([ELTDataArr dataArr].dataArr.count > 0){
        [ELTDataArr dataArr].dataArr = [NSMutableArray array];
    }
}
- (void)dataArrAdd:(NSNotification *)not{
    if(not.object){
        [ELTDataArr dataArr].dataArr = not.object;
    }
}
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView  
{
    
    if (![ELTDataArr dataArr].dataArr) {
        [ELTDataArr dataArr].dataArr = [[NSMutableArray alloc]init];
    }
    static NSString *ID = @"bhstvc";
    BusinessHoursSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell ) {
        cell = [[BusinessHoursSecTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }else{
        [cell   createButton];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
        [self createButton];
        _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除休假时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
 
    }
    return self;
}
-(void)createButton{
    
    
    self.userInteractionEnabled = YES;
    NSString * text = @"休假时间";
    CGSize leftTopLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREENWIDTH, MAXFLOAT)];
    UILabel * leftTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, leftTopLabelSize.width, leftTopLabelSize.height)];
    leftTopLabel.textColor = UIColorFromRGB(0x666666);
    leftTopLabel.text= @"休假时间";
    leftTopLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:leftTopLabel];
    
    CGSize labelSize = [@"2015年07月25日" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(SCREENWIDTH, MAXFLOAT)];
    
    CGFloat y= 50.f;
    CGFloat x= SCREENWIDTH * 0.5 - labelSize.width / 2;
    NSMutableArray * dataArr = [ELTDataArr dataArr].dataArr;
    for (int i =0; i<dataArr.count; i++) {
      
        if (dataArr.count > 0) {
            UILabel *label  = [[UILabel alloc]init];
            label.userInteractionEnabled = YES;
            label.text = dataArr[i];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorFromRGB(0x666666);
            label.bounds = CGRectMake(0, 0, labelSize.width, labelSize.height);
            
            CGFloat centerX =SCREENWIDTH * 0.5;
            CGFloat centerY = 56.f +i*(labelSize.height +10.f);
            label.center = CGPointMake(centerX, centerY);
            
            [self addSubview:label];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [label addGestureRecognizer:longPress];
            label.tag = i + 10000;
            y =  label.center.y + CGRectGetHeight(label.frame) *0.5  +17.f;
            x = label.frame.origin.x;
        }
    }
    
    
#pragma mark - 添加按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnx = x;
    CGFloat btny = y;
    btn.frame = CGRectMake(btnx, btny ,labelSize.width, 25);
    
    btn.layer.masksToBounds =YES;
    
    [btn setBackgroundImage:[UIImage imageNamed:@"sel_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    self.frame = CGRectMake(0, 0, SCREENWIDTH, CGRectGetMaxY(btn.frame)+22.5);
}
-(void)longPress:(UILongPressGestureRecognizer *)lp{
    lp.view.userInteractionEnabled = NO;
    count = lp.view.tag;
    [_alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableArray * dataArr = [ELTDataArr dataArr].dataArr;
    if (buttonIndex == 0) {
        if(dataArr.count<=1){
            UILabel * label = (UILabel *)[self viewWithTag:count];
            for (int i = 0; i <[ELTDataArr dataArr].dataArr.count ; i ++) {
                
                if ([dataArr[i] isEqualToString:label.text]){
                    //跳转到ViewController请求
                    [self.delegate requestRemoveWithID:i];
                }
                
            }
            [[ELTDataArr dataArr].dataArr removeAllObjects];
        }else{
            UILabel * label = (UILabel *)[self viewWithTag:count];
            for (int i = 0; i <[ELTDataArr dataArr].dataArr.count ; i ++) {
                
                if ([dataArr[i] isEqualToString:label.text]){
                    //跳转到ViewController请求
                    [self.delegate requestRemoveWithID:i];
                }
                
            }
            [[ELTDataArr dataArr].dataArr removeObject:label.text];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)btnClicked:(UIButton *)btn{
    cpv =[CustomPickerView instanceView];
    cpv.tag = 999;
    cpv.delegate = self;
    cpv.frame = self.vc.view.bounds;
    [self.vc.view addSubview:cpv];

}
-(void)getCurrentDate:(NSString *)currentDate{
    [cpv removeFromSuperview];
    BOOL OK = YES;
    for (NSString* str in [ELTDataArr dataArr].dataArr) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",currentDate]]) {
            [self.delegate requestAddWithData:@"重复添加"];
            OK = NO;
        }
    }
    if (OK == YES) {
        
        [self.delegate requestAddWithData:currentDate];
        //    [self.tableView reloadData];
        
    }
}

- (void)cancle{
    [UIView animateWithDuration:1 animations:^{
        [cpv removeFromSuperview];
    }];
}

@end
