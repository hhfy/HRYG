//
//  PaymentCell.h
//  GXBG
//
//  Created by LTWL on 2017/11/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PaymentSeletedTypeBlock)(NSInteger index);

@interface PaymentCell : UITableViewCell
@property (nonatomic, copy) PaymentSeletedTypeBlock paymentSeletedType;
@property (nonatomic, strong) NSArray *payTypeList;
@end
