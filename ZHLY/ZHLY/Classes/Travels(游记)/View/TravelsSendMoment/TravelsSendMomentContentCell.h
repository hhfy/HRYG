//
//  TravelsSendMomentContentCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/2.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextDidInputBlock)(NSString *text);

@interface TravelsSendMomentContentCell : UITableViewCell
@property (nonatomic, copy) TextDidInputBlock inputText;
@property (nonatomic, copy) NSString *content;
@end
