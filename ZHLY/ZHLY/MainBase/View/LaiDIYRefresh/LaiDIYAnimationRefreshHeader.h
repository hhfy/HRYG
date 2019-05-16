//
//  LaiDIYAnimationRefreshHeader.h
//  ZHLY
//
//  Created by Mr Lai on 2017/12/30.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
@class LaiLoaddingView
@interface LaiDIYAnimationRefreshHeader : MJRefreshHeader
@property (strong, nonatomic) LaiLoaddingView *loadingPanel;
@end

