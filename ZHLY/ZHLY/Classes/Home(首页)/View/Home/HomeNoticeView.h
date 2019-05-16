//
//  HomeNoticeView.h
//  ZHDJ
//
//  Created by LTWL on 2017/8/12.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeNotify, HomeNoticeView;
@protocol HomeNoticeViewDelegate <NSObject>
@optional
- (void)homeNoticeView:(HomeNoticeView *)homeNoticeView didClickWithId:(NSString *)Id;
@end

@interface HomeNoticeView : UITableViewHeaderFooterView
@property (nonatomic, weak) id<HomeNoticeViewDelegate> delegate;
@property (nonatomic, strong) NSArray *texts;
- (void)shutDownTimer;
@end
