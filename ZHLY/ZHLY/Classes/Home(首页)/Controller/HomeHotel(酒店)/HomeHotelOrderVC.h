//
//  HomeHotelOrderVC.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2017/12/19.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "BaseViewController.h"

@class HomeHotelRoomOrderInfo,HomeMuseumUserVisitor;
@interface HomeHotelOrderVC : BaseViewController
@property(nonatomic,strong) HomeHotelRoomOrderInfo *roomOrderInfo;
@property(nonatomic,copy) NSString *hotelName;
//@property(nonatomic,copy) NSString *checkTime;
//@property(nonatomic,copy) NSString *checkoutTime;
@property(nonatomic,strong) HomeMuseumUserVisitor *userVisitor;
@end
