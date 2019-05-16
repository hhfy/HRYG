//
//  HomeMuseumEditTouristVC.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    OperationTypeAdd,
    OperationTypeEdit,
} OperationType;

@interface HomeShopBaseEditTouristVC : BaseViewController
@property (nonatomic, assign) OperationType operationType;
@end
