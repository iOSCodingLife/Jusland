//
//  MSGeneralViewController.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCellGroup.h"

@interface MSGeneralViewController : UITableViewController

- (NSArray <MSCellGroup *> *)dataSource;

@end
