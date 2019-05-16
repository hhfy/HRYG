//
//  HomeShoppingCarCommitView.h
//  ZHLY
//
//  Created by LTWL on 2017/12/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CheckAllBlock)(BOOL isCheckAll);
typedef void(^CommitBlock)();

@interface HomeShoppingCarCommitView : UIView
@property (nonatomic, copy) CheckAllBlock checkAll;
@property (nonatomic, copy) CommitBlock commit;
@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, assign) NSInteger goodsCount;
@property (nonatomic, assign) BOOL isCheckAll;
@end
