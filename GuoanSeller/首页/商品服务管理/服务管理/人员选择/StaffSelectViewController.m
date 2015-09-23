//
//  StaffSelectViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/10.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//
#define customRowNum @"10"
#import "StaffSelectViewController.h"
#import "StaffSelectCollectionViewCell.h"
#import "PeopleModel.h"
@interface StaffSelectViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//存点击的item的indexPath
@property (nonatomic,assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableDictionary * lastDataDictionary;
@end

@implementation StaffSelectViewController
- (NSMutableDictionary *)lastDataDictionary{
    if (!_lastDataDictionary) {
        _lastDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               customRowNum,@"row",
                               @"1",@"page",
                               self.shoppe_id,@"shoppe_id",
                               nil];
    }
    return _lastDataDictionary;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.seleceBtnArr.count  &&[[self.seleceBtnArr objectAtIndex:0] isEqualToString:@"all"]) {
        self.allBtn.selected = YES;
    }
    else {
        [self.collectionView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _seleceBtnArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    if (self.seleceBtnArr.count  &&[[self.seleceBtnArr objectAtIndex:0] isEqualToString:@"all"]) {
        self.allBtn.selected = YES;
    }
    self.navbar.titleLabel.text = @"人员选择";
    
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.scrollEnabled = YES;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"StaffSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StaffSelectCollectionViewCell"];
    
    [self.navbar.homebtn setTitle:@"完成" forState:UIControlStateNormal];
    [self downRequest:self.lastDataDictionary];
    [self drop_down];
    [self drop_on];
}
- (void)downRequest:(NSMutableDictionary *)dic{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getpeopleListWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        
        if (sucess) {
            NSArray *arr =(NSArray *)objc;
            if(arr.count <[customRowNum intValue])
            {
                [self.collectionView.footer endRefreshing]; 
                self.collectionView.footer.hidden = YES;
            }
            [self.dataArr  addObjectsFromArray:objc];
            [self.collectionView  reloadData];
            
        }
        else{
            self.collectionView.footer.hidden = YES;
//            [self showAlertViewWith:objc];
        }
        
        [self.collectionView.header endRefreshing]; 
    } andParadic:self.lastDataDictionary];
    
}
#pragma mark - 刷新加载
- (void)drop_on
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
         weakSelf.page++ ;
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        NSString * num = [NSString stringWithFormat:@"%ld", weakSelf.page];
        [weakSelf.lastDataDictionary setValue:num forKey:@"page"];
        [weakSelf downRequest: weakSelf.lastDataDictionary];
    }];
}
- (void)drop_down
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        _page = 1;
        if (weakSelf.dataArr.count ==0) {
            [weakSelf.collectionView.footer noticeNoMoreData];
        }
        [weakSelf.dataArr removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf.lastDataDictionary setObject:@"1" forKey:@"page"];
        [weakSelf downRequest:weakSelf.lastDataDictionary];
     }];
}


#pragma mark - collectionview Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StaffSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StaffSelectCollectionViewCell" forIndexPath:indexPath];
    if (_dataArr.count) {
        PeopleModel * model = [_dataArr objectAtIndex:indexPath.row];
        [cell.imgView setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil];
        cell.name.text = model.name;
        cell.selectBtn.tag = 100 + indexPath.row;
        cell.selectBtn.selected = NO;
        //记录人员的状态 并赋值
        if (_seleceBtnArr) {
            for (NSString * idStr in _seleceBtnArr) {
                if ([model.peopleID isEqualToString:idStr]) {
                    cell.selectBtn.selected = YES;
                }
            }
        }
        if (self.allBtn.selected) {
            cell.selectBtn.hidden = YES;
        }
        else{
            cell.selectBtn.hidden = NO;
        }
    } 
    [cell.selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((SCREENWIDTH - 45)/2, SCREENWIDTH / 1.8);
    return CGSizeMake((SCREENWIDTH - 45)/2, (SCREENWIDTH - 45)/2);//等宽
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

#pragma mark - 点击选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffSelectCollectionViewCell * cell = (StaffSelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if (self.allBtn.selected) {
        
    }
    else{
        if (cell.selectBtn.selected == YES) {
            if (self.allBtn.selected) {
                [_seleceBtnArr removeAllObjects];
            }
            [_seleceBtnArr addObject:[[_dataArr objectAtIndex:indexPath.row] peopleID]];
        }else{
            
            [_seleceBtnArr removeObject:[[_dataArr objectAtIndex:indexPath.row] peopleID]];
        }
        
    }

    
    
}
#pragma mark - item  Button 的点击事件
- (void)selectBtnClicked:(id)sender{
    UIButton * btn = (UIButton *)sender;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:btn.tag - 100 inSection:0];
    StaffSelectCollectionViewCell * cell = (StaffSelectCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if (self.allBtn.selected) {
        
    }
    else{
        if (cell.selectBtn.selected == YES) {
            if (self.allBtn.selected) {
                [_seleceBtnArr removeAllObjects];
            }
            [_seleceBtnArr addObject:[[_dataArr objectAtIndex:indexPath.row] peopleID]];
         }else{
            
            [_seleceBtnArr removeObject:[[_dataArr objectAtIndex:indexPath.row] peopleID]];
        }

    }
}

#pragma mark - 全员的点击事件
- (IBAction)allBtnClicked:(id)sender {
    self.allBtn.selected = !self.allBtn.selected;
    [_seleceBtnArr removeAllObjects];
    for (int i = 0; i < _dataArr.count; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        StaffSelectCollectionViewCell * cell = (StaffSelectCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.selectBtn.selected = NO;
        if (self.allBtn.selected) {
            cell.selectBtn.hidden = YES;
        }
        else{
            cell.selectBtn.hidden = NO;
        
        }
    }
    
    if (self.allBtn.selected) {
        NSMutableArray * arr = [NSMutableArray arrayWithObjects:@"all", nil];
        _seleceBtnArr = arr;
    }
    else{
        [_seleceBtnArr  removeAllObjects];
    }
    
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)home:(id)sender{
//    NSMutableArray * mutabArr = [NSMutableArray array];
//    for(int i = 0;i < _seleceBtnArr.count; i++){
//        [mutabArr addObject:[_dataArr[[_seleceBtnArr[i] row]] peopleID]];
//    }
    if (self.block) {
        self.block(_seleceBtnArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
