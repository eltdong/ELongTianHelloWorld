//
//  BusinessHoursViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/7.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//


#define secondeCellTag 100
#import "BusinessHoursViewController.h"
#import "BusinessHoursTableViewCell.h"
#import "BusinessHoursSecTableViewCell.h"
#import "CustomPickerView.h"
#define CELL_TAG 865541235
#define CELL_BTN_TAG 965541235
#import "ELTEshopTime.h"
#import "CommonFunc.h"

@interface BusinessHoursViewController ()<UITableViewDataSource,UITableViewDelegate,BusinessHoursSecDeleagate,CustomPickerViewDelegate>{
    NSArray * _weekArr;
    NSInteger _tag;
    NSMutableArray * _dataArr;
    
    NSString * _task;
    NSMutableArray * _HArr;
    NSMutableArray * _MArr;
    
    NSString * _one_pickerStr;
    NSString * _two_pickerStr;
    
    NSInteger one;
    NSInteger two;
    NSInteger three;
    NSInteger four;
}

@end

@implementation BusinessHoursViewController
- (NSMutableArray *)cellArr{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self createUI];
//    [self.datePicker_one setLocale:[NSLocale systemLocale]];
    _weekArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    self.pickerView_bjView.hidden = YES;
//    _selectDic = [NSMutableDictionary dictionary];
//    for (int i =0 ; i<7; i++) {
//        NSDictionary * dic = [_dataTimeArr objectAtIndex:i];
//        if (![[dic objectForKey:@"open_time"] isEqualToString:@""]) {
//            [_selectDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];
//        }else{
//            [_selectDic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
    //    deleshopresttime  删除休息时间
    //    seteshopresttime  修改休息时间
    //    eshopresttime 休息时间列表
    //    eshoptime  营业时间列表
    if (_isEdit) {
        [self.indicator startAnimatingActivit];
        [self downRequestEshoptime];
    }
    if (_dataTimeArr.count  < 1) {
        _dataTimeArr = [NSMutableArray array];
        for (int i = 0; i<7; i++) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            //            [dic setValue:@"设置开始启动时间" forKey:@"open_time"];
            //            [dic setValue:@"设置结束启动时间" forKey:@"close_time"];
            [_dataTimeArr addObject:dic];
        }
    }
    _one_pickerStr = [NSString stringWithFormat:@"%@:%@",@"8",@"00"];
    _two_pickerStr = [NSString stringWithFormat:@"%@:%@",@"20",@"00"];
    _HArr = [NSMutableArray arrayWithObjects:@"0",nil];
    for (int i = 1; i<24; i++) {
        [_HArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    _MArr = [NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09", nil];
    for (int i = 10; i<60; i++) {
        [_MArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.pickerView_one.tag = 1;
    self.pickerView_two.tag = 2;
    
    self.pickerView_one.delegate = self;
    self.pickerView_one.dataSource = self;
    self.pickerView_two.delegate = self;
    self.pickerView_two.dataSource = self;
    [self.pickerView_one selectRow:8 inComponent:0 animated:YES];
    [self.pickerView_one selectRow:0 inComponent:1 animated:YES];
    [self.pickerView_two selectRow:20 inComponent:0 animated:YES];
    [self.pickerView_two selectRow:0 inComponent:1 animated:YES];
}
//以下3个方法实现PickerView的数据初始化
//确定picker的轮子个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
//确定picker的每个轮子的item数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return [_HArr count];
    } else {//市的个数
        return [_MArr count];
    }
}
//确定每个轮子的每一项显示什么内容
#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {//选择省份名
        return [_HArr objectAtIndex:row];
    } else {//选择市名
        return [_MArr objectAtIndex:row];
    }
}

//监听轮子的移动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString * oneStr = @"0";
    NSString * twoStr = @"00";
    if (pickerView.tag == 1) {
        oneStr = @"8";
        twoStr = @"00";
        one = [oneStr integerValue];
        two = [twoStr integerValue];
    }else{
        oneStr = @"20";
        twoStr = @"00";
        three = [oneStr integerValue];
        four = [twoStr integerValue];
    }
    if (component == 0) {
        oneStr = [_HArr objectAtIndex:row];
        NSInteger selectedCityIndex = [pickerView selectedRowInComponent:1];
        twoStr = [_MArr objectAtIndex:selectedCityIndex];
    }
    else {
        twoStr = [_MArr objectAtIndex:row];
        NSInteger selectedProvinceIndex = [pickerView selectedRowInComponent:0];
        oneStr= [_HArr objectAtIndex:selectedProvinceIndex];
    }
    
    if (pickerView.tag == 1) {
        _one_pickerStr = [NSString stringWithFormat:@"%@:%@",oneStr,twoStr];
        one = [oneStr integerValue];
        two = [twoStr integerValue];
    }else{
        _two_pickerStr = [NSString stringWithFormat:@"%@:%@",oneStr,twoStr];
        three = [oneStr integerValue];
        four = [twoStr integerValue];
    }
}




- (void)downRequestEshoptime{
//   self.
    [ELRequestSingle getEshopTimeRequestWithBlock:^(BOOL sucess, id objc) {
//        _dataTimeArr = objc;
        
        [self downRequestEshopresttime];
        for (int i = 0; i<7; i++) {
            ELTEshopTime * shopTime = [objc objectAtIndex:i];
            [[_dataTimeArr objectAtIndex:[shopTime.week integerValue]] setValue:shopTime.open_time forKey:@"open_time"];
            [[_dataTimeArr objectAtIndex:[shopTime.week integerValue]] setValue:shopTime.close_time forKey:@"close_time"];
            if ([shopTime.open_time isEqualToString:@""] || shopTime.open_time == nil){
                [[_dataTimeArr objectAtIndex:[shopTime.week integerValue]] setValue:@"0" forKey:@"weekSelect"];
            }else{
                [[_dataTimeArr objectAtIndex:[shopTime.week integerValue]] setValue:@"1" forKey:@"weekSelect"];
            }
        }
    } andShoppe_id:_shoppe_id andTask:@"eshoptime"];
}
- (void)downRequestEshopresttime{
    [ELRequestSingle getEshopTimeRequestWithBlock:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        [[ELTDataArr dataArr].dataArr removeAllObjects];
        NSLog(@"%@",[ELTDataArr dataArr].dataArr);
        
        [ELTDataArr dataArr].dataArr = objc;
        NSLog(@"%@",[ELTDataArr dataArr].dataArr);
        [_tabelView reloadData];
    } andShoppe_id:_shoppe_id andTask:@"eshopresttime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)home:(id)sender{
        NSMutableArray * weekTimeArr = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            BusinessHoursTableViewCell * cell = (BusinessHoursTableViewCell *)[_tabelView viewWithTag:CELL_TAG + i];
            NSMutableDictionary * dic;
            if (cell.selectBtn.selected) {
                dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [NSString stringWithFormat:@"%d",i],@"week",
                                             cell.startBtn.titleLabel.text,@"open_time",
                                             cell.endBtn.titleLabel.text,@"close_time",
                                            @"1",@"weekSelect",
                                             nil];
            }else{
                dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%d",i],@"week",
                       @"",@"open_time",
                       @"",@"close_time",
                       @"0",@"weekSelect",
                       nil];
            }
            [weekTimeArr addObject:dic];
        }
        int i = 0;
        for (NSDictionary * dic in weekTimeArr) {
            if ([[dic objectForKey:@"opem_time"] isEqualToString:@""] || [[dic objectForKey:@"weekSelect"] isEqualToString:@"0"]) {
                i++;
            }
            if (i >= 7) {
                [self showAlertViewWith:@"请选择营业时间!"];
                return;
            }
        }
        
        if (_block) {
            self.block(weekTimeArr,[ELTDataArr dataArr].dataArr);
        }
    if (_isEdit) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * dic in weekTimeArr) {
            
            if([[dic objectForKey:@"weekSelect"] isEqualToString:@"1"]){
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"week"],@"week",
                                             [dic objectForKey:@"close_time"],@"close_time",
                                             [dic objectForKey:@"open_time"],@"open_time",
                                             _shoppe_id,@"eshop_id",
                                             nil];
                [arr addObject:dataDic];
            }
                    }
        NSLog(@"%@",[arr JSONString]);
//        [self.indicator setIndicatorType:ActivityIndicatorLogin];
//        [self.indicator startAnimatingActivit];
        [ELRequestSingle editEshopTimeRequestWithBlock:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
            [self showAlertViewWith:objc];
        } andShoppe_id:_shoppe_id andTask:@"seteshopresttime" andData:[CommonFunc base64StringFromText:[arr JSONString]]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{
    self.navbar.titleLabel.text =@"营业时间";
    [self.navbar.homebtn setTitle:@"存储" forState:UIControlStateNormal];
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 7;
        }
            break;
            
        default:
        {
            return 1;
        }
            break;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellId = @"BusinessHoursTableViewCellID";
            BusinessHoursTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessHoursTableViewCell" owner:nil options:nil] firstObject];
            }
            cell.weekName.text = _weekArr[indexPath.row];
            cell.tag = CELL_TAG + indexPath.row;
            cell.startBtn.tag = CELL_BTN_TAG + indexPath.row;
            cell.endBtn.tag = CELL_BTN_TAG + indexPath.row;
            [cell.startBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.endBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (_dataTimeArr.count > 0) {
                NSDictionary * dic = [_dataTimeArr objectAtIndex:indexPath.row];
                if ([[dic objectForKey:@"weekSelect"] isEqualToString:@"1"]) {
                    [cell.startBtn setTitle:[dic objectForKey:@"open_time"] forState:UIControlStateNormal];
                    [cell.endBtn setTitle:[dic objectForKey:@"close_time"] forState:UIControlStateNormal];
                    cell.selectBtn.selected = YES;
                }else{
                    [cell.startBtn setTitle:[dic objectForKey:@"open_time"] forState:UIControlStateNormal];
                    [cell.endBtn setTitle:[dic objectForKey:@"close_time"] forState:UIControlStateNormal];
                    if([[dic objectForKey:@"open_time"] isEqualToString:@""] || [dic objectForKey:@"open_time"] == nil){
                    [cell.startBtn setTitle:@"设置开始时间" forState:UIControlStateNormal];
                    [cell.endBtn setTitle:@"设置结束时间"forState:UIControlStateNormal];
                    }
                    cell.selectBtn.selected = NO;
                }
            }
            cell.selectBtn.tag = indexPath.row;
            [cell.selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 1:
        {
            BusinessHoursSecTableViewCell * cell = [BusinessHoursSecTableViewCell cellWithTableView:tableView];
            cell.vc = self;
            cell.tableView = tableView;
            cell.tag = secondeCellTag;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            BusinessHoursTableViewCell * cell = [[NSBundle mainBundle]loadNibNamed:@"BusinessHoursTableViewCell" owner:nil options:nil][2] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            break;
    }

    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return 35.5f;
        }
            break;
        case 1:
        {
            UITableViewCell * cell = [self  tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
            break;
        default:
            return 80.f;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)selectBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(btn.selected){
        [[_dataTimeArr objectAtIndex:btn.tag] setValue:@"1" forKey:@"weekSelect"];
    }else{
        [[_dataTimeArr objectAtIndex:btn.tag] setValue:@"0" forKey:@"weekSelect"];
    }
}

- (void)timeBtnClicked:(UIButton *)btn{
    _tag = btn.tag - CELL_BTN_TAG + CELL_TAG;
    self.pickerView_bjView.hidden = NO;
}
- (IBAction)cancleBtnClicked:(id)sender {
    self.pickerView_bjView.hidden = YES;
    
}
- (IBAction)okBtnClicked:(id)sender {
    self.pickerView_bjView.hidden = YES;
    
    NSString *destDateString_one = _one_pickerStr;
    NSString *destDateString_two = _two_pickerStr;
    if (one < three) {
        if (three - one > 1) {
            
        }else if (three - one == 1){
            if (two <= four) {
                
            }else{
                [self showAlertViewWith:@"营业时间不能小于一小时"];
                return;
            }
        }else{
            [self showAlertViewWith:@"营业时间不能小于一小时"];
            return;
        }
    }else{
        
    }
    
    
    if (_isEdit) {
        BusinessHoursTableViewCell * cell = (BusinessHoursTableViewCell *)[_tabelView viewWithTag:_tag];
        [cell.startBtn setTitle:destDateString_one forState:UIControlStateNormal];
        [cell.endBtn setTitle:destDateString_two forState:UIControlStateNormal];
        cell.selectBtn.selected = YES;
        //状态记录
        [[_dataTimeArr objectAtIndex:_tag - CELL_TAG] setValue:destDateString_one forKey:@"open_time"];
        [[_dataTimeArr objectAtIndex:_tag - CELL_TAG] setValue:destDateString_two forKey:@"close_time"];
        [[_dataTimeArr objectAtIndex:_tag - CELL_TAG] setValue:@"1" forKey:@"weekSelect"];
    }else{
        for (NSInteger i = _tag - CELL_TAG; i < 7; i++) {
            BusinessHoursTableViewCell * cell = (BusinessHoursTableViewCell *)[_tabelView viewWithTag:CELL_TAG + i];
            [cell.startBtn setTitle:destDateString_one forState:UIControlStateNormal];
            [cell.endBtn setTitle:destDateString_two forState:UIControlStateNormal];
            cell.selectBtn.selected = YES;
            
            //状态记录
            [[_dataTimeArr objectAtIndex:i] setValue:destDateString_one forKey:@"open_time"];
            [[_dataTimeArr objectAtIndex:i] setValue:destDateString_two forKey:@"close_time"];
            [[_dataTimeArr objectAtIndex:i] setValue:@"1" forKey:@"weekSelect"];
            
        }
    }
}
#pragma  mark - second点击事件
-(void)addBtn{
//    CustomPickerView * cpv =[CustomPickerView instanceView];
//    cpv.tag = 999;
//    cpv.delegate = self;
//    cpv.frame = self.view.bounds;
//    [self.view addSubview:cpv];
}

- (void)requestRemoveWithID:(NSInteger)ID{
//
    if (_isEdit && [[ELTDataArr dataArr].dataArrID count] > 0 ) {
        NSLog(@"%@",[ELTDataArr dataArr].dataArrID[ID]);
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        [ELRequestSingle editEshopTimeRequestWithBlock:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
            [self showAlertViewWith:objc];
            [[ELTDataArr dataArr].dataArrID removeObjectAtIndex:ID];
        } andShoppe_id:_shoppe_id andTask:@"deleshopresttime" andData:[NSDictionary dictionaryWithObjectsAndKeys:[ELTDataArr dataArr].dataArrID[ID],@"id", nil]];
    }
}

- (void)requestAddWithData:(NSString *)data{
    if ([data isEqualToString:@"重复添加"]) {
        [self showAlertViewWith:data];
        return;
    }
    if (_isEdit) {
        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        [ELRequestSingle editEshopTimeRequestWithBlock:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
            if (sucess) {
                [[ELTDataArr dataArr].dataArr addObject:data];
                
                [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self showAlertViewWith:objc];
        } andShoppe_id:_shoppe_id andTask:@"seteshopresttime" andData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       [self textFieldYear:data],@"breaktime[date]",
                                                                       _shoppe_id,@"breaktime[eshop_id]", nil]];
    }else{
        [[ELTDataArr dataArr].dataArr addObject:data];
        [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark - 替换年月日
- (NSString *)textFieldYear:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    return str;
}

-(void)getCurrentDate:(NSString *)currentDate{
    CustomPickerView * cpv =(CustomPickerView *)[self.view viewWithTag:999];
    [cpv removeFromSuperview];
    //使用tag值获取某个cell
     BusinessHoursSecTableViewCell * cell = (BusinessHoursSecTableViewCell *)[self.view viewWithTag:secondeCellTag];
    cell.received = [NSString stringWithFormat:@"%@",currentDate];
//    [self.tabelView reloadData];
    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
}
@end
