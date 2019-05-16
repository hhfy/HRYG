//
//  HomeMuseumOrderSpecialTicketView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/8.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewDetialBtnTapBlock)(void);

@interface HomeShopBaseOrderSpecialTicketView : UITableViewHeaderFooterView
@property (nonatomic, copy) ViewDetialBtnTapBlock didTap;
@property (nonatomic, copy) NSString *title;
@end
