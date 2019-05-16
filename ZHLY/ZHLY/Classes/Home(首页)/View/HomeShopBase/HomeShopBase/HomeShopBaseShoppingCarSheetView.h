//
//  HomeMuseumShoppingCarSheetVIew.h
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewDissmissCallbackBlock)(NSInteger count);

@class HomeTicket;
@interface HomeShopBaseShoppingCarSheetView : UIView
@property (nonatomic, strong) HomeTicket *museumTicket;
@property (nonatomic, copy) ViewDissmissCallbackBlock dismissCallBack;
- (void)show;
@end
