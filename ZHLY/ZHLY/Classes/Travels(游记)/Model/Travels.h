//
//  Travels.h
//  ZHLY
//
//  Created by LTWL on 2017/11/29.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 游记首页场馆
@interface TravelStadium : NSObject
@property (nonatomic, copy) NSString *supplier_stadium_id;//场馆id
@property (nonatomic, copy) NSString *supplier_scene_id;//景点id
@property (nonatomic, copy) NSString *stadium_name;
@property (nonatomic, copy) NSString *stadium_image;                // 场馆背景图
@property (nonatomic, assign) NSInteger stadium_people;             // 游玩人数
@property (nonatomic, assign) NSInteger stadium_notes;              // 游记篇数
@property (nonatomic, assign) NSInteger stadium_tips;               // 攻略篇数
@property (nonatomic, assign) NSInteger stadium_image_number;       // 相册图片数量
@property (nonatomic, copy) NSString *stadium_introduction;
@property (nonatomic, copy) NSString *shop_id;
@end

/// 游记和攻略列表
@interface TravelNoteTip : NSObject
@property (nonatomic, copy) NSString *travel_notes_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *member_profile_image;
@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger type;                       // 1：游记 2：攻略
@end

/// 交通指南地址
@interface TravelTrafficAddress : NSObject
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) double lon;                           // 经度
@property (nonatomic, assign) double lat;                           // 维度
@end

/// 交通指南路线
@interface TravelTrafficLines : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger icon;                       // 1:航空路线2：火车路线3：大巴路线4：高速路线5：自驾路线
@property (nonatomic, copy) NSString *content;
@end

/// 交通指南顶部广告
@interface TravelTrafficAd : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *url;
@end

@interface TravelTrafficIndex : NSObject
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) TravelTrafficAddress *address;
@property (nonatomic, strong) NSArray *list;
@end

/// 精彩分享
@interface TravelMoment : NSObject
@property (nonatomic, copy) NSString *travel_tweet_id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *member_phone;
@property (nonatomic, copy) NSString *member_profile_image;
@end
