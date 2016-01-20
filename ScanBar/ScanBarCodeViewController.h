

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanBarCodeDelegate <NSObject>

- (void)scanCallback:(NSString *)dimensionCode;

@end

@interface ScanBarCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (strong,nonatomic)     id<ScanBarCodeDelegate>    delegate;

@property (strong,nonatomic)     UILabel                   *labIntroudction;
@property (nonatomic,readwrite)  CGRect                     previewFrame;
@property(nonatomic,strong)      CAKeyframeAnimation       *animation;

@property (strong,nonatomic)     AVCaptureDevice            *device;
@property (strong,nonatomic)     AVCaptureDeviceInput       *input;
@property (strong,nonatomic)     AVCaptureMetadataOutput    *output;
@property (strong,nonatomic)     AVCaptureSession           *session;
@property (strong,nonatomic)     AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,retain)     UIImageView                *line;

@end
