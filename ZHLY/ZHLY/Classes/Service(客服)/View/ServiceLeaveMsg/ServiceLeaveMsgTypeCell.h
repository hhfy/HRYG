//
//  ServiceLeaveMsgTypeCell.h
//  ZHLY
//
//  Created by LTWL on 2017/11/28.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ArrowBtnTapBlock)();

@interface ServiceLeaveMsgTypeCell : UITableViewCell
@property (nonatomic, copy) NSString *typeText;
@property (nonatomic, copy) ArrowBtnTapBlock didTap;
@end
