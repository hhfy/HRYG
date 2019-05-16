//
//  HomeExhibitionHallSelectSeatView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectSeatBlock)();

@interface HomeExhibitionHallSelectSeatView : UIView
@property (nonatomic, copy) SelectSeatBlock selectSeat;
@end
