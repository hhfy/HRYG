//
//  HomeSeasonTicketOrderHeaderView.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/1/3.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeSeasonTicketOrderPackage;
@interface HomeSeasonTicketOrderHeaderView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) HomeSeasonTicketOrderPackage *orderPackage;
@end
