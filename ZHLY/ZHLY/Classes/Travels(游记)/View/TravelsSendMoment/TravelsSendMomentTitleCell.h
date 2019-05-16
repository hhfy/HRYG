//
//  TravelsSendMomentTitleCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleDidInputBlock)(NSString *title);

@interface TravelsSendMomentTitleCell : UITableViewCell
@property (nonatomic, copy) TitleDidInputBlock inputTitle;
@end
