
//
//  SDFourSecTableViewCell.m
//  Guoan Test
//
//  Created by elongtian on 15/7/31.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import "ELTBuyerCommentsCell.h"

#define edge 12.5
#define top 10
#define  photosWidth 26

@interface ELTBuyerCommentsCell ()
{
    UIView *_lineView;
}
@property (nonatomic,strong) UIImageView *headImage;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *commentLabel;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *dataLabel;
@property (nonatomic,strong) UIView *lineView;



@end




@implementation ELTBuyerCommentsCell

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
} 
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
    
}
#pragma mark - UI
- (void)createUI{
    /**
     评星
     */
    self.headImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.headImage];
    /**
     主题
     */
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.numberOfLines = 1;
    self.nameLabel.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:self.nameLabel];
    
    
    /**
     评论内容
     */
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.textColor = UIColorFromRGB(0x333333);
    self.commentLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.commentLabel];
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.titleLabel];
    
    
    self.dataLabel = [[UILabel alloc]init];
    self.dataLabel.textAlignment = NSTextAlignmentRight;
    self.dataLabel.font = [UIFont systemFontOfSize:12.0];
    self.dataLabel.numberOfLines = 1;
    self.dataLabel.textColor = UIColorFromRGB(0x999999);
    [self.contentView addSubview:self.dataLabel];
    
    
    /**
     上传的图片
     */
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.contentView addSubview:self.lineView];
}
#pragma mark - 赋值
- (void)setModel:(ELTReviewModel *)model{
    
    _model = model;
    switch ([model.evaluation_value integerValue]) {
        case 1:
        {
            [self.headImage setImage:[UIImage imageNamed:@"fav"]];
        }
            break;
        case 2:
        {
            [self.headImage setImage:[UIImage imageNamed:@"favhalf"]];
        }
            break;
        case 3:
        {
            [self.headImage setImage:[UIImage imageNamed:@"bad"]];
        }
            break;
            
        default:
            break;
    }
    [self.nameLabel setText:model.service_name];
    [self.commentLabel setText:model.evaluation_content];
    [self.titleLabel setText:model.content_user];
    [self.dataLabel setText:model.create_time];
    [self resetFrame:model];
    
}
#pragma mark - 动态布局
- (void)resetFrame:(ELTReviewModel * )model{
    
    self.nameLabel.frame = CGRectMake(45, 15, SCREENWIDTH - 45-15, 18);
    
    CGFloat w = self.nameLabel.frame.size.width;
    CGSize size = [model.evaluation_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(w, MAXFLOAT) ];
    self.commentLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 5, CGRectGetWidth(self.nameLabel.frame), size.height);
    if ([model.evaluation_content isEqualToString:@""]) {
        self.commentLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 5, CGRectGetWidth(self.nameLabel.frame), 15);
    }
    
    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.commentLabel.frame), CGRectGetMaxY(self.commentLabel.frame) + 5, CGRectGetWidth(self.nameLabel.frame)/2,15);
    
    self.dataLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.commentLabel.frame) - CGRectGetWidth(self.titleLabel.frame),15);

    self.lineView.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) +14, CGRectGetWidth(self.commentLabel.frame),1);
    
    self.frame = CGRectMake(0, 0, SCREENHEIGHT,CGRectGetMaxY(self.lineView.frame));
    
    CGFloat headImageCenterX = 25.0f;
    CGFloat headImageCenterY = self.frame.size.height/2;
    self.headImage.center = CGPointMake(headImageCenterX, headImageCenterY);
    self.headImage.bounds = CGRectMake(0, 0, 20, 20);
}

@end
