//
//  PersonTimeManagerViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "PersonTimeManagerViewController.h"
#import "SSTSCollectionViewCell.h"
#import "DateModel.h"
#import "TimeModel.h"
#import <objc/runtime.h>

#define TOTALWIDTH @"totalWidth"
#define VIEW_TAG 562222156

#define scrollViewSepWidth self.scrollViewBotomView.frame.size.width/4.5f//滚动视图中每个滚动单元的width
@interface PersonTimeManagerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray * _mItemInfoArray;
    NSInteger mTotalWidth;
    NSString *_date;//日期
    NSInteger count;//计数
    NSInteger _weekTimeCount;
}
@property (nonatomic,strong) NSMutableArray * dataArr;//复制

@property (nonatomic,strong) NSMutableArray * timeArr;

@property (nonatomic,strong) NSMutableArray *allArray;//从本地取出来的数组

@property (nonatomic,strong) UIButton * selectedButton;

//滚动条上的选中的button
@property (nonatomic,strong) NSMutableArray *buttonsArr;
@property (nonatomic, strong) UIButton *scrollViewFirBtn;
@property (nonatomic, strong) UIButton *scrollViewSecBtn;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@end

@implementation PersonTimeManagerViewController
-(NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr =[NSMutableArray array];
    }
    return _timeArr;
}

-(void)viewWillAppear:(BOOL)animated{
    _allArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"AllArray"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mItemInfoArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
    self.navbar.titleLabel.text = @"个人时间管理";
    [self createUI];
    [self createCustomScrollView];
    count = 0;
    
    DateModel *model = [_dateArray firstObject];
    _date = model.date;
    if (model.click) {
        [self downRequest];
    }else{
        [self showAlertViewWith:@"抱歉，当天没有设置营业时间"];
    }
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREENWIDTH - 52, 30, 40, 30);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:rightBtn];

    _weekTimeCount = 0;
}

-(void)back:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightClick{
    
    [ELTRefreshSingleton refreshIsOK].state = YES;
    [[NSUserDefaults standardUserDefaults]setObject:_allArray forKey:@"AllArray"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自定义滚动视图
-(void)createCustomScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, self.scrollViewBotomView.frame.size.height);
#define scrollViewSepWidth self.scrollViewBotomView.frame.size.width/4.5f
    CGFloat imageW = SCREENWIDTH/4.5f;
    
    NSLog(@"imageWimageWimageWimageW%f",imageW);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(imageW *7+30*2, 0);//内容视图
    scrollView.contentOffset = CGPointMake(0, 0);//初始位置偏移量
    scrollView.delegate = self;
    scrollView.bounces = YES;
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.tag = 1000;
    self.mainScrollView = scrollView;
    [self.scrollViewBotomView addSubview:scrollView];
    for (int index = 0; index<7; index++) {
        UIView * view = [[UIView alloc]init];
        DateModel * dateModel = [_dateArray objectAtIndex:index];
        view.tag = index+ VIEW_TAG;//view的标记
        view.backgroundColor =UIColorFromRGB(0xf5f5f5);
        // 设置frame
        CGFloat imageX = index * imageW;
        view.frame = CGRectMake(30+imageX, 0, imageW, self.scrollViewBotomView.frame.size.height);
        UIButton * lableTop =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/2)];
        [lableTop setTitle:[NSString stringWithFormat:@"%d",index+1] forState:UIControlStateNormal];
        [lableTop setTitle:dateModel.name forState:UIControlStateNormal];
        lableTop.titleLabel.textAlignment = NSTextAlignmentLeft;
        lableTop.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [lableTop setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [lableTop setTitleColor:UIColorFromRGB(0xda2c41) forState:UIControlStateSelected];
        lableTop.titleLabel.font =[UIFont systemFontOfSize:12];
        
        lableTop.userInteractionEnabled =NO;
        [view addSubview: lableTop];
        
        UIButton* lableTop2 =[[UIButton alloc]initWithFrame:CGRectMake(0,view.frame.size.height/2.f, view.frame.size.width, view.frame.size.height/2.f)];
        [ lableTop2 setTitle:dateModel.label forState:UIControlStateNormal];
        [ lableTop2 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [ lableTop2 setTitleColor:UIColorFromRGB(0xda2c41) forState:UIControlStateSelected];
        lableTop2.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        lableTop2.titleLabel.font =[UIFont systemFontOfSize:14];
        lableTop2.userInteractionEnabled =NO;
        [view addSubview: lableTop2];
        
        if (index ==0) {
            lableTop.selected =YES;
            self.scrollViewFirBtn = lableTop;
            
            lableTop2.selected =YES;
            self.scrollViewSecBtn = lableTop2;
        }
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
        [view addGestureRecognizer:tap];
        [scrollView addSubview:view];
        [self.buttonsArr addObject:view];
        
        //保存button资源信息，同时增加button.oringin.x的位置，方便点击button时，移动位置。
        NSMutableDictionary *vNewDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:imageW * index + 1],TOTALWIDTH, nil];
        [_mItemInfoArray addObject:vNewDic];
        mTotalWidth = imageW * index + 1;
    }
    
}

#pragma mark 移动button到可视的区域
-(void)moveScrolViewWithIndex:(NSInteger)aIndex Left_or_Right:(NSInteger)num{
    UIScrollView * scroView = (UIScrollView *)[self.view viewWithTag:1000];
    if (_mItemInfoArray.count < aIndex) {
        return;
    }
    //宽度小于320肯定不需要移动
    NSLog(@"+++%ld",mTotalWidth);
    if (mTotalWidth <= SCREENWIDTH - 60) {
        return;
    }
    NSDictionary *vDic = [_mItemInfoArray objectAtIndex:aIndex];
    float vButtonOrigin = [[vDic objectForKey:TOTALWIDTH] floatValue];
    NSLog(@"%f",vButtonOrigin);
    if (vButtonOrigin >= 100) {
        if ((vButtonOrigin + 120) >= mTotalWidth) {
            [scroView setContentOffset:CGPointMake(scroView.contentSize.width - SCREENWIDTH, scroView.contentOffset.y) animated:YES];
            return;
        }
        float vMoveToContentOffset;
        if (num == 1) {
            vMoveToContentOffset = vButtonOrigin - 120;
        }else{
            vMoveToContentOffset = vButtonOrigin - 70;
        }
        
        if (vMoveToContentOffset > 0) {
            [scroView setContentOffset:CGPointMake(vMoveToContentOffset, scroView.contentOffset.y) animated:YES];
        }
        //        NSLog(@"scrollwOffset.x:%f,ButtonOrigin.x:%f,mscrollwContentSize.width:%f",mScrollView.contentOffset.x,vButtonOrigin,mScrollView.contentSize.width);
    }else{
        [scroView setContentOffset:CGPointMake(0, scroView.contentOffset.y) animated:YES];
        return;
    }
}

#pragma mark - 滚动视图的点击事件 yd
-(void)tap1:(UITapGestureRecognizer *)tap{
    
    UIView * view = tap.view;
    [view isFirstResponder];
    UIButton *btn =view.subviews[0];
    
    self.scrollViewFirBtn.selected=NO;
    btn.selected =YES;
    self.scrollViewFirBtn =btn;
    
    UIButton *btn2 =view.subviews[1];
    
    self.scrollViewSecBtn.selected=NO;
    btn2.selected =YES;
    self.scrollViewSecBtn =btn2;
    NSLog(@"%ld",(long)tap.view.tag);//根据tag刷新数据
    
    if (_weekTimeCount < tap.view.tag - VIEW_TAG) {
        _weekTimeCount = tap.view.tag - VIEW_TAG;
        [self moveScrolViewWithIndex:_weekTimeCount Left_or_Right:1];
        
    }else{
        _weekTimeCount = tap.view.tag - VIEW_TAG;
        [self moveScrolViewWithIndex:_weekTimeCount Left_or_Right:0];
    }
    
    DateModel *model = [_dateArray objectAtIndex:tap.view.tag - VIEW_TAG];
    count = tap.view.tag - VIEW_TAG;
    if ([_date isEqualToString:model.date]) {
        return;
    }
    _date = model.date;
    if (model.click) {
        
        [self downRequest];
    }else{
        [self showAlertViewWith:@"抱歉，当天没有设置营业时间"];
        [_timeArr removeAllObjects];
        [self.collectionView reloadData];
    }
    
}

#pragma mark - createCollectionView
-(void)createUI{
    NSInteger width = (SCREENWIDTH-48) /4 ;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 6.0f;// 行间距
    layout.minimumLineSpacing = 6.0f;//列间距
    layout.itemSize = CGSizeMake( width , width*((CGFloat)42.5f/(CGFloat)68.f));//控制item的宽高比
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 15);
    
#define ydcolor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
    
    
    // xib创建collectionView
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.backgroundColor =[UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SSTSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ssts"];
}

#pragma mark - collectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _timeArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //TimeModel *model;
    TimeModel *model = [_timeArr objectAtIndex:indexPath.item];
    
    SSTSCollectionViewCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"ssts" forIndexPath:indexPath];
    // set和get要注意一下
    item.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.start,model.end];
    if (model.hold) {
        if (model.hold == 1) {
            item.bgImage.image = [UIImage imageNamed:@"timer_bgfull.png"];
            item.timeLabel.textColor = UIColorFromRGB(0x666666);
        }else{
            item.bgImage.image = [UIImage imageNamed:@"elt_sels.png"];
            item.timeLabel.textColor = [UIColor whiteColor];
        }
    }else{
        item.bgImage.image = [UIImage imageNamed:@"timer_bg.png"];
        item.timeLabel.textColor = UIColorFromRGB(0x666666);
    }
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TimeModel *selectTime = [_timeArr objectAtIndex:indexPath.item];
    if (selectTime.hold == 0) {
        selectTime.hold = 2;
    }else if (selectTime.hold == 2){
        selectTime.hold = 0;
    }else{
        return;
    }
    
    //对本地数据进行操作
    int i = 0;
    int j = 0;
    
    if (!_allArray.count || _allArray.count == 0) {//排期表里没有数据
        
        NSMutableArray *timeArray = [NSMutableArray array];
        NSDictionary *timeDic = [self getObjectData:selectTime];
        [timeArray addObject:timeDic];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_date forKey:@"date"];
        [dic setObject:timeArray forKey:@"day"];
        [_allArray addObject:dic];
        
    }else{
    
        for (; i < _allArray.count; i++) {
            NSMutableDictionary *dateDic = [NSMutableDictionary dictionaryWithDictionary:[_allArray objectAtIndex:i]];
            if ([[dateDic objectForKey:@"date"] isEqualToString:_date]) {//数据库里有这天
            
                NSMutableArray *timeArray = [NSMutableArray arrayWithArray:[dateDic objectForKey:@"day"]];
                for (; j<timeArray.count; j++) {
                    NSDictionary *timeDic = [timeArray objectAtIndex:j];
                    if ([[timeDic objectForKey:@"start"] isEqualToString:selectTime.start]) {
                        [timeArray removeObject:timeDic];
                        break;
                    }
                    if (j == timeArray.count - 1) {
                        NSDictionary *DIC = [self getObjectData:selectTime];
                        [timeArray addObject:DIC];
                        break;
                    }
                }
                [dateDic setObject:timeArray forKey:@"day"];
                [_allArray replaceObjectAtIndex:i withObject:dateDic];
                break;
            }
            if (i == _allArray.count - 1) {//meiyougaidianpu
                NSMutableArray *timeArray = [NSMutableArray array];
                NSDictionary *dict = [self getObjectData:selectTime];
                [timeArray addObject:dict];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:_date forKey:@"date"];
                [dic setObject:timeArray forKey:@"day"];
                [_allArray addObject:dic];
                break;
            }
        }
    }
    NSLog(@"%@",_allArray);
    [self.collectionView reloadData];
}

- (IBAction)leftBtn:(id)sender{
    UIScrollView * scroView = (UIScrollView *)[self.view viewWithTag:1000];
    CGFloat x = scroView.contentOffset.x;
    [UIView animateWithDuration:1 animations:^{
        scroView.contentOffset = CGPointMake(x-scrollViewSepWidth, 0);
        
        
        if (scroView.contentOffset.x < 0) {
            scroView.contentOffset = CGPointMake(0, 0);
        }
    }];
    [self left_or_rightBtn:@"left" andTag:_weekTimeCount];
}

- (IBAction)rightBtn:(id)sender{
    UIScrollView * scroView = (UIScrollView *)[self.view viewWithTag:1000];
    CGFloat x = scroView.contentOffset.x;
    [UIView animateWithDuration:1 animations:^{
        scroView.contentOffset = CGPointMake(x+scrollViewSepWidth, 0);
        if (scroView.contentOffset.x > (scroView.contentSize.width - scrollViewSepWidth * 4)) {
            scroView.contentOffset = CGPointMake(scroView.contentSize.width - scrollViewSepWidth * 4.5, 0);
        }
    }];
    [self left_or_rightBtn:@"right" andTag:_weekTimeCount];
}

- (void)left_or_rightBtn:(NSString *)left_or_right andTag:(NSInteger)tag{
    UIScrollView * scroView = (UIScrollView *)[self.view viewWithTag:1000];
    UIView * view;
    if ([left_or_right isEqualToString:@"left"] && tag != 0) {
        view = [scroView viewWithTag:tag - 1 + VIEW_TAG];
        [view isFirstResponder];
        UIButton *btn =view.subviews[0];
        
        self.scrollViewFirBtn.selected=NO;
        btn.selected =YES;
        self.scrollViewFirBtn =btn;
        
        UIButton *btn2 =view.subviews[1];
        
        self.scrollViewSecBtn.selected=NO;
        btn2.selected =YES;
        self.scrollViewSecBtn =btn2;
        
        [self moveScrolViewWithIndex:view.tag Left_or_Right:0];
        
        //清除保存的数据
        [_timeArr removeAllObjects];
        //保存当前点击的下标
        _weekTimeCount = tag - 1;
        self.indicator = [[ActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, _collectionView.frame.size.height) LabelText:@"正在加载..." withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
        [self.indicator startAnimatingActivit];
        _collectionView.contentOffset = CGPointMake(0, 0);
        [_collectionView addSubview:self.indicator];
        DateModel *model = [_dateArray objectAtIndex:_weekTimeCount];
        _date = model.date;
        [self downRequest];
    }
    if ([left_or_right isEqualToString:@"right"] && tag != 6) {
        view = [scroView viewWithTag:tag + 1 + VIEW_TAG];
        [view isFirstResponder];
        UIButton *btn =view.subviews[0];
        
        self.scrollViewFirBtn.selected=NO;
        btn.selected =YES;
        self.scrollViewFirBtn =btn;
        
        UIButton *btn2 =view.subviews[1];
        
        self.scrollViewSecBtn.selected=NO;
        btn2.selected =YES;
        self.scrollViewSecBtn =btn2;
        
        [self moveScrolViewWithIndex:view.tag Left_or_Right:1];
        //清除保存的数据
        [_timeArr removeAllObjects];
        //保存当前点击的下标
        _weekTimeCount = tag + 1;
        self.indicator = [[ActivityIndicator alloc]initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, _collectionView.frame.size.height) LabelText:@"正在加载..." withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
        [self.indicator startAnimatingActivit];
        _collectionView.contentOffset = CGPointMake(0, 0);
        [_collectionView addSubview:self.indicator];
        DateModel *model = [_dateArray objectAtIndex:_weekTimeCount];
        _date = model.date;
        [self downRequest];
    }
    
    
    NSLog(@"%ld",_weekTimeCount);
}

-(void)downRequest{
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getShopPersonTimeRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if ([objc isKindOfClass:[NSString class]]) {
            [self showAlertViewWith:objc];
            return ;
        }
        _timeArr = objc;
        [self judgeArray];
        [self.collectionView reloadData];
    } andShoppe_id:_shopId andSerper_id:_peopleID andDate:_date];
    
}

//将本地存储的时间与请求下来的进行对比
-(void)judgeArray{
    
    
    if (!_allArray.count || _allArray.count == 0) {//排期表里没有数据
        
        NSMutableArray *timeArray = [NSMutableArray array];
        for (TimeModel *timeModel in _timeArr) {
            if (timeModel.hold == 2) {
                NSDictionary *timeDic = [self getObjectData:timeModel];
                [timeArray addObject:timeDic];
            }
        }
        if (!timeArray.count) {
            return;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_date forKey:@"date"];
        [dic setObject:timeArray forKey:@"day"];
        [_allArray addObject:dic];
        
    }else{
        
        int i = 0;
        for (; i < _allArray.count; i++) {
            NSDictionary *dateDic = [_allArray objectAtIndex:i];
            if ([[dateDic objectForKey:@"date"] isEqualToString:_date]) {//数据库里有这天
                
                [self compare:dateDic];
                
                break;
            }
            if (i == _allArray.count - 1) {//数据库里没有这一天
                
                NSMutableArray *timeArray = [NSMutableArray array];
                for (TimeModel *timeModel in _timeArr) {
                    if (timeModel.hold == 2) {
                        NSDictionary *timeDic = [self getObjectData:timeModel];
                        [timeArray addObject:timeDic];
                    }
                }
                if (!timeArray.count) {
                    break;
                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:_date forKey:@"date"];
                [dic setObject:timeArray forKey:@"day"];
                [_allArray addObject:dic];
                break;
            }
        }
    }
}


-(void)compare:(NSDictionary *)dic{
    
    NSArray *array = [dic objectForKey:@"day"];
    int i = 0,j = 0;
    for (; i < array.count; i++) {//将本地的和请求下来进行对比，加入本地有而请求没有的
        NSDictionary *timeDic = [array objectAtIndex:i];
       j = 0;
        for(;j < _timeArr.count;j++){
            TimeModel *time = [_timeArr objectAtIndex:j];
            if ([[timeDic objectForKey:@"start"] isEqualToString:time.start]) {
                if (time.hold == 2) {
                    break;
                }else{
                    time.hold = 2;
                    break;
                }
            }
        }
    }
    
    i = 0;
    j = 0;
    
    for (; i < _timeArr.count; i++) {//将请求的和本地的进行对比，删除本地没有而请求有的
        TimeModel *time = [_timeArr objectAtIndex:i];
        j = 0;
        for (; j < array.count; j++) {
            NSDictionary *timeDic = [array objectAtIndex:j];
            if ([[timeDic objectForKey:@"start"] isEqualToString:time.start]) {
                break;
            }
            if (j == array.count - 1) {
                if (time.hold == 1) {
                    return;
                }else{
                    time.hold = 0;
                    break;
                }
            }
        }
    }
}

- (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

@end
