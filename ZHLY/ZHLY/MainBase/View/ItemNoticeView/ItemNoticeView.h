//
//  ItemNoticeView.h
//  ZHDJ
//
//  Created by LTWL on 2017/9/13.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemNoticeView : UIView
@property (nonatomic, copy) NSString *noticeTitle;
@property (nonatomic, copy) NSString *noticeImage;
- (void)show;
- (void)dismissWithCompletion:(void(^)())completion;
- (void)addTarget:(id)target action:(SEL)action;
@end
