//
//  MSQRCodeReaderView.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSQRCodeReaderView.h"
#import <AVFoundation/AVFoundation.h>

@interface MSQRCodeReaderView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayout;

@property (nonatomic, strong) NSMutableArray *defaultMetaDataObjectTypes;

@property (nonatomic, weak) UIView *loadingView;
@property (nonatomic, weak) UIView *videoView;
@property (nonatomic, weak) MSQRCodeReaderMaskView *maskView;

@end

@implementation MSQRCodeReaderView


#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAVComponents];
        [self setupSubviews];
    }
    return self;
}

- (void)setupAVComponents {
    // 获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (_device == nil) {
        return;
    }

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPreset1920x1080;

    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }

    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }

    // 设置扫码支持的编码格式
    _output.metadataObjectTypes = self.metaDataObjectTypes ?: self.defaultMetaDataObjectTypes;
    _previewLayout = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayout.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 开启自动对焦
    if (_device.isFocusPointOfInterestSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    UIView *loadingView = [self createLoadingView];
    self.loadingView = loadingView;

    UIView *videoView = [[UIView alloc] init];
    videoView.hidden = YES;
    self.videoView = videoView;
    
    MSQRCodeReaderMaskView *maskView = [[MSQRCodeReaderMaskView alloc] init];
    maskView.hidden = YES;
    self.maskView = maskView;
    
    [self addSubview:loadingView];
    [self addSubview:videoView];
    [self addSubview:maskView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self layoutSubviews];
}

- (UIView *)createLoadingView {
    UIView *containerView = [[UIView alloc] init];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    
    UILabel *loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = @"正在加载...";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.font = [UIFont ms_normalFont];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    [containerView addSubview:activityView];
    [containerView addSubview:loadingLabel];
    [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView);
        make.centerY.equalTo(containerView).with.offset(-50);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(activityView.mas_bottom).with.offset(10);
        make.left.and.right.equalTo(containerView);
        make.centerX.equalTo(containerView);
    }];
    return containerView;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self stopScanning];

        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if (self.scanCompletionHandler) {
            self.scanCompletionHandler(metadataObject.stringValue);
        }
    }
}

- (void)startScanning {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_session startRunning];
        
        _previewLayout.frame = self.bounds;
        if (![_videoView.layer.sublayers containsObject:_previewLayout]) {
            [_videoView.layer insertSublayer:_previewLayout atIndex:0];
        }
        [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock: ^(NSNotification *_Nonnull note) {
            _output.rectOfInterest = [_previewLayout metadataOutputRectOfInterestForRect:[self getScanRectWithPreView]];
            NSLog(@"%f--%f--%f--%f", _output.rectOfInterest.origin.x, _output.rectOfInterest.origin.y, _output.rectOfInterest.size.width, _output.rectOfInterest.size.height);
        }];
        [self.maskView startScanningAnimation];
        
        self.videoView.hidden = NO;
        self.maskView.hidden = NO;
        if (!self.loadingView.hidden) {
            self.videoView.alpha = 0.0f;
            self.maskView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.videoView.alpha = 1.0f;
                self.maskView.alpha = 1.0f;
                self.loadingView.hidden = 0.0f;
            } completion:^(BOOL finished) {
                self.loadingView.hidden = YES;
            }];
        }
    });
}

- (void)stopScanning {
    [_session stopRunning];
    [self.maskView stopScanningAnimation];
}

//- (void)setVideoScale:(CGFloat)scale {
//    [_input.device lockForConfiguration:nil];
//    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
//    
//    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
//    videoConnection.videoScaleAndCropFactor = scale;
//    [_input.device unlockForConfiguration];
//    CGAffineTransform transform = _videoView.transform;
//    _videoView.transform = CGAffineTransformScale(transform, zoom, zoom);
//}

#pragma mark - Private Methods

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
    for (AVCaptureConnection *connection in connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

// 获取识别区域
- (CGRect)getScanRectWithPreView {
    CGFloat width = self.ms_width * 0.8f;
    CGFloat height = self.ms_height * 0.6f;
    CGFloat x = self.ms_centerX - (width * 0.5f);
    CGFloat y = self.ms_centerY - (height * 0.7f);
    
    return CGRectMake(x, y, width, height);
}

#pragma mark - Getter

/**
 *  默认支持识别码类型
 *  @return 支持类型列表
 */
- (NSArray *)defaultMetaDataObjectTypes {
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
//                               AVMetadataObjectTypeUPCECode,
//                               AVMetadataObjectTypeCode39Code,
//                               AVMetadataObjectTypeCode39Mod43Code,
//                               AVMetadataObjectTypeEAN13Code,
//                               AVMetadataObjectTypeEAN8Code,
//                               AVMetadataObjectTypeCode93Code,
//                               AVMetadataObjectTypeCode128Code,
//                               AVMetadataObjectTypePDF417Code,
//                               AVMetadataObjectTypeAztecCode
                               ] mutableCopy];
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
//        [types addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code,
//                                     AVMetadataObjectTypeITF14Code,
//                                     AVMetadataObjectTypeDataMatrixCode]];
//    }
    return types;
}

@end
