//
//  MSPhotographyHelper.h
//  MIS
//
//  Created by Nie on 2017/2/16.
//  Copyright © 2017年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DidFinishTakeMediaCompledBlock)(NSMutableArray *imageArry, NSDictionary *editingInfo);

@interface MSPhotographyHelper : NSObject

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType
                            onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled;

@end
