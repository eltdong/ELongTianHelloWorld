//
//  AddCommodityViewController.m
//  GuoanSeller
//
//  Created by elongtian on 15/8/8.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#define COMMODITYWORD1 @"商品名"
#define COMMODITYWORD1 @"商品名"
#define COMMODITYWORD1 @"商品名"
#define COMMODITYWORD1 @"商品名"


#import "AddCommodityViewController.h"
#import "AddCommodityTableViewCell.h"
#import "AddServiceTableViewCell.h"
#import "DropDownMenuView.h"
#import "Example2CollectionViewCell.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "LxGridView.h"
#import "FileUtil.h"
#import "UIImage+Expland.h"
#import "ClassificationModel.h"
#import "CommodityDetailModel.h"
#import "ShowModel.h"
#import "AppDelegate.h"
#define CELL_TAG 8564222

#define kPhotoName              @"headImage.jpg"
#define kImageCachePath         @"imagecache"
#define kImageBinary            @"imageBinary.plist"
#define kImageBlinarykey        @"HeadImage"

#define ORIGINAL_MAX_WIDTH 640.0f
static NSString * const LxGridViewCellReuseIdentifier = @stringify(LxGridViewCellReuseIdentifier);

//static CGFloat const HOME_BUTTON_RADIUS = 21;
//static CGFloat const HOME_BUTTON_BOTTOM_MARGIN = 9;
@interface AddCommodityViewController ()<UITableViewDataSource,UITableViewDelegate,AddCommodityTableViewCellDelegate,DropDownMenuViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate,LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate>{
    NSArray *_nameArray;
    DropDownMenuView *_dropView;
    LxGridViewFlowLayout * _gridViewFlowLayout;
    UIButton * _homeButton;
    BOOL _isShowDropMenu;
    BOOL _isShowDropMenu1;
    NSMutableDictionary * _typeDic;
}
@property (nonatomic,assign) NSInteger currentGridViewCellTag;
@property (nonatomic,assign)  BOOL isReusable;// 复用问题
@property (nonatomic,assign) BOOL is_self;//修改 自营还是扫码
@property (nonatomic,strong) DropDownMenuView *currrentDropDownMenuView;//当前的下拉菜单
@property (nonatomic,strong) UIButton *currentSelectedBtn;//当前选中的两个button yd
@property (nonatomic,strong)NSMutableDictionary * paraDic;
@property (nonatomic, copy) NSString * task;

@property (nonatomic, strong) LxGridView * gridView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;

@property (nonatomic,strong) CommodityDetailModel * commodityDetaiModel;//商品详情的数据源
@end

@implementation AddCommodityViewController
//图片数据源
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReusable = YES;//初始化复用
    [ELTRefreshSingleton refreshIsOK].state = NO;
    _typeDic = [NSMutableDictionary dictionary];
    _commodityDetaiModel = [[CommodityDetailModel alloc]init];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self setupUI];
    if (self.isAddCommodity) {
        [self.navbar.homebtn setImage:[UIImage imageNamed:@"scanf"]  forState:UIControlStateNormal];
    }
//    self.navbar.titleLabel.text = @"添加商品";
    self.navbar.titleLabel.text = self.navibarTitle;
    _nameArray = @[@"商  品  名",@"价       格",@"优惠价格",@"品       牌",@"分       类",@"重       量",@"保  质  期",@"商品规格",@"状      态"];
//    self.bottomBtn.layer.cornerRadius = 5.0;
    
    if (!self.isAddCommodity) {
        [self downLoadRequest];
    }
    else {
        
        self.is_self = YES;
        [self setupUI];
    }
    
}
#pragma mark - 修改商品时商品的数据
-(void)downLoadRequest{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getCommodityDetailWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        self.commodityDetaiModel = objc;
        if ([self.commodityDetaiModel.is_self isEqualToString:@"1"]) {
            self.is_self = YES;
        }
        else{
            self.is_self = NO;
        }
        NSMutableArray * photoArr = [NSMutableArray array];
        for (NSInteger i=0; i<self.commodityDetaiModel.show.count; i++) {
            ShowModel * show =self.commodityDetaiModel.show[i];
            [photoArr addObject:show.content_img];
        }
        for (int i = 0; i < (photoArr.count > 4 ? 4 : photoArr.count); i++) {
            [self.assets addObject:photoArr[i]];
        }
        [self setupUI];
        [self.bgTabel reloadData];
        [_gridView reloadData];
    } andCommodity_id:self.commodity_id andTask:@"proinfo"];
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
    if (self.is_self) {
        _gridViewFlowLayout.isEdited = YES;
    }
    else{
        _gridViewFlowLayout.isEdited = NO; //yd
    }

    CGFloat width = (SCREENWIDTH - 75) / 4;
    _gridViewFlowLayout.itemSize = CGSizeMake(width, width);
    
    _gridView = [[LxGridView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, width + 30) collectionViewLayout:_gridViewFlowLayout];
    _gridView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.backgroundColor = [UIColor whiteColor];
    _gridView.editing = YES; // yd
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
    _gridView.editing = NO;
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
        if (self.is_self) {
            
            cell.hidden = NO;
        }
        else{
            
            cell.hidden = YES;
        }
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
//        cell.editing = _gridView.editing;
        cell.tag = indexPath.item;
        cell.isEdited = YES;
        if (self.is_self) {
            _gridView.editing = YES;
            cell.isEdited = YES;
        }
        else{
            _gridView.editing =  NO;
            cell.isEdited = NO;
        }
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary * dataDict = self.assets[sourceIndexPath.item];
    [self.assets removeObjectAtIndex:sourceIndexPath.item];
    [self.assets insertObject:dataDict atIndex:destinationIndexPath.item];
}
#pragma mark - 图片删除
- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell
{
    [self.assets removeObjectAtIndex:self.currentGridViewCellTag];
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
        pickerBrowser.editing = NO;
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
    
//    UIApplication * applictaino = [UIApplication sharedApplication];
//    AppDelegate  * delegate = applictaino.delegate;
//    delegate.tab.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT+64);
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
        {
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



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    _gridView.editing = NO;
//    [self.view endEditing:YES];
//    for (UIView * view in touches.allObjects) {
//        if ([view isKindOfClass:[UITableView class]]) {
//            [view endEditing:YES];
//        }
//    }
//}



#pragma mark - 选择照片下面的方法
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
                case 9:
                    cellHeight = 33;
                    break;
                default:
                    cellHeight = 27;
                    break;
            }
            break;
        case 2:
            cellHeight = 188.f;
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

//每个分区的页脚
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
            num = 10;
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
//        cell.cell_collectionView = self.gridView;
        [cell.cell_bjView addSubview:self.gridView];
        if (self.is_self) {
            cell.longpressAlertLabel.hidden = NO;
        }
        else{
            cell.longpressAlertLabel.hidden = YES; 
        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCellOne"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]objectAtIndex:array.count-3];
            }
            return cell;

        }else if(indexPath.row == 6){
             AddServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddServiceTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AddServiceTableViewCell" owner:self options:nil]firstObject];
            }
            cell.tag = 6 + CELL_TAG;
            [cell.name setText:[_nameArray objectAtIndex:indexPath.row-1]];
            [cell.format setText:@"g"];
            cell.textField.enabled = YES;

            if (self.is_self) {
                cell.textField.enabled = YES;
                cell.textField.textColor  = UIColorFromRGB(0x666666);
            }
            else{
                cell.textField.enabled = NO;
                cell.textField.text = self.commodityDetaiModel.weight;//小时

                cell.textField.textColor  = UIColorFromRGB(0x999999);
            }

            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
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
//            cell.nameLabel.adjustsLetterSpacingToFitWidth = YES;
            cell.nameLabel.text = [_nameArray objectAtIndex:indexPath.row-1];
            if (indexPath.row == 5 || indexPath.row == 9) {
                cell.inputField.hidden = YES;
                cell.pullDownBtn.hidden = NO;
                [cell.pullDownBtn setImage:[UIImage imageNamed:@"selgo.png"] forState:UIControlStateNormal];
                
                cell.pullDownBtn.imageEdgeInsets = UIEdgeInsetsMake(6, SCREENWIDTH  -140 -15, 6, 6);
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
            switch (indexPath.row) {
                case 1:
                {
                    cell.tag = 1 +CELL_TAG;
                }
                    break;
                case 2:
                {
                    cell.tag = 2 + CELL_TAG;
                    cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                    
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
                    cell.tag = 4 + CELL_TAG;
                    
                }
                    break;
                case 5:
                {
                    cell.pullDownBtn.tag = 5;
                    cell.tag = 5 + CELL_TAG;
                    
                }
                    break;
                    
//                case 6:
//                {
//                    cell.tag = 6 + CELL_TAG;
//                    cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
//                }
//                    break;
                    
                case 7:
                {
                    cell.tag = 7 + CELL_TAG;
                }
                    break;
                    
                case 8:
                {
                    cell.tag = 8 + CELL_TAG;
                    
                }
                    break;
                case 9:
                {
                    cell.pullDownBtn.tag = 9;
                    cell.tag = 9 + CELL_TAG;
                    
                }
                    break;
                default:
                    break;
            }

#pragma mark - 判断添加还是修改
            if (self.isAddCommodity) {//添加
                
 #define TEXTCOLORWITHNOEDITING UIColorFromRGB(0x999999)
                if (!self.is_self) {//扫码商品展示
                    
                    BOOL IS_SELF = self.is_self;
                    switch (indexPath.row) {
                        case 1:
                        {
                            
                            cell.inputField.text = self.commodityDetaiModel.content_name;//商品名字
                            
                            if (!IS_SELF) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                            
                        }
                            break;
                        case 2:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_price;//市场价
                            if (!IS_SELF) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                            
                        case 3:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_preprice;// 优惠价
                            
                        }
                            break;
                            
                        case 4:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_brand;//商品品牌
                            if (!IS_SELF) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                        case 5:
                        {
                            [cell.pullDownBtn setTitle:self.commodityDetaiModel.classifationName forState:UIControlStateNormal];//分类
                            if (!IS_SELF) {
                                cell.pullDownBtn.enabled = NO;
                                [cell.pullDownBtn setTitleColor:TEXTCOLORWITHNOEDITING forState:UIControlStateNormal];
                            }
                        }
                            break;
                            
//                        case 6:
//                        {
//                            cell.inputField.text = self.commodityDetaiModel.weight;//重量
//                            if (!IS_SELF) {
//                                cell.inputField.enabled = NO;
//                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
//                            }
//                            
//                        }
//                            break;
                            
                        case 7:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_expiration;//保质期
                            if (!IS_SELF) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                            
                        case 8:
                        {
                            cell.inputField.text = self.commodityDetaiModel.specifications;//商品规格
                            if ([cell.inputField.text isEqualToString:@""]) {
                                cell.inputField.text = @"暂无";
                            }
                            if (!IS_SELF) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                        case 9:
                        {
                            
                            [cell.pullDownBtn setTitle:self.commodityDetaiModel.content_shelf forState:UIControlStateNormal];//商品状态
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            else
            {//修改
#define IS_SELF(v) ([v isEqualToString:@"1"]? YES:NO)
#define IS_SELF_SEC ([self.commodityDetaiModel.is_self isEqualToString:@"1"]? YES:NO)
#define TEXTCOLORWITHNOEDITING UIColorFromRGB(0x999999)
                if (self.commodityDetaiModel.is_self )//待查
                {
                    self.is_self = IS_SELF_SEC;//自营还是扫码
                    switch (indexPath.row) {
                        case 1:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_name;//商品名字
                            cell.inputField.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            

                        }
                            break;
                        case 2:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_price;//市场价
                            cell.inputField.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                            
                        case 3:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_preprice;// 优惠价
                            
                        }
                            break;
                            
                        case 4:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_brand;//商品品牌
                            cell.inputField.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                        case 5:
                        {
                            [cell.pullDownBtn setTitle:self.commodityDetaiModel.classifationName forState:UIControlStateNormal];//分类
                            cell.pullDownBtn.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.pullDownBtn.enabled = NO;
                                [cell.pullDownBtn setTitleColor:TEXTCOLORWITHNOEDITING forState:UIControlStateNormal];
                            }
                        }
                            break;
                            
                        case 6:
                        {
                            cell.inputField.text = self.commodityDetaiModel.weight;//重量
                            cell.inputField.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                            
                        case 7:
                        {
                            cell.inputField.text = self.commodityDetaiModel.content_expiration;//保质期
                            cell.inputField.enabled = YES;
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                            
                        case 8:
                        {
                            cell.inputField.text = self.commodityDetaiModel.specifications;//商品规格
                            if ([cell.inputField.text isEqualToString:@""]) {
                                cell.inputField.text = @"暂无";
                            }
                            cell.inputField.enabled = YES;
                            
                            if (!IS_SELF_SEC) {
                                cell.inputField.enabled = NO;
                                cell.inputField.textColor = TEXTCOLORWITHNOEDITING;
                            }
                            
                        }
                            break;
                        case 9:
                        {
                            
                            [cell.pullDownBtn setTitle:self.commodityDetaiModel.content_shelf forState:UIControlStateNormal];//商品状态
                            cell.pullDownBtn.enabled = YES;
                            
                        }
                            break;
                        default:
                            break;
                    }
                }
                
            }
            return cell;
        }
    }else{
        
        AddCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCommodityTableViewCellThree"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AddCommodityTableViewCell" owner:self options:nil]lastObject];
        }
        [cell.describeLabel setText:@"请输入商品描述"];
        cell.delegate = self;
        cell.tag = 10 + CELL_TAG;
        cell.textView.editable = YES;
        if (self.commodityDetaiModel.content_mbody) {
            [cell.textView setText:self.commodityDetaiModel.content_mbody ];
                cell.textView.editable = NO;
                cell.textView.textColor = TEXTCOLORWITHNOEDITING;
                if (![cell.textView.text isEqualToString:@""]) {
                    cell.describeLabel.hidden = YES; 
            }
        }
        if (self.is_self) {
            cell.textView.textColor = UIColorFromRGB(0x333333);
        }
        else{
            cell.textView.textColor = UIColorFromRGB(0x999999);
        }

        return cell;
        
    }
    
}
#pragma mark - 编辑结束 不复用cell
-(void)textViewDidEndEditing{
    self.isReusable = NO;
}
#pragma mark - 两个button 下拉菜单
-(void)pullDownBtnClick:(UIButton *)button{
    [self.view endEditing:YES];
    if (button.tag ==5) {
        DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:109];
        [ddmv1 removeFromSuperview];
        self.currentSelectedBtn = button;
        if (self.classificationDataArr.count!=0) {
            if (!_isShowDropMenu) {
                [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
                [self showDropMenu:5 andDataArr:self.classificationDataArr andHeight:150.f andDifference:5];
                _isShowDropMenu = YES;
            }else{
                [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
                
                DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:105];
                [ddmv removeFromSuperview];
                DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:109];
                [ddmv1 removeFromSuperview];
                _isShowDropMenu = NO;
            }

        }
        else{
            DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:105];
            [ddmv removeFromSuperview];
            [self.indicator setIndicatorType:ActivityIndicatorLogin];
            [self.indicator startAnimatingActivit];
            [ELRequestSingle classificationWithRequest:^(BOOL sucess, id objc) {
                [self.indicator LoadSuccess];
                self.classificationDataArr = objc;
                if (!_isShowDropMenu) {
                    [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];
                    
                    [self showDropMenu:5 andDataArr:self.classificationDataArr andHeight:150.f andDifference:5];
                    _isShowDropMenu = YES;
                }else{
                    
                    [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
                    DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:105];
                    [ddmv removeFromSuperview];
                    DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:109];
                    [ddmv1 removeFromSuperview];
                    _isShowDropMenu = NO;
                }
                
            } andShope_id:self.shop_id andTask:@"procode"];
            
            
            

        }
        
    }
    else if (button.tag == 9)
    {
        self.currentSelectedBtn = button;
        ClassificationModel *cfModel1 = [[ClassificationModel alloc]init];
        cfModel1.modules_name = @"上架";
        cfModel1.auto_code = @"1";
        ClassificationModel *cfModel2 = [[ClassificationModel alloc]init];
        cfModel2.modules_name = @"下架";
        cfModel2.auto_code = @"2";
        ClassificationModel *cfModel3 = [[ClassificationModel alloc]init];
        cfModel3.modules_name = @"补货中";
        cfModel3.auto_code = @"3";
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:cfModel1,cfModel2,cfModel3, nil];
        if (!_isShowDropMenu1) {
            [button setImage:[UIImage imageNamed:@"seldown"] forState:UIControlStateNormal];

              [self showDropMenu:9 andDataArr:arr andHeight:108.f andDifference:5+6];
            _isShowDropMenu1 = YES;
        }else{
            
            [button setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
            DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:109];
            [ddmv removeFromSuperview];
            DropDownMenuView *ddmv1 = (DropDownMenuView *)[self.view viewWithTag:105];
            [ddmv1 removeFromSuperview];
            _isShowDropMenu1 = NO;

        }
    }else{
        
    }
    
}
-(void)showDropMenu:(NSInteger)row andDataArr:(NSMutableArray*)dataArr andHeight:(CGFloat)height andDifference:(NSInteger)difference{
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
    CGRect rectInTableView = [self.bgTabel rectForRowAtIndexPath:path];
    CGRect rectInSuperview = [self.bgTabel convertRect:rectInTableView toView:self.view];//在某个view上计算frame
    DropDownMenuView *dropMent1 = [DropDownMenuView instanceView:nil];  
    dropMent1.dropDownMenuViewType = DropDownMenuViewRemoveAll;
//    dropMent1.frame = CGRectMake(108+1, CGRectGetMaxY(rectInSuperview)-difference, SCREENWIDTH - 138-2, height);
    dropMent1.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    dropMent1.topConstraint.constant = CGRectGetMaxY(rectInSuperview)-difference;
    dropMent1.tableviewLeftConstraint.constant = 108+1;
    dropMent1.tableviewRightConstraint.constant = 30 + 1;
    dropMent1.dataArr = dataArr;
    dropMent1.delegate = self;
    dropMent1.currentBtnblock = ^(BOOL isDrop){
        if (isDrop) {
            [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];
            _isShowDropMenu = NO;
        }
    };
    dropMent1.tag = 100+row;
     [self.view addSubview:dropMent1];
    self.currrentDropDownMenuView = dropMent1;
 }

-(void)didSelectRowAtIndexPathWithText:(NSString *)text andAuto_code:(NSString *)auto_code{
    
    NSMutableDictionary * currentdic;
    NSMutableDictionary * dic;
    if (self.currentSelectedBtn.tag == 5) {
        [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];

        [self.currentSelectedBtn setTitle:text forState:UIControlStateNormal];
        DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:105];
        [ddmv removeFromSuperview];
        _isShowDropMenu = NO;
        currentdic = [NSMutableDictionary dictionaryWithObject:auto_code forKey:@"auto_code"];// 存储分类的分类编码
//        [_typeDic setObject:auto_code forKey:@"auto_code"];
        _commodityDetaiModel.auto_code = auto_code;
    }else if (self.currentSelectedBtn.tag ==9){
        [self.currentSelectedBtn setImage:[UIImage imageNamed:@"selgo"] forState:UIControlStateNormal];

        [self.currentSelectedBtn setTitle:text forState:UIControlStateNormal];
        DropDownMenuView *ddmv = (DropDownMenuView *)[self.view viewWithTag:109];
        [ddmv removeFromSuperview];
        _isShowDropMenu1 = NO;
        dic = [NSMutableDictionary dictionaryWithObject:auto_code forKey:@"type"];// 存储状态的标示
//        [_typeDic setObject:auto_code forKey:@"type"];
        _commodityDetaiModel.content_shelf_status = auto_code;
    }
}
//扫一扫点击事件
#pragma mark - 扫描
- (void)home:(id)sender{
    self.is_self = NO;
    QrCodeScanningController * qr = [[QrCodeScanningController alloc]initWithNibName:@"QrCodeScanningController" bundle:nil];
    qr.delegate = self;
    qr.is_regist = YES;
    self.is_self = NO;
    
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [self showAlertViewWith:@"相机权限受限"];
    }
    else{
        [self.navigationController pushViewController:qr animated:YES];
    }
    
    
    
//    [self downLoadRequestWithCode:@"69025143"];
}


#pragma mark - 返回二维码的扫描结果
- (void)returnQrCode:(NSString *)code{
    NSLog(@"%@",code);
    if ([code isEqualToString:@""]) {
        [self showAlertViewWith:@"抱歉，未找到相关信息！"];
    }
    else{
        [self downLoadRequestWithCode:code];
    }
    
}
-(void)back:(id)sender{
     
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)downLoadRequestWithCode:(NSString *)code{
    [self.indicator startAnimatingActivit];
    [ELRequestSingle getSweepProductWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            
            self.commodityDetaiModel = objc;
            self.pro_id = self.commodityDetaiModel.pro_id;//商品库id
            NSMutableArray * photoArr = [NSMutableArray array];
            for (NSInteger i=0; i<self.commodityDetaiModel.show.count; i++) {
                ShowModel * show =self.commodityDetaiModel.show[i];
                [photoArr addObject:show.content_img];
            }
            for (int i = 0; i < (photoArr.count > 4 ? 4 : photoArr.count); i++) {
                [self.assets addObject:photoArr[i]];
            }
            
            [self.bgTabel reloadData];
            [_gridView reloadData];
        }
        else{
            [self showAlertViewWith:objc];
        }
    } andCode:code];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 上传内容
-(void)onShelfCommodityBtn {
    
    
    self.indicator.frame = CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    
    [self.indicator startAnimatingActivit];
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
        [self.indicator LoadSuccess];
        NSArray * valueArr = [imgDic allValues];
        NSArray * keyArr = [imgDic allKeys];
        for(int i = 0 ;i<keyArr.count; i++){
            [formData appendPartWithFileData:UIImagePNGRepresentation(valueArr[i]) name:keyArr[i] fileName:[NSString stringWithFormat:@"%@.png",keyArr[i]]  mimeType:@"image/png"];
        }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            
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

    if (_commodityDetaiModel.auto_code != nil && _commodityDetaiModel.content_shelf_status != nil) {
        [_typeDic setObject:_commodityDetaiModel.auto_code forKey:@"auto_code"];
        [_typeDic setObject:_commodityDetaiModel.content_shelf_status forKey:@"type"];
        
    }
    
    //   duct[content_name]	String		商品名
    AddCommodityTableViewCell * content_name_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:1 + CELL_TAG];
    //   duct[content_price]	double		商品价格
    AddCommodityTableViewCell * content_price_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:2 + CELL_TAG];
    //   pro[content_preprice]	double		商品优惠价格
    AddCommodityTableViewCell * content_preprice_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:3 + CELL_TAG];
    //   duct[content_brand]	String		商品品牌
    AddCommodityTableViewCell * content_brand_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:4 + CELL_TAG];
    //   duct[auto_code]	String		分类编码
    AddCommodityTableViewCell * auto_code_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:5 + CELL_TAG];
    //   duct[weight]	int 重量
//    AddCommodityTableViewCell * weight_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:6 + CELL_TAG];
    AddServiceTableViewCell * weight_cell = (AddServiceTableViewCell *)[self.bgTabel viewWithTag:6 + CELL_TAG];

    //   duct[content_expiration]	String		保质期
    AddCommodityTableViewCell * content_expiration_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:7 + CELL_TAG];
    //   duct[specifications]	String		商品规格
    AddCommodityTableViewCell * specifications_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:8 + CELL_TAG];
    //   pro[content_shelf]	int		上下架类型 1 ：上架，2:下架，3补货中
    AddCommodityTableViewCell * content_shelf_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:9 + CELL_TAG];
    //   body[content_mbody]	String		商品详情
    AddCommodityTableViewCell * content_mbody_cell = (AddCommodityTableViewCell *)[self.bgTabel viewWithTag:10 + CELL_TAG];
    NSNumber * content_shelf_cellNum = [NSNumber numberWithInt:[_commodityDetaiModel.content_shelf_status intValue]];
    NSNumber * auto_code_cellNum = [NSNumber numberWithInt:[_commodityDetaiModel.auto_code intValue]];
    NSNumber * weight = [NSNumber numberWithInt:[[self textFieldSpeca:weight_cell.textField.text] intValue]];
    NSNumber * preprice = [NSNumber numberWithInt:[[self textFieldSpeca:content_preprice_cell.inputField.text] doubleValue]];
    NSNumber * price = [NSNumber numberWithDouble:[[self textFieldSpeca:content_price_cell.inputField.text] doubleValue]];
    NSNumber * member_idNum = [NSNumber numberWithInt:[NSUserDefaults_Member_id intValue]];//卖家id
    
    NSLog(@"NSUserDefaults_Member_id:%@,member_idNum:%@",NSUserDefaults_Member_id,member_idNum);
    NSNumber * shop_idNum = [NSNumber numberWithInt:[self.shop_id intValue]];//店铺id
    
    NSNumber * pro_idNum = [NSNumber numberWithInt:[self.pro_id intValue]];//商品表ID
    NSNumber * product_idNum = [NSNumber numberWithInt:[self.commodity_id intValue]];//商品表ID
//添加扫码库商品  商品库id
    //修改自营商品  pro_id 商品表ID
    //修改扫码商品   
    /*
     pro[content_preprice]	double	N	售价	商品表
     member_id	int	N	商家ID
     pro_id	int	N	商品表ID	修改条件
     shoppe_id	int	N	店铺ID	修改条件
     pro[content_shelf]	int	N	上下架类型	1：上架，2:下架，3补货中
     */
    /**
     *  添加自营商品的参数字典
     */
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [self textFieldSpeca:content_name_cell.inputField.text],@"duct[content_name]",// 1.商品名
                          [self textFieldSpeca:content_name_cell.inputField.text],@"pro[content_name]",//商品名称 商品表// 2.4
                                 
                          price,@"duct[content_price]",// .商品价格
                          preprice,@"pro[content_preprice]",// // 2.6商品价格 商品表
                                 
                          [self textFieldSpeca:content_brand_cell.inputField.text],@"duct[content_brand]",//3.商品品牌
                                 
                          auto_code_cellNum,@"duct[auto_code]",//4.分类编码
                          auto_code_cellNum,@"pro[auto_code]",//分类编码 商品表// 2.5
                                 
                          weight,@"duct[weight]",// 5.重量
                                 
                          [self textFieldSpeca:content_expiration_cell.inputField.text],@"duct[content_expiration]",//6.保质期
                                 
                          [self textFieldSpeca:specifications_cell.inputField.text],@"duct[specifications]",//7.商品规格
                                 
                          content_shelf_cellNum,@"pro[content_shelf]",//8.上下架类 // 2.7
                                 
                          [self textFieldSpeca:content_mbody_cell.textView.text],@"body[content_mbody]",// 9.商品详情 商品表
                                 
                           nil
                          ];

    
    

#pragma mark - 判断yd
    if (_isAddCommodity) {//添加时的字段
        if (self.assets.count== 0) {
            [self showAlertViewWith:@"请选择图片"];
            return;
        }
        [dic addEntriesFromDictionary:@{@"pro[shoppe_id]":shop_idNum,// 2.2
                                        @"pro[member_id]":member_idNum// 2.3
                                        }];
        if (self.is_self) {
            self.task = @"addprobase";
            
            
        }
        else{
            self.task = @"addpro";
            [dic addEntriesFromDictionary:@{@"pro[product_id]":pro_idNum// 2.1 商品库ID
                                            }];
        }
        
        
    }else{//修改时的字段
        if (self.assets.count == 0&&imgArr.count == 0){
            [self showAlertViewWith:@"请选择图片"];
            return;
        }
        [dic addEntriesFromDictionary:@{@"pro_id":product_idNum,
                                        @"member_id":member_idNum,
                                        @"shoppe_id":shop_idNum,
                                        @"product_id":pro_idNum
                                        }];
        if (self.is_self) {
            self.task = @"editprobase";
        }
        else{
            self.task = @"editproduct";
        }
    }
    for (int i = 1; i < imgArr.count+1; i++) {
        [dic setObject:imgArr[i - 1] forKey:[NSString stringWithFormat:@"img[%d]",i]];
    }
    
    for (NSInteger i=1; i<10; i++) {
        AddCommodityTableViewCell *cell = (AddCommodityTableViewCell*)[self.bgTabel viewWithTag:CELL_TAG+ i];
        AddServiceTableViewCell *cell1 = (AddServiceTableViewCell*)[self.bgTabel viewWithTag:CELL_TAG+ i];
        switch (cell.tag) {
            case CELL_TAG+ 1:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品名称"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 2:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品价格"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 3:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品优惠价格"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 4:
            {
                if ([cell.inputField.text  isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品品牌"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 5:
            {
//                if ([[NSString stringWithFormat:@"%@",dic[@"duct[auto_code]"]] isEqualToString:@"0"] ) {
//                    [self showAlertViewWith:@"请选择商品分类"];
//                    return;
//                }
                if (cell.pullDownBtn.titleLabel.text == nil) {
                    [self showAlertViewWith:@"请选择商品分类"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 6:
            {
                if ([cell1.textField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品重量"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 7:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品保质期"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 8:
            {
                if ([cell.inputField.text isEqualToString:@""]) {
                    [self showAlertViewWith:@"请输入商品规格"];
                    return;
                }
            }
                break;
            case CELL_TAG+ 9:
            {
//                if ([[NSString stringWithFormat:@"%@",dic[@"pro[content_shelf]"]] isEqualToString:@"0"]) {
//                    [self showAlertViewWith:@"请输入商品状态"];
//                    return;
//                }
                if (cell.pullDownBtn.titleLabel.text ==nil) {
                    [self showAlertViewWith:@"请输入商品状态"];
                    return;
                }
            }
//            case CELL_TAG + 10:
//            {
//                if (cell.textView == nil) {
//                     [self showAlertViewWith:@"请输入商品介绍"];
//                    return;
//                }
//            }
//                break;
            default:
                break;
        }
    }
    if ([[self textFieldSpeca:content_mbody_cell.textView.text] isEqualToString:@""]) {
        [self showAlertViewWith:@"请输入商品介绍"];
        return;
    }
    else{
        [self uploadCommodity:dic];
    }

    

}
- (void)ToJudgeWhetherItIsEmpty{
    
}
-(void)uploadCommodity:(NSMutableDictionary *)dicArr{
    
    [ELRequestSingle changeSelfCommodityWithRequest:^(BOOL sucess, id objc) {
        [self.indicator LoadSuccess];
        if (sucess) {
            [ELTRefreshSingleton refreshIsOK].state = YES;
            [self.navigationController popViewControllerAnimated:YES];
            
          
        }else{
//            [self.view makeToast:objc];
            [self showAlertViewWith:objc];
        }
    } andTask:self.task andParameters:dicArr];
}
- (NSString *)textFieldSpeca:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:kImageCachePath] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
}
//接受cell的字典
-(void) getCustomParadic:(NSMutableDictionary *)paraDic{
    [self.paraDic addEntriesFromDictionary:paraDic];
}
#pragma  mark - 隐藏tabbar的暂时方法
- (void)hiddenCustomTabBar{
    UIApplication * applictaino = [UIApplication sharedApplication];
    AppDelegate  * delegate = applictaino.delegate;
    delegate.tab.tabBar.bounds = CGRectMake(0, 0, 0, 0);
}

@end
