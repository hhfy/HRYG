//
//  TravelsSendTravelsTitleLabelCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/1.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleDidInputBlock)(NSString *title);
typedef void(^TagLabelBtnDidSelectedBlock)(NSArray *tagId);

@class TravelStadium;
@interface TravelsSendTravelsTitleLabelCell : UITableViewCell
@property (nonatomic, copy) TitleDidInputBlock inputTitle;
@property (nonatomic, copy) TagLabelBtnDidSelectedBlock selectedTag;
@property (nonatomic, strong) NSArray<TravelStadium *> *stadiums;
@end
