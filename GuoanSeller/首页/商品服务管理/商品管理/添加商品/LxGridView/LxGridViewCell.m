//
//  LxGridViewCell.m
//  LxGridView
//

#import "LxGridView.h"


static NSString * const kVibrateAnimation = @stringify(kVibrateAnimation);
static CGFloat const VIBRATE_DURATION = 0.1;
static CGFloat const VIBRATE_RADIAN = M_PI / 96;

@interface LxGridViewCell (){
    UIAlertView * _alertView;
}

@property (nonatomic,assign) BOOL vibrating;

@end

@implementation LxGridViewCell
{
    UIButton * _deleteButton;
    UILabel * _titleLabel;
    
}
@synthesize editing = _editing;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupEvents];
    }
    return self;
}

- (void)setup
{
    self.iconImageView = [[UIImageView alloc]init];
//    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.iconImageView.layer.cornerRadius = ICON_CORNER_RADIUS;
    self.iconImageView.layer.masksToBounds = YES;
    //边框颜色
    self.iconImageView.layer.borderColor = UIColorFromRGB(0xececec).CGColor;
    //边框宽
    self.iconImageView.layer.borderWidth = 1.0f;

    [self.contentView addSubview:self.iconImageView];
    

//    _deleteButton.hidden = YES;
    
    /**
     图片上方的删除按钮
//     */
    self.topShadowView = [[UIView alloc]init];
    
    _topShadowView.alpha = 0.3;
    _topShadowView.backgroundColor = UIColorFromRGB(0x333333);
    //_topShadowView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_topShadowView addGestureRecognizer:tap];
    [self.contentView addSubview:self.topShadowView];
   
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"closes2"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];//底部透明 子控件也透明
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"closes2"] forState:UIControlStateNormal];
//    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.deleteBtn];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"title";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.hidden = YES;
    
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topShadowView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除该图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLayoutConstraint * iconImageViewLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0];

    [self.contentView addConstraints:@[iconImageViewLeftConstraint,iconImageViewRightConstraint,iconImageViewTopConstraint,iconImageViewBottomConstraint]];
    
    NSLayoutConstraint * topShadowViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:_topShadowView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    NSLayoutConstraint * topShadowViewLeftConstraint =
    [NSLayoutConstraint constraintWithItem:_topShadowView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    NSLayoutConstraint * topShadowViewRightConstraint =
    [NSLayoutConstraint constraintWithItem:_topShadowView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    NSLayoutConstraint * topShadowViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:_topShadowView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:18];
    [self.contentView addConstraints:@[topShadowViewLeftConstraint,topShadowViewRightConstraint,topShadowViewTopConstraint,topShadowViewHeightConstraint]];
    if (!_isDeleteBtn) {
        NSLayoutConstraint * deleteButtonTopConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:3];
        
        NSLayoutConstraint * deleteButtonLeftConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:-2];
        
        NSLayoutConstraint * deleteButtonWidthConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1
                                      constant:12];
        
        NSLayoutConstraint * deleteButtonHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1
                                      constant:12];
        
        [self.contentView addConstraints:@[deleteButtonLeftConstraint,deleteButtonTopConstraint,deleteButtonWidthConstraint,deleteButtonHeightConstraint]];
    }else{
    
    
        NSLayoutConstraint * deleteButtonTopConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:3];
        
        NSLayoutConstraint * deleteButtonLeftConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.contentView
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:-2];
        
        NSLayoutConstraint * deleteButtonWidthConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1
                                      constant:24];
        
        NSLayoutConstraint * deleteButtonHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_deleteButton
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1
                                      constant:24];
        
        [self.contentView addConstraints:@[deleteButtonLeftConstraint,deleteButtonTopConstraint,deleteButtonWidthConstraint,deleteButtonHeightConstraint]];
    }
    
    NSLayoutConstraint * centerXConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * titleLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:3];
    
    NSLayoutConstraint * titleLabelWidthConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * titleLabelHeightConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:15];
    
    [self.contentView addConstraints:@[centerXConstraint, titleLabelTopConstraint, titleLabelWidthConstraint, titleLabelHeightConstraint]];

}
-(void)setIsEdited:(BOOL)isEdited{
    _isEdited = isEdited;
    if (!isEdited) {
        _topShadowView.hidden  = YES;
        _deleteButton.hidden  = YES;
    }
    else{
        _topShadowView.hidden  = NO;
        _deleteButton.hidden  = NO;
    }
}
- (void)setupEvents
{
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImageView.userInteractionEnabled = YES;
}

#pragma mark - 点击事件
- (void)deleteButtonClicked:(UIButton *)btn
{
    if (self.isEdited) {
        
        if ([self.delegate respondsToSelector:@selector(deleteButtonClickedInGridViewCell:)]) {
            [_alertView show];
        }
    }
    else{
        
    }
}
- (void)tap
{
    if (self.isEdited) {
        
        if ([self.delegate respondsToSelector:@selector(deleteButtonClickedInGridViewCell:)]) {
            [_alertView show];
            
        }
    }
    else{
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [self.delegate deleteButtonClickedInGridViewCell:self];
        }
            break;
        default:
            break;
    }
}

- (BOOL)vibrating
{
    return [self.iconImageView.layer.animationKeys containsObject:kVibrateAnimation];
}

- (void)setVibrating:(BOOL)vibrating
{
    BOOL _vibrating = [self.layer.animationKeys containsObject:kVibrateAnimation];
    
    if (_vibrating && !vibrating) {
        [self.layer removeAnimationForKey:kVibrateAnimation];
    }
    else if (!_vibrating && vibrating) {
        //抖动效果
//        CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@stringify(transform.rotation.z)];
//        vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        vibrateAnimation.fromValue = @(- VIBRATE_RADIAN);
//        vibrateAnimation.toValue = @(VIBRATE_RADIAN);
//        vibrateAnimation.autoreverses = YES;
//        vibrateAnimation.duration = VIBRATE_DURATION;
//        vibrateAnimation.repeatCount = CGFLOAT_MAX;
//        [self.layer addAnimation:vibrateAnimation forKey:kVibrateAnimation];
    }
}

- (BOOL)editing
{
    return self.vibrating;
}

- (void)setEditing:(BOOL)editing
{
    self.vibrating = editing;
//    _deleteButton.hidden = !editing;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (UIView *)snapshotView
{
    UIView * snapshotView = [[UIView alloc]init];
    
    UIView * cellSnapshotView = nil;
    UIView * deleteButtonSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
//    contentMode = UIViewContentModeScaleToFill;
    if ([_deleteButton respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
//        deleteButtonSnapshotView = [_deleteButton snapshotViewAfterScreenUpdates:NO];
    }
    else {
//        UIGraphicsBeginImageContextWithOptions(_deleteButton.bounds.size, _deleteButton.opaque, 0);
//        [_deleteButton.layer renderInContext:UIGraphicsGetCurrentContext()];
////        UIImage * deleteButtonSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        deleteButtonSnapshotView = [[UIImageView alloc]initWithImage:deleteButtonSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(-deleteButtonSnapshotView.frame.size.width / 2,
                                    -deleteButtonSnapshotView.frame.size.height / 2,
                                    deleteButtonSnapshotView.frame.size.width / 2 + cellSnapshotView.frame.size.width,
                                    deleteButtonSnapshotView.frame.size.height / 2 + cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(deleteButtonSnapshotView.frame.size.width / 2,
                                        deleteButtonSnapshotView.frame.size.height / 2,
                                        cellSnapshotView.frame.size.width,
                                        cellSnapshotView.frame.size.height);
//    deleteButtonSnapshotView.frame = CGRectMake(0, 0,
//                                                deleteButtonSnapshotView.frame.size.width,
//                                                deleteButtonSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    [snapshotView addSubview:deleteButtonSnapshotView];
    
    return snapshotView;
}

@end
