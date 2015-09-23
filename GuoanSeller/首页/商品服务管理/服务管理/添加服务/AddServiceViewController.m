//
//  AddServiceViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/10.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#define SERVICEFAVORABLEPRICE @"优惠价格"

#import "AddServiceViewController.h"
#import "AddCommodityTableViewCell.h"
#import "DropDownMenuView.h"
#import "ShowModel.h"
#import "StaffSelectViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "LxGridView.h"
#import "Example2CollectionViewCell.h"
#import "ClassificationModel.h"
#import "CommodityDetailModel.h"
#import "AppDelegate.h"


#define kPhotoName              @"headImage.jpg"
#define kImageCachePath         @"imagecache"
#define kImageBinary            @"imageBinary.plist"
#define kImageBlinarykey        @"HeadImage"

#define ORIGINAL_MAX_WIDTH 640.0f
#define CELL_TAG 856422222
#define CELL_PULLDOWNBTN_TAG 11111
#define DROPMENU_TAG 22222
static NSString * const LxGridViewCellReuseIdentifier = @stringify(LxGridViewCellReuseIdentifier);
@interface AddServiceViewController ()<ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate,LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate,AddCommodityTableViewCellDelegate,UITextFieldDelegate,DropDownMenuViewDelegate>{
    NSArray *_nameArray;
    DropDownMenuView *_dropView;
    LxGridViewFlowLayout * _gridViewFlowLayout;
    
    BOOL _isShowDropMenu;
    BOOL _isShowDropMenu1;
    UIToolbar * toolbar;
    UIToolbar * toolbar1;
    UIButton * item0;
    UIButton * item00;
        UIButton * item1;
    UILabel * item2;
    UIButton * item3;
    
    UILabel * item22;
    UIButton * item33;
    
    UIDatePicker *datePicker;
    UIPickerView *pickerview;
    NSArray *pickerArr;
    NSString * task;

}

@property (nonatomic, strong) LxGridView * gridView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;
@property (nonatomic, strong) NSMutableDictionary * typeDic;


@property (nonatomic,assign)  BOOL isReusable;// 复用问题
@property (nonatomic,assign) BOOL is_self;//修改 自营还是扫码
@property (nonatomic,strong) DropDownMenuView *currrentDropDownMenuView;
@property (nonatomic,strong) UIButton *currentSelectedBtn;//当前选中的两个button yd
@property (nonatomic,strong) CommodityDetailModel * commodityDetaiModel;//商品详情的数据源
@end

@implementation AddServiceViewController
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
//    [self hiddenCustomTabBar];
}
//图片数据源
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Do any additional setup after loading the view from its nib.
    [ELTRefreshSingleton refreshIsOK].state = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _typeDic = [NSMutableDictionary dictionary];
    [self setupUI];
    self.bgTable.backgroundColor = UIColorFromRGB(0xf1f1f1);
    if (_isAddCommodity) {
        self.navbar.titleLabel.text = @"添加服务";
    }
    else{
        self.navbar.titleLabel.text = @"服务详情";
    }
    _nameArray = @[@"服  务  名",@"分       类",@"单       价",SERVICEFAVORABLEPRICE,@"起算时间",@"人       员",@"状       态"];
    self.bottomBtn.layer.cornerRadius = 5.0;
    [self.navbar.homebtn setTitle:@"完成" forState:UIControlStateNormal];
    self.indicator.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT);
    if(!_isAddCommodity){
        [self downRequest];
    }
    else{
        [self.bgTable reloadData];
    }
}
#pragma mark - 修改商品时商品的数据
- (void)downRequest{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getCommodityDetailWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            self.commodityDetaiModel = objc;
            
            if ([self.commodityDetaiModel.serviceper isEqualToString:@""]) {
                [self.arr addObject:self.commodityDetaiModel.serviceper];
            }else{
                NSString * servicePersonsSelected = self.commodityDetaiModel.serviceper;
                NSArray * perArr = [servicePersonsSelected componentsSeparatedByString:@","];
                NSMutableArray * personsArr = [NSMutableArray arrayWithArray:perArr];
                [personsArr removeObject:@""];
                self.arr = personsArr;
            }
            NSString * servicePersonsSelected = self.commodityDetaiModel.serviceper;
            NSArray * perArr = [servicePersonsSelected componentsSeparatedByString:@","];
            NSMutableArray * personsArr = [NSMutableArray arrayWithArray:perArr];
            [personsArr removeObject:@""];
            self.arr = personsArr;
            
            
            for (int i = 0; i < (self.commodityDetaiModel.show.count > 4 ? 4 : self.commodityDetaiModel.show.count); i++) {
                [self.assets addObject:self.commodityDetaiModel.show[i]];
            }
            [_typeDic setObject:self.commodityDetaiModel.service_type_id forKey:@"auto_code"];
            [_typeDic setObject:self.commodityDetaiModel.content_shelf_status forKey:@"type"];
            [self.bgTable reloadData];
            [_gridView reloadData];
        }
        else{
            [self.bgTable.footer endRefreshing];
            [self.bgTable.header endRefreshing];
            self.bgTable.footer.hidden = YES;
//            [self showAlertViewWith:objc];
        }
    } andCommodity_id:self.commodity_id andTask:@"serveinfo"];
    
}
#pragma mark - 选择照片相关方法

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

#pragma mark setup UI
- (void)setupCollectionView{
    _gridViewFlowLayout = [[LxGridViewFlowLayout alloc]init];
    _gridViewFlowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _gridViewFlowLayout.minimumLineSpacing = 9;
    CGFloat width = (SCREENWIDTH - 75) / 4;
    _gridViewFlowLayout.itemSize = CGSizeMake(width, width);
    _gridViewFlowLayout.isEdited = YES; //yd

    _gridView = [[LxGridView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, width + 30) collectionViewLayout:_gridViewFlowLayout];
    _gridView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    /**
     *  编辑功能开启
     */
    
    _gridView.editing = YES; // yd
    //    _gridView.scrollEnabled = NO;
    _gridView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:_gridView];
    
    
    [_gridView registerNib:[UINib nibWithNibName:@"Example2CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Example2CollectionViewCell"];
    
    [_gridView registerClass:[LxGridViewCell class] forCellWithReuseIdentifier:LxGridViewCellReuseIdentifier];
    
    //    _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _homeButton.showsTouchWhenHighlighted = YES;
    //    _homeButton.layer.cornerRadius = HOME_BUTTON_RADIUS;
    //    _homeButton.layer.masksToBounds = YES;
    //    _homeButton.layer.borderWidth = 1;
    //    _homeButton.layer.borderColor = [UIColor blackColor].CGColor;
    //    _homeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [_homeButton setTitle:@"☐" forState:UIControlStateNormal];
    //    [_homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_homeButton];
    
    _gridView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}
#pragma LxGridViewDelegate
- (void)homeButtonClicked:(UIButton *)btn
{
//    _gridView.editing = NO;
//    _gridView.editing = YES;//yd

}

- (void)setupButtons{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStyleDone target:self action:@selector(selectPhotos)];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.assets.count < 4){
        return self.assets.count+1;
    }else{
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.item == self.assets.count) {
        Example2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Example2CollectionViewCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"addgoodsbtn"];
        //        [UIImage ml_imageFromBundleNamed:@"addgoodsbtn.png"];
        
        
        return cell;
    }else{
        LxGridViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:LxGridViewCellReuseIdentifier forIndexPath:indexPath];
        // 判断类型来获取Image
        ZLPhotoAssets *asset = self.assets[indexPath.item];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            cell.iconImageView.image = asset.thumbImage;
        }else if ([asset isKindOfClass:[NSString class]]){
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"pc_circle_placeholder"]];
        }else if([asset isKindOfClass:[UIImage class]]){
            cell.iconImageView.image = (UIImage *)asset;
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            cell.iconImageView.image = [asset thumbImage];
        }
        cell.delegate = self;
        cell.tag = indexPath.item;
        cell.isEdited = YES;
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary * dataDict = self.assets[sourceIndexPath.item];
    [self.assets removeObjectAtIndex:sourceIndexPath.item];
    [self.assets insertObject:dataDict atIndex:destinationIndexPath.item];
}
#pragma mark - 删除
- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell
{
    [self.assets removeObjectAtIndex:gridViewCell.tag];
    [self.gridView reloadData];
}
#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.assets.count) {
        [self selectPhotos];
    }else{
        // 图片游览器
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        
        // 数据源/delegate
        // 动画方式
        /*
         *
         UIViewAnimationAnimationStatusZoom = 0,  放大缩小
         UIViewAnimationAnimationStatusFade ,  淡入淡出
         UIViewAnimationAnimationStatusRotate  旋转
         
         */
        pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
        pickerBrowser.delegate = self;
        pickerBrowser.dataSource = self;
        // 是否可以删除照片
        pickerBrowser.editing = YES;
        // 当前分页的值
        // pickerBrowser.currentPage = indexPath.row;
        // 传入组
        pickerBrowser.currentIndexPath = indexPath;
        // 展示控制器
        [pickerBrowser showPickerVc:self];
    }
}

//#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
//- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
//    return self.assets.count;
//}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return [self.assets count];
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj = [self.assets objectAtIndex:indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    LxGridViewCell *cell = (LxGridViewCell *)[self.gridView cellForItemAtIndexPath:indexPath];
    // 缩略图
    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
        photo.asset = imageObj;
    }
    photo.toView = cell.iconImageView;
    photo.thumbImage = cell.iconImageView.image;
    return photo;
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 返回自定义View
//- (ZLPhotoPickerCustomToolBarView *)photoBrowserShowToolBarViewWithphotoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser{
//    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customBtn setTitle:@"实现代理自定义ToolBar" forState:UIControlStateNormal];
//    customBtn.frame = CGRectMake(10, 0, 200, 44);
//    return (ZLPhotoPickerCustomToolBarView *)customBtn;
//}

- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row> [self.assets count]) return;
    [self.assets removeObjectAtIndex:indexPath.row];
    [_gridView reloadData];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0: { //打开照相机拍照
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                [self showAlertViewWith:@"相机权限受限"];
            }
            else{
                [self openCamera];
            }
        }
            
            break;
        case 1:  //打开本地相册
            [self openLocalPhoto];
            break;
    }
}

- (void)openCamera{
    
    
    
    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    if (self.assets.count > 4) {
        cameraVc.maxCount = 0;
    }else{
        cameraVc.maxCount = 4 - self.assets.count;
    }
    __weak typeof(self) weakSelf = self;
    cameraVc.callback = ^(NSArray *cameras){
        [weakSelf.assets  addObjectsFromArray:cameras];
        [weakSelf.gridView reloadData];
    };
    [cameraVc showPickerVc:self];
}

- (void)openLocalPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 最多能选9张图片
    if (self.assets.count > 4) {
        pickerVc.maxCount = 0;
    }else{
        pickerVc.maxCount = 4 - self.assets.count;
    }
    pickerVc.status = PickerViewShowStatusCameraRoll;
    [pickerVc showPickerVc:self];
    
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
        [weakSelf.assets addObjectsFromArray:assets];
        [weakSelf.gridView reloadData];
    };
}

#pragma mark - 选择照片
- (void)selectPhotos {
    [self showActionsheetWithPhoto];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    _gridView.editing = YES;//...yd
    
    [self.view endEditing:YES];
}

#pragma mark - 选择照片下面相关方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger cellHeight;
    switch (indexPath.section) {
        case 0:
            cellHeight = (SCREENWIDTH - 75) / 4 + 60;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellHeight = 45;
                    break;
                case 6:
                    if ([self.is_limit isEqualToString:@"1"]) {
                         cellHeight = 0.f;
                     }
                    else{
                         cellHeight = 27.f;
                    }
                    break;
                case 7:
                    cellHeight = 33;
                    break;
                default:
                    cellHeight = 27;
                    break;
            }
            break;
        case 2:
            cellHeight = 150;
            break;

        default:
            break;
    }
    return cellHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0Xf5f5f5);
    view.alpha = 0;
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 8;
            break;
        case 2:
            num = 1;
            break;

        default:
            break;
    }
    return num;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil];
    
    if (indexPath.section == 0) {
        
        AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]firstObject];
        }
        [cell.cell_bjView addSubview:self.gridView];
        return cell;
        
    }else if(indexPath.section == 1){
    
        if (indexPath.row == 0) {
            AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCellOne"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]objectAtIndex:array.count-3];
            }
            return cell;
            
        }else if (indexPath.row == 5) {
            //                cell.inputField.placeholder = @"小时";
            AddServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddServiceTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AddServiceTableViewCell" owner:self options:nil]firstObject];
            }
            cell.tag = 4 + CELL_TAG;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            if (!_isAddCommodity) {
                cell.textField.text = self.commodityDetaiModel.service_time;//小时
                cell.textField.enabled = YES;
            }
            cell.textField.leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            //设置显示模式为永远显示(默认不显示)
            cell.textField.leftViewMode = UITextFieldViewModeAlways;
            return cell;
        }
        else{
            AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCellTwo"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]objectAtIndex:array.count-2];
            }
            cell.inputField.leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            //设置显示模式为永远显示(默认不显示)
            cell.inputField.leftViewMode = UITextFieldViewModeAlways;
            
//            cell.nameLabel.adjustsLetterSpacingToFitWidth = YES;
            cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
            
            cell.pullDownBtn.hidden = YES;
            
            //
            if (indexPath.row == 6) {
                if ([self.is_limit isEqualToString:@"1"]) {
                    cell.hidden = YES;
                }
                else{
                    cell.hidden= NO;
                }

            }
            if (indexPath.row == 3 || indexPath.row == 4) {
                cell.inputField.placeholder = @"元/小时";
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            if (indexPath.row == 2 || indexPath.row == 7  ) {
                cell.inputField.hidden = YES;
                cell.pullDownBtn.hidden = NO;
                [cell.pullDownBtn setImage:[UIImage imageNamed:@"selgo.png"] forState:UIControlStateNormal];
                cell.pullDownBtn.imageEdgeInsets = UIEdgeInsetsMake(6, SCREENWIDTH  -140 -15, 6, 6);
//                cell.pullDownBtn.imageEdgeInsets = UIEdgeInsetsMake(6, cell.pullDownBtn.frame.size.width - 15 , 6, 6);
                NSLog(@"%f",cell.pullDownBtn.frame.size.width);
                //cell.pullDownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                cell.pullDownBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }else{
                cell.pullDownBtn.hidden = YES;
                cell.inputField.hidden = NO;
                cell.inputField.delegate = self;
            }
            cell.delegate = self;
            cell.pullDownBtn.enabled = YES;
            cell.inputField.enabled = YES;
            cell.inputField.leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
            //设置显示模式为永远显示(默认不显示)
            cell.inputField.leftViewMode = UITextFieldViewModeAlways;
            if(indexPath.row == 6){
                cell.pullDownBtn.hidden = NO;
                [cell.pullDownBtn setTitle:@"" forState:UIControlStateNormal];//人员
                [cell.pullDownBtn setImage:[UIImage imageNamed:@"selgo.png"] forState:UIControlStateNormal];
                
                 cell.pullDownBtn.imageEdgeInsets = UIEdgeInsetsMake(6,  SCREENWIDTH -140 -15, 6, 6);
                cell.pullDownBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                [cell.pullDownBtn addTarget:self action:@selector(peopleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            switch (indexPath.row) {
                case 1:
                {
                    cell.tag = 1 +CELL_TAG;
                }
                    break;
                case 2:
                {
                    cell.tag = 2 + CELL_TAG;
                    cell.pullDownBtn.tag = CELL_PULLDOWNBTN_TAG + 1;
                }
                    break;
                    
                case 3:
                {
                    cell.tag = 3 + CELL_TAG;
                    cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                }
                    break;
                case 4:
                {
                    cell.tag = 7 + CELL_TAG;
                }
                    break;
                case 5:
                {
                    cell.tag = 4 + CELL_TAG;
                }
                    break;
                case 6:
                {
                    cell.pullDownBtn.tag = 6;
                    cell.tag = 5 + CELL_TAG;
                    
                }
                    break;
                    
                case 7:
                {
                    cell.tag = 6 + CELL_TAG;
                    cell.pullDownBtn.tag = CELL_PULLDOWNBTN_TAG + 2;
                    cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                }
                    break;
                default:
                    break;
            }

            //修改
#define IS_SELF(v) ([v isEqualToString:@"1"]? YES:NO)
#define IS_SELF_SEC ([self.commodityDetaiModel.is_self isEqualToString:@"1"]? YES:NO)
#define TEXTCOLORWITHNOEDITING UIColorFromRGB(0x999999)
            if (!self.isAddCommodity )//待查
            {
                switch (indexPath.row) {
                    case 1:
                    {
                        cell.inputField.text = self.commodityDetaiModel.service_name;//商品名字
                        cell.inputField.enabled = YES;
                        
                        
                    }
                        break;
                    case 2:
                    {
                        [cell.pullDownBtn setTitle:self.commodityDetaiModel.classifationName forState:UIControlStateNormal];//分类
                        cell.pullDownBtn.enabled = YES;
                        
                    }
                        break;
                        
                    case 3:
                    {
                        cell.inputField.text = self.commodityDetaiModel.unit_price;// 优惠价
                        cell.inputField.enabled = YES;
                    }
                        break;
                    case 4:
                    {
                        cell.inputField.text = self.commodityDetaiModel.promotion_price;// 优惠价
                        cell.inputField.enabled = YES;
                        
                    }
                    case 6:
                    {
 
//                        if (_arr.count!=0 ) {
//                            if (![[_arr objectAtIndex:0] isEqualToString:@""]) {
//                                [cell.pullDownBtn setTitle:@"已选择" forState:UIControlStateNormal];//人员
//                            }
//                        }
//                        else{
//                            [cell.pullDownBtn setTitle:@"" forState:UIControlStateNormal];//人员
//                        }
                        if (_arr.count) {
                            [cell.pullDownBtn setTitle:@"已选择" forState:UIControlStateNormal];//人员
                        }
                        else{
                            [cell.pullDownBtn setTitle:@"" forState:UIControlStateNormal];//人员

                        }
                        cell.pullDownBtn.enabled = YES;
                        
                    }
                        break;
                    case 7:
                    {
                        if (self.commodityDetaiModel.seaver_content_shelf ) {
                            [cell.pullDownBtn setTitle:self.commodityDetaiModel.seaver_content_shelf  forState:UIControlStateNormal]; 
                        }
                        
                        //分类
                        cell.pullDownBtn.enabled = YES;

                    }
                        break;
                    default:
                        break;
                }
            }
           
            return cell;
        
        }
    
    }else{
        AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCellThree"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]lastObject];
        }
        [cell.describeLabel  setText:@"请输入服务描述"];
        cell.delegate = self;
        cell.tag = 10 + CELL_TAG;
        cell.textView.editable = YES;
        if (self.commodityDetaiModel.content_body) {
            [cell.textView setText:self.commodityDetaiModel.content_body ]; 
            if (![cell.textView.text isEqualToString:@""]) {
                cell.describeLabel.hidden = YES;
            }
        }

        [cell.onShelfCommodityBtn setTitle:@"预览" forState:UIControlStateNormal];
        return cell;
    }
    
}
#pragma mark - 下拉菜单
-(void)pullDownBtnClick:(UIButton *)button{
    
    if (button.tag ==CELL_PULLDOWNBTN_TAG + 1) {
        DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 6];
        [ddmv1 removeFromSuperview];
        self.currentSelectedBtn = button;
        if (self.classificationDataArr.count!=0) {
            if (!_isShowDropMenu) {
                [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
                [self showDropMenu:2 andDataArr:self.classificationDataArr andHeight:150.f andDifference:5];
                _isShowDropMenu = YES;
            }else{
                [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
                
                DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
                [ddmv removeFromSuperview];
                DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 6];
                
                [ddmv1 removeFromSuperview];
                
                _isShowDropMenu = NO;
                DropDownMenuView *ddmv2 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 4];
                [ddmv2 removeFromSuperview];
                _isShowDropMenu1 = NO;
            }
            
        }
        else{
            DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
            [ddmv removeFromSuperview];
            [self.indicator setIndicatorType:ActivityIndicatorLogin];
            [self.indicator startAnimatingActivit];
            [ELRequestSingle classificationWithRequest:^(BOOL sucess, id objc) {
                [self.indicator LoadSuccess];
                self.classificationDataArr = objc;
                if (!_isShowDropMenu) {
                    [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
                    
                    CGFloat height = self.classificationDataArr.count * ADDTIONALCELLHEIGHT;
                    [self showDropMenu:2 andDataArr:self.classificationDataArr andHeight:height andDifference:5];
                    _isShowDropMenu = YES;
                }else{
                    
                    [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
                    DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
                    [ddmv removeFromSuperview];
                    DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 6];
                    [ddmv1 removeFromSuperview];
                    _isShowDropMenu = NO;
                    DropDownMenuView *ddmv2 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 4];
                    [ddmv2 removeFromSuperview];
                    _isShowDropMenu1 = NO;
                }
                
            } andShope_id:self.shop_id andTask:@"sercode"];
            
        }
        
    }
    else if (button.tag == CELL_PULLDOWNBTN_TAG + 2)
    {
        self.currentSelectedBtn = button;
        ClassificationModel *cfModel1 = [[ClassificationModel alloc]init];
        cfModel1.modules_name = @"上架";
        cfModel1.auto_code = @"1";
        ClassificationModel *cfModel2 = [[ClassificationModel alloc]init];
        cfModel2.modules_name = @"下架";
        cfModel2.auto_code = @"2";
        ClassificationModel *cfModel3 = [[ClassificationModel alloc]init];
        cfModel3.modules_name = @"不可预约";
        cfModel3.auto_code = @"3";
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:cfModel1,cfModel2,cfModel3, nil];
        if (!_isShowDropMenu1) {
            [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
            
            [self showDropMenu:7 andDataArr:arr andHeight:ADDTIONALCELLHEIGHT * 3 andDifference:5+6];
            _isShowDropMenu1 = YES;
        }else{
            
            [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
            DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 6];
            [ddmv removeFromSuperview];
            DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
            [ddmv1 removeFromSuperview];
            _isShowDropMenu1 = NO;
            DropDownMenuView *ddmv2 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 4];
            [ddmv2 removeFromSuperview];
            _isShowDropMenu1 = NO;
            
        }
        
        
    }else if (button.tag == CELL_PULLDOWNBTN_TAG + 3){
        self.currentSelectedBtn = button;
        ClassificationModel *cfModel1 = [[ClassificationModel alloc]init];
        cfModel1.modules_name = @"一小时";
        cfModel1.auto_code = @"1";
        ClassificationModel *cfModel2 = [[ClassificationModel alloc]init];
        cfModel2.modules_name = @"二小时";
        cfModel2.auto_code = @"2";
        ClassificationModel *cfModel3 = [[ClassificationModel alloc]init];
        cfModel3.modules_name = @"三小时";
        cfModel3.auto_code = @"3";
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:cfModel1,cfModel2,cfModel3, nil];
        if (!_isShowDropMenu1) {
            [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
            
            [self showDropMenu:4 andDataArr:arr andHeight:ADDTIONALCELLHEIGHT * 3 andDifference:5];
            _isShowDropMenu1 = YES;
        }else{
            
            [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
            DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 6];
            [ddmv removeFromSuperview];
            DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
            [ddmv1 removeFromSuperview];
            _isShowDropMenu1 = NO;
            DropDownMenuView *ddmv2 = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 4];
            [ddmv2 removeFromSuperview];
            _isShowDropMenu1 = NO;
            
        }
    }
}
-(void)showDropMenu:(NSInteger)row andDataArr:(NSMutableArray*)dataArr andHeight:(CGFloat)height1 andDifference:(NSInteger)difference{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
    CGRect rectInTableView = [self.bgTable rectForRowAtIndexPath:path];
    CGRect rectInSuperview = [self.bgTable convertRect:rectInTableView toView:self.view];//在某个view上计算frame
    
    DropDownMenuView *dropMent1 = [DropDownMenuView instanceView:nil];
    dropMent1.dropDownMenuViewType = DropDownMenuViewRemoveAll;
    dropMent1.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    dropMent1.topConstraint.constant = CGRectGetMaxY(rectInSuperview)-difference;
    dropMent1.tableviewLeftConstraint.constant = 108+1;
    dropMent1.tableviewRightConstraint.constant = 30 + 1;
    dropMent1.dataArr = dataArr;
    dropMent1.delegate = self;
     dropMent1.tag = DROPMENU_TAG + row;
    dropMent1.currentBtnblock = ^(BOOL isDrop){
        if (isDrop) {
            [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
            _isShowDropMenu = NO;
        }
    };
    [self.view addSubview:dropMent1];
    self.currrentDropDownMenuView = dropMent1;
}
-(void)didSelectRowAtIndexPathWithText:(NSString *)text andAuto_code:(NSString *)auto_code{
    
    NSMutableDictionary * currentdic;
    NSMutableDictionary * dic;
    if (self.currentSelectedBtn.tag == CELL_PULLDOWNBTN_TAG + 1) {
        [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
        
        [self.currentSelectedBtn setTitle:text forState:UIControlStateNormal];
        DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 2];
        [ddmv removeFromSuperview];
        _isShowDropMenu = NO;
        currentdic = [NSMutableDictionary dictionaryWithObject:auto_code forKey:@"auto_code"];// 存储分类的分类编码
        [_typeDic setObject:auto_code forKey:@"auto_code"];
//        _commodityDetaiModel.auto_code = auto_code;
    }else if (self.currentSelectedBtn.tag ==CELL_PULLDOWNBTN_TAG + 2){
        [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
        
        [self.currentSelectedBtn setTitle:text forState:UIControlStateNormal];
        DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 7];
        [ddmv removeFromSuperview];
        _isShowDropMenu1 = NO;
        dic = [NSMutableDictionary dictionaryWithObject:auto_code forKey:@"type"];// 存储状态的标示
                [_typeDic setObject:auto_code forKey:@"type"];
//        _commodityDetaiModel.content_shelf_status = auto_code;
    }else if (self.currentSelectedBtn.tag ==CELL_PULLDOWNBTN_TAG + 3){
        [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
        
        [self.currentSelectedBtn setTitle:text forState:UIControlStateNormal];
        DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:DROPMENU_TAG + 4];
        [ddmv removeFromSuperview];
        _isShowDropMenu1 = NO;
        dic = [NSMutableDictionary dictionaryWithObject:auto_code forKey:@"time"];// 存储时间的标示
        [_typeDic setObject:auto_code forKey:@"time"];
    }
}
#pragma mark - 选择人员点击事件
- (void)peopleBtnClicked:(id)sender{
    UIButton * btn = sender;
    StaffSelectViewController *view = [[StaffSelectViewController alloc]init];
    view.shoppe_id = self.shop_id;
    view.seleceBtnArr = self.arr;
    view.isAdd = YES;
//    __weak typeof(self) weakSelf = self;
    view.block = ^(NSMutableArray * arr){
        if (arr.count) {
            [btn setTitle:@"已选择" forState:UIControlStateNormal];
        }
        else{
        
            [btn setTitle:@"" forState:UIControlStateNormal];
            
        }
        
        self.arr = arr;
//        [self.bgTable reloadData];
    };
    [self.navigationController pushViewController:view animated:YES];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 上传照片
-(void)home:(id)sender{
    self.indicator.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT - NAVHEIGHT);
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    //上传图片
    NSMutableArray * imgArr = [NSMutableArray array];
    NSMutableDictionary * imgDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.assets.count; i++) {
        UIImage * modify_image;
        // 判断类型来获取Image
        ZLPhotoAssets *asset = self.assets[i];
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            modify_image = asset.thumbImage;
        }else if ([asset isKindOfClass:[NSString class]]){
            [imgArr addObject:asset];
        }else if([asset isKindOfClass:[UIImage class]]){
            modify_image = (UIImage *)asset;
        }else if ([asset isKindOfClass:[ZLCamera class]]){
            modify_image = [asset thumbImage];
        }
        if (![asset isKindOfClass:[NSString class]]) {
            [imgDic setObject:modify_image forKey:[NSString stringWithFormat:@"content_img_%d",i+1]];
        }
    }
    
    [ELHttpRequestOperation getTokenAndTime];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",HTTP,@"&method=save&app_com=com_appcenter&task=uploadimg"];
    ELHttpRequestOperation *sharedClient = nil;
    sharedClient = [ELHttpRequestOperation manager];
    [sharedClient setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [sharedClient setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [[sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [sharedClient POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSArray * valueArr = [imgDic allValues];
        NSArray * keyArr = [imgDic allKeys];
        for(int i = 0 ;i<keyArr.count; i++){
            [formData appendPartWithFileData:UIImagePNGRepresentation(valueArr[i]) name:keyArr[i] fileName:[NSString stringWithFormat:@"%@.png",keyArr[i]]  mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self.indicator LoadSuccess];
        JSONDecoder * json = [[JSONDecoder alloc]init];
        NSDictionary * dic1 = [json objectWithData:responseObject];
        NSLog(@"%@",[dic1 objectForKey:@"msg"]);
        if ([[dic1 objectForKey:@"status"] integerValue] == 1) {
            [imgArr addObjectsFromArray:[dic1 objectForKey:@"datalist"]];
        }
        [self downRequestDic:imgArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self showAlertViewWith:error.localizedDescription];
    }];
    
}
- (void)downRequestDic:(NSMutableArray *)imgArr{
//    img[]	String	N	图片路径
    //   sev[service_name]	String		商品名
    AddCommodityTableViewCell * content_name_cell = (AddCommodityTableViewCell *)[self.bgTable viewWithTag:1 + CELL_TAG];
    //   sev[unit_price]	string		商品价格
    AddCommodityTableViewCell * content_price_cell = (AddCommodityTableViewCell *)[self.bgTable viewWithTag:3 + CELL_TAG];
    //   sev[promotion_price]	string		促销价格
    AddCommodityTableViewCell * promotion_price = (AddCommodityTableViewCell *)[self.bgTable viewWithTag:7 + CELL_TAG];
    //   sev[time]	string		商品价格
    AddServiceTableViewCell * time_cell = (AddServiceTableViewCell *)[self.bgTable viewWithTag:4 + CELL_TAG];
    
    AddCommodityTableViewCell *content_body_cell = (AddCommodityTableViewCell *)[self.bgTable viewWithTag:10 + CELL_TAG];
    NSString * content_bodyStr = content_body_cell.textView.text;
    
    NSNumber * content_shelf_cellNum = [NSNumber numberWithInt:[[_typeDic objectForKey:@"type"] intValue]];
    
    
    NSNumber * auto_code_cellNum = [NSNumber numberWithInt:[[_typeDic objectForKey:@"auto_code"] intValue]];
    NSNumber * time_cellNum = [NSNumber numberWithInt:[time_cell.textField.text intValue]];
    
//    NSNumber * preprice = [NSNumber numberWithInt:[[self textFieldSpeca:content_preprice_cell.inputField.text] doubleValue]];
    NSNumber * member_idNum = [NSNumber numberWithInt:[NSUserDefaults_Member_id intValue]];//卖家id
    
    NSLog(@"NSUserDefaults_Member_id:%@,member_idNum:%@",NSUserDefaults_Member_id,member_idNum);
    NSNumber * shop_idNum = [NSNumber numberWithInt:[self.shop_id intValue]];//店铺id
    
    NSNumber * product_idNum = [NSNumber numberWithInt:[self.commodity_id intValue]];//商品表ID
    
    
    NSString * serviceperStr = @",";
    if ([self.is_limit isEqualToString:@"1"]) {
        NSMutableArray * personArr = [NSMutableArray arrayWithObject:@"all"];
        _arr = personArr;
    }
    for (NSString * str in _arr) {
        serviceperStr = [[serviceperStr stringByAppendingString:str] stringByAppendingString:@","];
    }
    
   
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [self textFieldSpeca:content_name_cell.inputField.text],@"sev[service_name]",// 1.商品名
                                 auto_code_cellNum,@"sev[service_type_id]",//2.分类编码
                                 [self textFieldSpeca:content_price_cell.inputField.text],@"sev[unit_price]",
                                 content_shelf_cellNum,@"sev[content_shelf]",//8.上下架类 // 2.7
                                 [self textFieldSpeca:promotion_price.inputField.text],@"sev[promotion_price]",
                                 time_cellNum,@"sev[service_time]",// 9.时间
                                 serviceperStr,@"sev[serviceper]",
                                 content_bodyStr,@"sev[content_body]",
                                 nil
                                 ];
    
    
    
    
#pragma mark - 判断yd
    if (_isAddCommodity) {//添加时的字段
        
        if (self.assets.count== 0) {
            [self showAlertViewWith:@"请选择图片"];
            return;
        }
        [dic addEntriesFromDictionary:@{@"sev[eshop_id]":shop_idNum,// e店id
                                        @"sev[personal_id]":member_idNum// 卖家id
                                        }];
            task = @"addserve";
        
    }else{//修改时的字段
        if (self.assets.count == 0&&imgArr.count == 0){
            [self showAlertViewWith:@"请选择图片"];
            return;
        }
        
        [dic addEntriesFromDictionary:@{@"sev[personal_id]":member_idNum,
                                        @"sev[eshop_id]":shop_idNum,
                                        @"service_id":product_idNum
                                        }];
            task = @"editserve";
    }
    
    for (int i = 1; i < imgArr.count+1; i++) {
        [dic setObject:imgArr[i - 1] forKey:[NSString stringWithFormat:@"img[%d]",i]];
    }
    NSLog(@"%@",dic);
//    if([promotion_price.inputField.text isEqualToString:@""]){
//        [self showAlertViewWith:@"请输入促销价格"];
//        return;
//    }
 
    for (NSInteger i=1; i<7; i++) {
        AddCommodityTableViewCell *cell = (AddCommodityTableViewCell*)[self.bgTable viewWithTag:CELL_TAG+ i];
        AddServiceTableViewCell *cell1 = (AddServiceTableViewCell*)[self.bgTable viewWithTag:CELL_TAG+ i];
        switch (cell.tag) {
            case CELL_TAG+ 1:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入服务名称"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 2:
            {
                if ([[NSString stringWithFormat:@"%@",dic[@"sev[service_type_id]"]] isEqualToString:@"0"]) {
                    [self showAlertViewWith:@"请输入服务分类"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 3:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入服务单价"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 4:
            {
                
                 AddCommodityTableViewCell *cell = (AddCommodityTableViewCell*)[self.bgTable viewWithTag:CELL_TAG+ 7];
                    if ([cell.inputField.text isEqualToString:@""]) {
                        [self showAlertViewWith:[NSString stringWithFormat:@"请输入%@",SERVICEFAVORABLEPRICE]];
                        return;
                    }
            
                if ([cell1.textField.text  isEqualToString:@""]) {
                    
                    [self showAlertViewWith:@"请输入起算时间"];
                    return;
                }
                else if([cell1.textField.text doubleValue] > [@"6" doubleValue]){
                    [self showAlertViewWith:@"起算时间最长为6小时"];
                    return;
                }
                else{
                    
                }
                
            }
                break;
            case CELL_TAG+ 5:
            {
                if (self.isAddCommodity?_arr==nil :_arr.count == 0) {//判断某个对象为nil
                    [self showAlertViewWith:@"请选择服务人员"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 6:
            {
                if ([[NSString stringWithFormat:@"%@",dic[@"sev[content_shelf]"]] isEqualToString:@"0"]) {
                    [self showAlertViewWith:@"请输入服务状态"];
                    return;
                }
            }
                break;
            default:
                break;
        }
    }
    if ([content_bodyStr isEqualToString:@""]) {
        [self showAlertViewWith:@"请输入服务介绍"];
        return;
    }
    else{
        [self uploadCommodity:dic];
    }
    
    
}
-(void)uploadCommodity:(NSMutableDictionary *)dicArr{
    
    [ELRequestSingle changeSelfCommodityWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            
            [ELTRefreshSingleton refreshIsOK].state = YES;
            [ELTRefreshSingleton refreshIsOK].state = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
//            [self.view makeToast:objc]; 
            [self showAlertViewWith:objc];
        }
    } andTask:task andParameters:dicArr];
}
- (NSString *)textFieldSpeca:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)bottomClick:(id)sender {
}
#pragma  mark - 隐藏tabbar的暂时方法
- (void)hiddenCustomTabBar{
    UIApplication * applictaino = [UIApplication sharedApplication];
    AppDelegate  * delegate = applictaino.delegate;
    delegate.tab.tabBar.bounds = CGRectMake(0, 0, 0, 0);
}
@end
