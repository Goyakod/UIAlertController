
#import "ScanBarCodeViewController.h"

@interface ScanBarCodeViewController ()

@end

@implementation ScanBarCodeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.previewFrame = CGRectMake((self.view.frame.size.width-420)/2, (self.view.frame.size.height-420)/2, 420, 420);
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-BOLD" size:40]];
    [scanButton setBackgroundColor:[UIColor colorWithRed:115.0 / 255.0 green:198.0 / 255.0 blue:190.0 / 255.0 alpha:1.0]];
    [scanButton.layer setMasksToBounds:YES];
    [scanButton.layer setCornerRadius:10.0];
    scanButton.frame = CGRectMake((self.view.frame.size.width-120)/2, self.view.frame.size.height-100, 120, 60);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    self.labIntroudction = [[UILabel alloc] initWithFrame:CGRectMake(0, self.previewFrame.origin.y-50, self.view.frame.size.width, 50)];
    self.labIntroudction.backgroundColor = [UIColor clearColor];
    self.labIntroudction.numberOfLines = 2;
    self.labIntroudction.textColor = [UIColor blackColor];
    self.labIntroudction.text = @"将二维码/条码放入框内，离摄像头10厘米左右，即可自动扫描。";
    self.labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.labIntroudction];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.previewFrame];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(self.previewFrame.origin.x+40, self.previewFrame.origin.y+40, self.previewFrame.size.width-80, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * 滑入/滑出 视图
 */
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(self.previewFrame.origin.x+40, self.previewFrame.origin.y+40+2*num, self.previewFrame.size.width-80, 2);
        if (2*num == self.previewFrame.size.width-80) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(self.previewFrame.origin.x+40, self.previewFrame.origin.y+40+2*num, self.previewFrame.size.width-80, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

/**
 * 取消
 */
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
        [self.delegate scanCallback:nil];
    }];
}

/**
 * 视图将要显示时，准备摄像头
 * 注意：模拟器会报错，必须真机
 */
-(void)viewWillAppear:(BOOL)animated
{
    NSString *device = [UIDevice currentDevice].model;
    
    if ([device rangeOfString:@"Simulator"].location > device.length) {
        [self setupCamera];
    }
}

/**
 * 准备摄像头
 */
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
    _output.metadataObjectTypes =@[AVMetadataObjectTypeUPCECode,
                                   AVMetadataObjectTypeCode39Code,
                                   AVMetadataObjectTypeCode39Mod43Code,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode93Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypePDF417Code,
                                   AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeAztecCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.previewFrame;
    [_preview.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    [self.view.layer insertSublayer:self.preview atIndex:0];

    // Start
    [_session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
/**
 * 扫描完成
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         [self.preview removeFromSuperlayer];
         [self.view removeFromSuperview];
         [self.delegate scanCallback:stringValue];
     }];
}
@end
