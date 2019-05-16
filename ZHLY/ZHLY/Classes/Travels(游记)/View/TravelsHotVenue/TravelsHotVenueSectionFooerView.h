//
//  TravelsHotVenueSectionFooerView.h
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidTapMoreBtnBlock)();

@interface TravelsHotVenueSectionFooerView : UITableViewHeaderFooterView
@property (nonatomic, copy) DidTapMoreBtnBlock didTap;
@end
