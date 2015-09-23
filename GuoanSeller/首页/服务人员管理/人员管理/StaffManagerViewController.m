//
//  StaffManagerViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "StaffManagerViewController.h"
#import "StaffManagerCollectionViewCell.h"
#import "AddStaffViewController.h"
#import "PeopleModel.h"
#import "AddPersonModel.h"

@interface StaffManagerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    BOOL isEdit;
    NSInteger _page;
}

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation StaffManagerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ELTRefreshSingleton refreshIsOK].state) {
        [_dataArray removeAllObjects];
        _page = 1;
        [self downRequest];
        [ELTRefreshSingleton refreshIsOK].state = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"人员管理";
    _dataArray = [NSMutableArray array];
    
    _collection.dataSource=self;
    _collection.delegate=self;
    
    [_collection registerNib:[UINib nibWithNibName:@"StaffManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"StaffManagerCollectionViewCell"];
    
    isEdit = NO;
    
    _page = 1;
    [self drop_on];
    [self drop_down];
    
    if (_is_limit == 1) {
        _isOn.on = NO;
        _collection.hidden = YES;
        _secondBottom.hidden = YES;
        _line.hidden = YES;
    }else{
        _isOn.on = YES;
        _collection.hidden = NO;
        _secondBottom.hidden = NO;
        _line.hidden = NO;
        [self downRequest];
    }
}

#pragma mark - collectionview Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StaffManagerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StaffManagerCollectionViewCell" forIndexPath:indexPath];
    if (_dataArray.count) {
        PeopleModel *model = [_dataArray objectAtIndex:indexPath.item];
        [cell.photoImage setImageWithURL:[NSURL URLWithString:model.photo]];
        cell.namelabel.text = model.name;
        if (isEdit){
            cell.blackView.hidden = NO;
            cell.selectImage.hidden = NO;
        }else{
            cell.blackView.hidden = YES;
            cell.selectImage.hidden = YES;
        }
        if (model.isSelected) {
            [cell.selectImage setImage:[UIImage imageNamed:@"xuanzhong.png"]];
        }else{
            [cell.selectImage setImage:[UIImage imageNamed:@"elt_noxuanzhong.png"]];
        }
    }
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREENWIDTH - 45)/2, (SCREENWIDTH - 45)/2 + 30);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 15, 8, 15);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isEdit) {
        PeopleModel *model = [_dataArray objectAtIndex:indexPath.item];
        model.isSelected = !model.isSelected;
        [collectionView reloadData];
    }else{

        [self.indicator setIndicatorType:ActivityIndicatorLogin];
        [self.indicator startAnimatingActivit];
        PeopleModel *peopleModel = [_dataArray objectAtIndex:indexPath.item];
        [ELRequestSingle getPersonDeatiWithRequest:^(BOOL sucess, id objc) {
            [self.indicator LoadSuccess];
            AddPersonModel *model = objc;
            AddStaffViewController *view = [[AddStaffViewController alloc]init];
            view.personModel = model;
            view.tag = @"modify";
            view.shopId = _shopId;
            view.personID = peopleModel.peopleID;
            [self.navigationController pushViewController:view animated:YES];
        } andId:peopleModel.peopleID];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBtn:(id)sender {
    
    if (isEdit) {
        return;
    }
    
    AddStaffViewController *view = [[AddStaffViewController alloc]init];
    view.shopId = _shopId;
    [self.navigationController pushViewController:view animated:YES];
    
}

- (IBAction)deleteBtn:(id)sender {
    
    if (!_dataArray.count) {
        return;
    }
    if (!isEdit) {
        
        _isOn.userInteractionEnabled = NO;
        _addBtn.userInteractionEnabled = NO;
        
    }else{
        
        _isOn.userInteractionEnabled = YES;
        _addBtn.userInteractionEnabled = YES;
        
    }
    
    if (isEdit) {
        NSMutableArray *array = [NSMutableArray array];
        for (PeopleModel *model in _dataArray) {
            if (model.isSelected) {
                [array addObject:model.peopleID];
            }
        }
        if (!array.count) {
            isEdit = !isEdit;
            [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.collection reloadData];
            return;
        }
    }
    
    isEdit = !isEdit;
    if (isEdit) {
        [_deleteBtn setTitle:@"确认删除" forState:UIControlStateNormal];
        [self.collection reloadData];
    }else{
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            isEdit = NO;
            for (PeopleModel *model in _dataArray) {
                if (model.isSelected) {
                    model.isSelected = NO;
                }
            }
            [self.collection reloadData];
        }
            break;
        case 1:
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (int i = 0; i < _dataArray.count; i++) {
                PeopleModel *model = [_dataArray objectAtIndex:i];
                if (model.isSelected) {
                    [array addObject:model.peopleID];
                    [_dataArray removeObjectAtIndex:i];
                    i = -1;
                }
            }
            NSString *string = [array componentsJoinedByString:@","];
            [self.indicator setIndicatorType:ActivityIndicatorLogin];
            [self.indicator startAnimatingActivit];
            [ELRequestSingle deletePersonWithRequest:^(BOOL sucess, id objc) {
                [self.indicator LoadSuccess];
                [self showAlertViewWith:@"删除成功"];
                [self.collection reloadData];
                
            } andShoppe_id:_shopId andID:string];
        }
            break;
            
        default:
            break;
    }
}


- (IBAction)isOnClick:(id)sender {
    
    [ELTRefreshSingleton refreshIsOK].state = YES;
    
    UISwitch *isOnSwitch = sender;
    NSInteger type;
    if (isOnSwitch.on) {
        type = 2;
    }else{
        type = 1;
    }
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle isLimitedWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
    } andShoppe_id:_shopId andType:type];
    if (isOnSwitch.on) {
        _collection.hidden = NO;
        _secondBottom.hidden = NO;
        _line.hidden = NO;
    }else{
        _collection.hidden = YES;
        _secondBottom.hidden = YES;
        _line.hidden = YES;
    }
    
}

-(void)downRequest{
    
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getpeopleListWithRequest:^(BOOL sucess, id objc) {
        
        [self.indicator LoadSuccess];
        if ([objc isKindOfClass:[NSString class]]) {
            [self.collection removeFooter];
            [self.collection.header endRefreshing];
            [self.collection reloadData];
            [self showAlertViewWith:objc];
            return ;
        }
        if (_page == 1) {
            _dataArray = objc;
        }else{
            [_dataArray addObjectsFromArray:objc];
        }
        if (_dataArray.count == 0) {
            [self.collection removeFooter];
            [self.collection.footer noticeNoMoreData];
        }else{
            [self.collection.header endRefreshing];
            [self.collection.footer endRefreshing];
        }
        if(_dataArray.count < 10){
            [self.collection removeFooter];
        }
        [self.collection reloadData];
        
        
    } andShoppe_id:_shopId andPage:_page];
    
}

/**
 * UITableView +   传统
 */
- (void)drop_on
{
    __weak typeof(self) weakSelf = self;
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    [self.collection addLegendFooterWithRefreshingBlock:^{
        _page ++;
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf downRequest];
    }];
}
/**
 * UITableView + 下拉刷新 传统
 */
- (void)drop_down
{
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.collection addLegendHeaderWithRefreshingBlock:^{
        _page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.indicator setIndicatorType:ActivityIndicatorLogin];
        [weakSelf downRequest];
        // 马上进入刷新状态
    }];
}

@end
