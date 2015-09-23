//
//  LxGridViewCell.h
//  LxGridView
//

#import <UIKit/UIKit.h>

#pragma mark - cell移动时的偏移量 yd
//static CGFloat const LxGridView_DELETE_RADIUS = 10;
//static CGFloat const ICON_CORNER_RADIUS = 10;
static CGFloat const LxGridView_DELETE_RADIUS =  0;
static CGFloat const ICON_CORNER_RADIUS =  0;
@class LxGridViewCell;

@protocol LxGridViewCellDelegate <NSObject>

- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell;

@end

@interface LxGridViewCell : UICollectionViewCell

@property (nonatomic,assign) id<LxGridViewCellDelegate> delegate;
@property (nonatomic,retain) UIImageView * iconImageView;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) BOOL editing;
@property (nonatomic,assign) BOOL isEdited;// yd
@property (nonatomic,strong) UIView *topShadowView;//
@property (nonatomic,strong) UIButton *deleteButton;//添加服务页面的删除按钮
@property (nonatomic,strong) UIButton *deleteBtn;//添加招牌页面的删除按钮
@property (nonatomic, assign) BOOL isDeleteBtn;

- (UIView *)snapshotView;

@end
