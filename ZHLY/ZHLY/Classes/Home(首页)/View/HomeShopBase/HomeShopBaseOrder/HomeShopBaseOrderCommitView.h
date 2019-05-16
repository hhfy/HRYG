//
//  HomeMuseumOrderCommitView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitBtnTapBlock)();

@interface HomeShopBaseOrderCommitView : UIView
@property (nonatomic, assign) double price;
@property (nonatomic, copy) CommitBtnTapBlock didTap;
@end
