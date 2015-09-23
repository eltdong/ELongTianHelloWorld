//
//  QrCodeScanningController.m
//  tangren
//
//  Created by elongtian on 15/7/17.
//  Copyright (c) 2015年 易龙天. All rights reserved.
//

#import "QrCodeScanningController.h"

@interface QrCodeScanningController ()

@end

#import "QrCodeScanningController.h"
@interface QrCodeScanningController ()

@end

@implementation QrCodeScanningController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]postNotificationName:HIDDEN_TABBAR object:@"1"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"条形码扫描";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    
    _boundsImg.layer.borderWidth = 1;
    _boundsImg.layer.borderColor = [UIColor whiteColor].CGColor;
    
    NSLog(@"%@",[NSValue valueWithCGRect:_boundsImg.frame]);
    _boundsImg.frame = CGRectMake(SCREENWIDTH/2 - 100, 60, 200, 200);
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20,_boundsImg.frame.size.width-40, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [_back_View addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&//断当前设备是否能打开相机
//        [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
//        
        [self setupCamera];
//    }
//    else{
//        
//        [self showAlertViewWith:@"相机未打开"];
//        self.navigationController popViewControllerAnimated:YES
//    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20+2*num, _boundsImg.frame.size.width-40, 2);
        if (2*num == _boundsImg.frame.size.height-40) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20+2*num, _boundsImg.frame.size.width-40, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(_boundsImg.frame.origin.x, _boundsImg.frame.origin.y, _boundsImg.frame.size.width, _boundsImg.frame.size.height);
    NSLog(@"%@",[NSValue valueWithCGRect:_preview.frame]);
    NSLog(@"%@",_preview);
    NSLog(@"%@",_boundsImg);
    _preview.position=CGPointMake(CGRectGetMidX(_boundsImg.frame), CGRectGetMidY(_boundsImg.frame));
    [_back_View.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    if(self.is_regist){
        if([self.delegate respondsToSelector:@selector(returnQrCode:)])
        {
            [self.delegate performSelector:@selector(returnQrCode:) withObject:stringValue];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^
         {
             [timer invalidate];
         }];
        
    }
    else
    {
        [_session startRunning];
    }
}


- (void)back:(id)sender
{
    [timer invalidate];
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
