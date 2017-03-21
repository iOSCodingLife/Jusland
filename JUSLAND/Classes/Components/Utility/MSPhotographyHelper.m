//
//  MSPhotographyHelper.m
//  MIS
//
//  Created by Nie on 2017/2/16.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSPhotographyHelper.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "ZYQAssetPickerController.h"

#define PHOTO_MAX 9

@interface MSPhotographyHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) DidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;

@property (nonatomic, strong) NSMutableArray *selctedPhotoArry;

@end


@implementation MSPhotographyHelper

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType
                            onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return ;
    }
    
    self.didFinishTakeMediaCompled = [compled copy];
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
    if (UIImagePickerControllerSourceTypePhotoLibrary == sourceType ||
        UIImagePickerControllerSourceTypeSavedPhotosAlbum == sourceType) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            // 无权限
            [self showAlertWithTitle:@"相册不可用，或未授权"
                             message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片。", appName]];
        } else if (author == ALAuthorizationStatusAuthorized) {
            [self imagePickerControllerFromVC:viewController sourceType:sourceType];
            // 多选
            //            [self showMultiselectPhotoPickonViewController:viewController];
        } else if (author == ALAuthorizationStatusNotDetermined) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (*stop) {
                    //点击“好”回调方法:
                    return;
                }
                *stop = TRUE;
                [self imagePickerControllerFromVC:viewController sourceType:sourceType];
                // 多选
                //                [self showMultiselectPhotoPickonViewController:viewController];
            } failureBlock:^(NSError *error) {
                //点击“不允许”回调方法:
                [viewController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    } else if (UIImagePickerControllerSourceTypeCamera == sourceType){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted) {
                    [self imagePickerControllerFromVC:viewController sourceType:sourceType];
                } else {
                    [self showAlertWithTitle:@"相机不可用，或未授权"
                                     message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机。", appName]];
                }
            });
        }];
    }
}

- (UIImagePickerController *)imagePickerControllerFromVC:(UIViewController *)viewController
                                              sourceType:(UIImagePickerControllerSourceType)sourceType  {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    [viewController presentViewController:imagePicker animated:YES completion:nil];
    return imagePicker;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    MSAlertController *alertCtrl = [MSAlertController alertControllerWithTitle:title message:message preferredStyle:MSAlertControllerStyleAlert];
    [alertCtrl showCancel:@"确定" handler:nil];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    typeof(self) __weak weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        weakSelf.didFinishTakeMediaCompled = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.selctedPhotoArry  = [[NSMutableArray alloc]init];
    [self.selctedPhotoArry addObject:image];
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(self.selctedPhotoArry, editingInfo);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(nil, info);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
}

- (void)showMultiselectPhotoPickonViewController:(UIViewController *)viewController {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = PHOTO_MAX;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    [picker setDelegate:(id<UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>)self];
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [viewController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerControllerDelegate

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    self.selctedPhotoArry  = [[NSMutableArray alloc] init];
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.selctedPhotoArry addObject:tempImg];
    }
    
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(self.selctedPhotoArry,nil);
    }
}

@end
