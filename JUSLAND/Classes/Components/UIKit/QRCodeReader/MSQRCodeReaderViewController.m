//
//  MSQRCodeReaderViewController.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSQRCodeReaderViewController.h"
#import "MSQRCodeReaderMaskView.h"
#import "MSAVManager.h"
#import "MSQRCodeReaderView.h"

@interface MSQRCodeReaderViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UIView *loadingView;
@property (nonatomic, weak) MSQRCodeReaderView *qrCodeReaderView;

@end

@implementation MSQRCodeReaderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.qrCodeReaderView stopScanning];
}

#pragma mark - Setup navbar

- (void)setupNavbar {
    self.title = @"扫一扫";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"相册" target:self action:@selector(didTapPhotoAlbum:)];
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor blackColor];
    
    if (![MSAVManager checkCameraAuthorization]) {
        NSDictionary *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。", appName];
        MSAlertController *alertCtrl = [MSAlertController alertControllerWithTitle:@"相机不可用，或未授权" message:message preferredStyle:MSAlertControllerStyleAlert];
        [alertCtrl showCancel:@"确定" handler:nil];
    }
    MSQRCodeReaderView *qrCodeReaderView = [[MSQRCodeReaderView alloc] init];
    __weak typeof(qrCodeReaderView) weakQRCodeReaderView = qrCodeReaderView;
    [qrCodeReaderView setScanCompletionHandler:^(NSString *result) {
        MSAlertController *alertCtrl = [MSAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:MSAlertControllerStyleAlert];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleDefault handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"重新扫描" style:MSAlertActionStyleDestructive handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl show];
    }];
    self.qrCodeReaderView = qrCodeReaderView;
    
    [self.view addSubview:qrCodeReaderView];
    [qrCodeReaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)startScan {
    [self.qrCodeReaderView startScanning];
}

#pragma mark - Action Handler

- (void)didTapPhotoAlbum:(UIBarButtonItem *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *result = feature.messageString;
        [self.qrCodeReaderView stopScanning];
        
        __weak typeof(self.qrCodeReaderView) weakQRCodeReaderView = self.qrCodeReaderView;
        MSAlertController *alertCtrl = [MSAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:MSAlertControllerStyleAlert];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleDefault handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"重新扫描" style:MSAlertActionStyleDestructive handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl show];
    } else {
        __weak typeof(self.qrCodeReaderView) weakQRCodeReaderView = self.qrCodeReaderView;
        MSAlertController *alertCtrl = [MSAlertController alertControllerWithTitle:@"这不是一个会议室二维码哦!" message:nil preferredStyle:MSAlertControllerStyleAlert];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"取消" style:MSAlertActionStyleDefault handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl addAction:[MSAlertAction actionWithTitle:@"重新扫描" style:MSAlertActionStyleDestructive handler:^(MSAlertAction *action) {
            [weakQRCodeReaderView startScanning];
        }]];
        [alertCtrl show];
    }
}

@end
