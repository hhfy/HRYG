//
//  HomeSeasonTicketOrderInfoView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/20.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissBlock)(void);

@class HomeSeasonTicketOrderPackage;
@interface HomeSeasonTicketOrderInfoView : UIView
//@property (nonatomic, strong) NSArray *content;
@property (nonatomic, copy) DismissBlock dismiss;
@property (nonatomic, strong) HomeSeasonTicketOrderPackage *orderPackage;
@end
