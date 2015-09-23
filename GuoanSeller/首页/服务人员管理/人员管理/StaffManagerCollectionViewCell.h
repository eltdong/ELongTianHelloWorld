//
//  StaffManagerCollectionViewCell.h
//  GuoanSeller
//
//  Created by elongtian on 15/8/6.
//  Copyright (c) 2015年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffManagerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImage;

@property (strong, nonatomic) IBOutlet UILabel *namelabel;

@property (strong, nonatomic) IBOutlet UIView *blackView;//蒙层

@property (strong, nonatomic) IBOutlet UIImageView *selectImage;//选中框

@end
