//
//  DropDownMenuView.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//


#define FIRSTCELLHEIGHT 42.5F
#define SECONDCELLHEIGHT 36.F
#define ADDTIONALCELLHEIGHT 25.F

#import "DropDownMenuView.h"
#import "DropDowmMenuTableViewCell.h"

#import "ClassificationModel.h"
#import "ClassificationSecModel.h"
@interface DropDownMenuView ()


@property (nonatomic,assign) NSInteger selectedSection;
@property (nonatomic,strong) NSMutableArray * statusArr;
@end

@implementation DropDownMenuView
-(NSArray *)statusArr{
    if (!_statusArr) {
        _statusArr = [NSMutableArray array];
        for (int i =0; i<self.dataArr.count; i++) {
            [_statusArr  addObject:@"1"];
        }
    }
    return _statusArr;
}
-(NSInteger)selectedSection{
    if (!_selectedSection) {
        _selectedSection = -1;
    }
    return _selectedSection;
}

+(DropDownMenuView *)instanceView:(NSMutableArray *)dataArr1{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DropDownMenuView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}



- (DropDownMenuView *)instanceCustomView:(NSMutableArray *)dataArr{
    self.dataArr = dataArr;
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DropDownMenuView" owner:nil options:nil];
      return [nibView objectAtIndex:0];
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if (self.dropDownMenuViewType == DropDownMenuViewDefault) {
        
        CGFloat tableviewHeight =  SECONDCELLHEIGHT * (dataArr.count + 1) + FIRSTCELLHEIGHT;
        self.tableViewHeightConstraint.constant = tableviewHeight;
    }else{
        CGFloat tableviewHeight = ADDTIONALCELLHEIGHT *  dataArr.count; 
        CGFloat realHeight = CGRectGetHeight(self.bounds) - self.topConstraint.constant;
        if (tableviewHeight > realHeight) {
            self.tableViewHeightConstraint.constant = realHeight;
        }
        else{
            self.tableViewHeightConstraint.constant = tableviewHeight;
        }

        
        self.tableView.layer.masksToBounds = YES;
        self.tableView.layer.borderColor =UIColorFromRGB(0xf1f1f1).CGColor;
        self.tableView.layer.borderWidth = 1.f;
        self.tableView.layer.cornerRadius = 2.5f;
        
        self.backgroundColor = [UIColor clearColor];
    }
    self.allRows = dataArr.count;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // xib 写代码的地方
    }
    return self;
}
-(void)awakeFromNib{
   
    
    [self createUI];
    
}

-(void)createUI{
    self.isSelected = NO;
    self.isClicked = @"1";
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArr.count!=0) {
        return (self.dropDownMenuViewType == DropDownMenuViewRemoveAll)? self.dataArr.count:self.dataArr.count + 2;
    }else{
        return (self.dropDownMenuViewType == DropDownMenuViewRemoveAll)? 0:2;
    } 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dropDownMenuViewType == DropDownMenuViewRemoveAll) {
        if ([self.statusArr[section] isEqualToString:@"1"]) {
            return 1;
        }
        else{
            ClassificationModel* cModel = self.dataArr[ section];
            return cModel.sub.count+1;
        }
    }else{
        if (section ==0 || section == 1) {
            return 1;
        }
        else{
            if ([self.statusArr[section-2] isEqualToString:@"1"]) {
                return 1;
            }
            else{
                ClassificationModel* cModel = self.dataArr[ section-2];
                return cModel.sub.count+1;
            }
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dropDownMenuViewType == DropDownMenuViewRemoveAll) {
     
                switch (indexPath.row) {
                    case 0:
                    {
                        DropDowmMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"classification_large"];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:self options:nil] objectAtIndex:1];
                        }
                        if (self.dataArr) {
                            ClassificationModel* cModel = self.dataArr[indexPath.section];
                            cell.cModel = cModel;
                        }
                        if ([self.statusArr[indexPath.section] isEqualToString:@"0"]) {
                            [cell.selbfBtn setImage:[UIImage imageNamed:@"selbg2"] forState:UIControlStateNormal];
                        }else{
                            [cell.selbfBtn setImage:[UIImage imageNamed:@"bigarrow2"] forState:UIControlStateNormal];
                        }
                        
                        
                        cell.mainUnderline.hidden = YES;
                        cell.selbfBtn.hidden = YES;
                        cell.tag = indexPath.section +100;
                        return cell;
                    }
                        break;
                    default:
                    {
                        DropDowmMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"classification_small"];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:self options:nil] objectAtIndex:2];
                        }
                        if (self.dataArr) {
                            ClassificationModel* cModel = self.dataArr[indexPath.section];
                            ClassificationSecModel * csModel = cModel.sub[indexPath.row -1];
                            cell.csModel = csModel;
                        }
                        return cell;
                    }
                        // 第一次展现出来的cell无法复用
                        break;
                }
      

    }else{
        switch (indexPath.section) {
            case 0:
            {
                DropDowmMenuTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:nil options:nil] objectAtIndex:3];
                return cell;
            }
                break;
            case 1:
            {
                DropDowmMenuTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:nil options:nil] objectAtIndex:0];
                return cell;
            }
                break;
            default:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        DropDowmMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"classification_large"];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:self options:nil] objectAtIndex:1];
                        }
                        if (self.dataArr) {
                            ClassificationModel* cModel = self.dataArr[indexPath.section-2];
                            cell.cModel = cModel;
                        }
                        if ([self.statusArr[indexPath.section-2] isEqualToString:@"0"]) {
                            [cell.selbfBtn setImage:[UIImage imageNamed:@"selbg2"] forState:UIControlStateNormal];
                        }else{
                            [cell.selbfBtn setImage:[UIImage imageNamed:@"bigarrow2"] forState:UIControlStateNormal];
                        }
                        
                        
                        
                        cell.tag = indexPath.section +100;
                        return cell;
                    }
                        break;
                    default:
                    {
                        DropDowmMenuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"classification_small"];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"DropDowmMenuTableViewCell" owner:self options:nil] objectAtIndex:2];
                        }
                        if (self.dataArr) {
                            ClassificationModel* cModel = self.dataArr[indexPath.section-2];
                            ClassificationSecModel * csModel = cModel.sub[indexPath.row -1];
                            cell.csModel = csModel;
                        }
                        return cell;
                    }
                        // 第一次展现出来的cell无法复用
                        break;
                }
                
                
            }
                break;
        }

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dropDownMenuViewType == DropDownMenuViewRemoveAll) {
        if (  indexPath.row == 0) {
            
            
            ClassificationModel* cModel = self.dataArr[indexPath.section];
            
            if (cModel.sub.count!=0) {
                NSInteger sec = (NSInteger)indexPath.section;
                self.selectedSection = sec;
                self.isClicked = @"sdf";
                
                //            DropDowmMenuTableViewCell * cell = (DropDowmMenuTableViewCell *)[tableView viewWithTag:indexPath.section +100];
                
                if ([[self.statusArr objectAtIndex:indexPath.section] isEqualToString:@"0"]) {
                    [self.statusArr replaceObjectAtIndex:indexPath.section withObject:@"1"];
                    self.allRows -= cModel.sub.count;
                }
                else{
                    [self.statusArr replaceObjectAtIndex:indexPath.section withObject:@"0"];
                    self.allRows +=cModel.sub.count;
                }
                
                [self resetTableViewHeight];
                
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

            }else{
                if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithText: andAuto_code:)]) {
                    ClassificationModel* cModel = self.dataArr[indexPath.section];
                    [self.delegate didSelectRowAtIndexPathWithText:cModel.modules_name andAuto_code:cModel.auto_code];
                }
                
            }
            
            if (self.block) {
                self.block (self.allRows * ADDTIONALCELLHEIGHT);
            }
        } else if( indexPath.row >0){
            if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithText: andAuto_code:)]) {
                DropDowmMenuTableViewCell *cell = (DropDowmMenuTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                ClassificationModel* cModel = self.dataArr[indexPath.section];
                ClassificationSecModel * csModel = cModel.sub[indexPath.row -1];
                NSString *classification = [NSString stringWithFormat:@"%@",cell.smallClassLabel.text];
                [self.delegate didSelectRowAtIndexPathWithText:classification andAuto_code:csModel.auto_code];
            }
            
        }

    }
    else{
        if (indexPath.section >1&& indexPath.row == 0) {
            
            
            ClassificationModel* cModel = self.dataArr[indexPath.section-2];
            
            if (cModel.sub.count!=0) {
                NSInteger sec = (NSInteger)indexPath.section;
                self.selectedSection = sec;
                self.isClicked = @"sdf";
                
                
                if ([[self.statusArr objectAtIndex:indexPath.section-2] isEqualToString:@"0"]) {
                    [self.statusArr replaceObjectAtIndex:indexPath.section-2 withObject:@"1"];
                    self.allRows -= cModel.sub.count;
                }
                else{
                    [self.statusArr replaceObjectAtIndex:indexPath.section-2 withObject:@"0"];
                    
                    self.allRows +=cModel.sub.count;
                }
                
                [self resetTableViewHeight];
                
                 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithText: andAuto_code:)]) {
                    ClassificationModel* cModel = self.dataArr[indexPath.section-2];
                    [self.delegate didSelectRowAtIndexPathWithText:cModel.modules_name andAuto_code:cModel.auto_code];
                }
                
            }
            
            
        } else if(indexPath.section >1&& indexPath.row >0){
            if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithText: andAuto_code:)]) {
                DropDowmMenuTableViewCell *cell = (DropDowmMenuTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                ClassificationModel* cModel = self.dataArr[indexPath.section-2];
                ClassificationSecModel * csModel = cModel.sub[indexPath.row -1];
                NSString *classification = [NSString stringWithFormat:@"%@-%@",cModel.modules_name,cell.smallClassLabel.text];
                [self.delegate didSelectRowAtIndexPathWithText:classification andAuto_code:csModel.auto_code];
            }
        }
        
        if (indexPath.section == 1) {
            if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPathWithText: andAuto_code:)]) {
                //            DropDowmMenuTableViewCell *cell = (DropDowmMenuTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                [self.delegate didSelectRowAtIndexPathWithText:@"全部" andAuto_code:@""];
            }
        }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dropDownMenuViewType == DropDownMenuViewDefault) {
        if (indexPath.section == 0) {
            return FIRSTCELLHEIGHT;
        }
        return SECONDCELLHEIGHT;
    }
    else{
         return ADDTIONALCELLHEIGHT;
    }
}
#pragma mark - 点击空白移除下拉菜单
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     UITouch *touch = [[event allTouches] anyObject];
    if (![touch.view isKindOfClass:[UITableView class]]) {
        [self removeFromSuperview];
        if (self.currentBtnblock) {
            self.currentBtnblock(YES);
        }
    }
    
}
-(void)resetTableViewHeight{
   
    if (self.dropDownMenuViewType == DropDownMenuViewDefault) {
        CGFloat tableviewHeight = SECONDCELLHEIGHT * (self.allRows+1) + SECONDCELLHEIGHT;
        self.tableViewHeightConstraint.constant = tableviewHeight;
    }
    else{
      
        CGFloat tableviewHeight = ADDTIONALCELLHEIGHT * self.allRows ;
//        self.tableViewHeightConstraint.constant = tableviewHeight;
        //滚动的前提是高度小于内容的高度
   
        CGFloat realHeight = CGRectGetHeight(self.bounds) - self.topConstraint.constant;
        if (tableviewHeight > realHeight) {
            self.tableViewHeightConstraint.constant = realHeight;
        }
        else{
            self.tableViewHeightConstraint.constant = tableviewHeight;
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
 
@end
