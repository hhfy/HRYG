//
//  ProfileReviewsVC.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/6.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "BaseViewController.h"

@class ProfileOrderIndex;
@interface ProfileReviewsVC : BaseViewController
@property(nonatomic,copy)NSString *bizOrderId;
@property(nonatomic,strong)ProfileOrderIndex *orderIndex;
@end
