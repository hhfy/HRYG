//
//  BaseViewController.h
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NetworkForOnlineBlock)(void);
typedef void(^NetworkForInterruptBlock)(void);
typedef void(^ReloadDataBlock)(void);

@interface BaseViewController : UIViewController
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy) NetworkForOnlineBlock networkForOnline;
@property (nonatomic, copy) NetworkForInterruptBlock networkForInterrupt;
@property (nonatomic, copy) ReloadDataBlock reloadData;
@property (nonatomic, assign) BOOL isPush; //用于判断页面是否是push出来还是pop回来
@end
