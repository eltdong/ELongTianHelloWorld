//
//  QrCodeScanningController.h
//  tangren
//
//  Created by elongtian on 15/7/17.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Const.h"
@protocol QrCodeScanningDelegate <NSObject>

- (void)returnQrCode:(NSString *)code;

@end
@interface QrCodeScanningController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    JRNavgationBar * navBar;
    BOOL upOrdown;
    int num;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIView *back_View;
@property (weak, nonatomic) IBOutlet UIImageView *boundsImg;
@property (retain, nonatomic) UIImageView * line;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (assign, nonatomic) BOOL is_regist;//是注册还是搜索，
@property (assign, nonatomic) id <QrCodeScanningDelegate>delegate;
@property (retain, nonatomic) NSString * type;
@end
