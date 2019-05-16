//
//  Home.h
//  ZHLY
//
//  Created by LTWL on 2017/12/6.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeAd : NSObject
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *url;
@end
//首页菜单
@interface HomeMenu : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@end
@interface HomeNotify : NSObject
@property (nonatomic, copy) NSString *app_notify_id;
@property (nonatomic, copy) NSString *notify_title;
@property (nonatomic, copy) NSString *url;
@end
@interface HomeScene : NSObject
@property (nonatomic, copy) NSString *scene_name;
@property (nonatomic, strong) NSArray *scene_photo_album;
@property (nonatomic, copy) NSString *supplier_scene_id;
@end
//首页
@interface HomeHomeModel : NSObject
@property (nonatomic, strong)NSArray *ad1;
@property (nonatomic, strong)NSArray *ad2;
@property (nonatomic, strong)NSArray *menu;
@property (nonatomic, strong)NSArray *notify;
@property (nonatomic, strong)NSArray *scene;
@end

//支付方式
@interface TicketPayType : NSObject
@property (nonatomic, copy) NSString *pay_name;
@property (nonatomic, copy) NSString *pay_type;
@end

/// 博物馆评分列表
@interface HomeMuseumScoreList : NSObject
@property (nonatomic, copy) NSString *member_profile_image;
@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *evaluate_text;
@property (nonatomic, strong) NSArray *evaluate_images;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *scene_name;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, copy) NSString *ticket_name;
@end

/// 景点信息（通用）
@interface HomeMuseumInfo : NSObject
@property (nonatomic, copy) NSString *scene_address;
@property (nonatomic, copy) NSString *scene_name;
@property (nonatomic, copy) NSString *scene_image;
@property (nonatomic, copy) NSString *supplier_scene_id;
@property (nonatomic, copy) NSString *scene_evaluate_score_avg;
@property (nonatomic, strong) NSArray *date;
@property (nonatomic, assign) CGFloat scene_photo_album_count;
@property (nonatomic, copy) NSString *scene_latitude;
@property (nonatomic, copy) NSString *scene_longitude;
@property (nonatomic, copy) NSString *scene_evaluate_num;
@property (nonatomic, copy) NSString *biz_hotel_id;
@end

/// 父类模型
@interface HomeShopBaseInfo : NSObject
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, assign) NSInteger bannerCount;
@property (nonatomic, copy) NSString *leftViewTitle;
@property (nonatomic, copy) NSString *leftViewDetialText;
@property (nonatomic, assign) CGFloat startCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *detialApi;
@property (nonatomic, copy) NSString *scene_latitude;
@property (nonatomic, copy) NSString *scene_longitude;
@property (nonatomic, strong) NSArray *date;
@end

/// 门票
@interface HomeTicket : NSObject
@property (nonatomic, copy) NSString *supplier_ticket_id;//票种ID
@property (nonatomic, copy) NSString *ticket_name;
@property (nonatomic, copy) NSString *biz_ticket_id;//可售票ID
@property (nonatomic, copy) NSString *ticket_sale_price;
@property (nonatomic, copy) NSString *ticket_image;
@property (nonatomic, assign) NSInteger biz_sess_id;//场次ID
@property (nonatomic, assign) NSInteger ticket_remain_num; //剩余数量
@property (nonatomic, copy) NSString *site_name;    //座位名称
@property (nonatomic, copy) NSString *biz_room_id; //表明为酒店ID
@property (nonatomic, copy) NSString *start_date; //
@property (nonatomic, copy) NSString *end_date; //
//

@property (nonatomic, copy) NSString *shop_id;
//@property (nonatomic, copy) NSString *ticket_price;             // 票价
@property (nonatomic, assign) NSInteger ticket_num;             // 起售张数
@property (nonatomic, copy) NSString *ticket_use_people;        // 最多使用人数
@property (nonatomic, assign) NSInteger ticket_use_times;       // 最多使用次数
@property (nonatomic, copy) NSString *ticket_summary;           // 简介
@property (nonatomic, copy) NSString *ticket_detail;            // 详情
@property (nonatomic, strong) NSArray *ticket_intro_content;    // 购票,放票,退票,费用包含,费用不包含
@property (nonatomic, assign) NSInteger ticket_store_isopen;    // 库存是否开启1:是；2:否
//@property (nonatomic, assign) NSInteger ticket_remain_num;       // 当前库存数
@property (nonatomic, assign) NSInteger ticket_status;          // 门票状态:1.信息待完善;2.下架申请;3.已下架;4.上架申请;5.已上架
@property (nonatomic, copy) NSString *ticket_deadline_text;     // 有效日期显示
@property (nonatomic, assign) NSInteger ticket_type;            // 1:非套票2：是套票
@property (nonatomic, assign) NSInteger ticket_intro_type;      // 1在线选坐  2博物馆  3观光马车
//@property (nonatomic, assign) CGFloat totalPrice;               // 模型总价
@property (nonatomic, assign) CGFloat need_pay;               // 模型总价
@property (nonatomic, assign) NSInteger totalCount;             // 模型数量
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *ticket_buy_intro;//购买须知
@property (nonatomic, copy) NSString *ticket_refund_intro;//退票须知
@property (nonatomic, copy) NSString *ticket_use_intro;//使用须知
@end

/// 订单联系人
@interface HomeMuseumUserVisitor : NSObject
@property (nonatomic, copy) NSString *biz_visitor_id;//游客信息ID
@property (nonatomic, copy) NSString *biz_member_id;//
@property (nonatomic, copy) NSString *visitor_name;
@property (nonatomic, copy) NSString *visitor_mobile;
@property (nonatomic, copy) NSString *visitor_type_number;      // 身份号
@property (nonatomic, assign) NSInteger visitor_type;           // 证件类型：1身份证
@property (nonatomic, assign) NSInteger is_default;             // 是否默认  1默认  2不默认
@end


/// 套票
@interface HomeMuseumSeasonTickets : NSObject
@property (nonatomic, copy) NSString *biz_pt_id;          // 套票ID
@property (nonatomic, copy) NSString *pt_discount;        // 优惠金额
@property (nonatomic, copy) NSString *pt_etime;           // 套票活动结束时间
@property (nonatomic, copy) NSString *pt_has_sale;        // 已售
@property (nonatomic, copy) NSString *pt_image;           // 首页图
@property (nonatomic, copy) NSString *pt_limit;           // 原价
@property (nonatomic, copy) NSString *pt_name;            // 套票名称
@property (nonatomic, copy) NSString *pt_sale_price;      // 售价
@property (nonatomic, copy) NSString *pt_stime;           // 套票活动开始时间
@property (nonatomic, copy) NSString *pt_surplus;         // 库存
@property (nonatomic, copy) NSString *buyNum;         // 购买数量
@property (nonatomic, copy) NSString *useDate;         // 使用日期
@end

/// 购物车(门票)
@interface HomeShoppingCarTicket : NSObject
@property (nonatomic, copy) NSString *add_time;           // 添加时间
@property (nonatomic, copy) NSString *biz_cart_id;           // 购物车id
@property (nonatomic, copy) NSString *biz_ticket_id;                // 可售票ID
@property (nonatomic, copy) NSString *site_name;    //座位名称
@property (nonatomic, copy) NSString *stadium_name;    //场馆名称
@property (nonatomic, assign) NSInteger ticket_lock_num;             //购买张数
@property (nonatomic, copy) NSString *ticket_name;              // 票名
@property (nonatomic, assign) NSInteger ticket_remain_num;       // 门票剩余张数
@property (nonatomic, copy) NSString *ticket_sale_price;             // 价格
@property (nonatomic, copy) NSString *ticket_check_stime;             // 使用日期

@property (nonatomic, copy) NSString *biz_sess_id; //

@property (nonatomic, copy) NSString *supplier_ticket_id;           // 票种id
@property (nonatomic, copy) NSString *ticket_image;             // 配图
//@property (nonatomic, assign) NSInteger nums;                   // 加入购物车的数量
@property (nonatomic, copy) NSString *shop_name;                // 景点名称
@property (nonatomic, copy) NSString *date;                     // 使用日期
@property (nonatomic, assign) NSInteger ticket_store_isopen;    // 库存是否开启1:是；2:否
@property (nonatomic, assign) NSInteger ticket_num;             // 起售张数
@property (nonatomic, copy) NSString *ticket_deadline_text;
@property (nonatomic, assign) NSInteger totalCount;             // 模型总数
@property (nonatomic, assign) CGFloat totalPrice;               // 模型总价
@property (nonatomic, strong) NSArray *ticket_intro_content;    // 购票,放票,退票,费用包含,费用不包含
@property (nonatomic, copy) NSString *ticket_buy_intro;//购买须知
@property (nonatomic, copy) NSString *ticket_refund_intro;//退票须知
@property (nonatomic, copy) NSString *ticket_use_intro;//使用须知
@property (nonatomic, copy) NSString *start_date;
@property (nonatomic, copy) NSString *end_date;
@end

//非套票下单
@interface HomeTicketMainOrder : NSObject
@property (nonatomic, copy) NSString *need_pay;
@property (nonatomic, strong) NSArray *pay_list;
@property (nonatomic, strong) NSArray *ticket_link;
@property (nonatomic, strong) HomeMuseumUserVisitor *visitor_info;
@end

/// 购物车(酒店)
@interface HomeShoppingCarHotel : NSObject
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *hotel_id;  
@property (nonatomic, copy) NSString *room_name;                // 酒店名称
@property (nonatomic, copy) NSString *price;                    // 价格
@property (nonatomic, copy) NSString *room_start_time;          // 入住时间
@property (nonatomic, copy) NSString *room_end_time;            // 离店日期
@property (nonatomic, copy) NSString *s_date;                   // 住店日期
@property (nonatomic, copy) NSString *e_date;                   // 离店日期
@property (nonatomic, copy) NSString *biz_cart_id;           // 购物车id
@property (nonatomic, copy) NSString *home_image;               // 图片
@property (nonatomic, assign) NSInteger room_nums;              // 房间数
@property (nonatomic, assign) NSInteger number;                 // 房间数
@property (nonatomic, assign) NSInteger totalCount;             // 模型总数
@property (nonatomic, assign) CGFloat totalPrice;               // 模型总价
@end

/// 套票订单（票信息）-旧
@interface HomeSeasonTicketOrderSonList : NSObject
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *ticket_deadline;
@property (nonatomic, copy) NSString *ticket_id;
@property (nonatomic, copy) NSString *ticket_image;
@property (nonatomic, strong) NSArray *ticket_intro_content;    //购买须知
@property (nonatomic, copy) NSString *ticket_isown;
@property (nonatomic, copy) NSString *ticket_name;
@property (nonatomic, copy) NSString *ticket_num;
@property (nonatomic, copy) NSString *ticket_number;
@property (nonatomic, copy) NSString *ticket_price;
@property (nonatomic, copy) NSString *ticket_print;
@property (nonatomic, copy) NSString *ticket_status;
@property (nonatomic, assign) NSInteger ticket_store_isopen; // 库存是否开启1:是；2:否
@property (nonatomic, assign) NSInteger ticket_store_num;
@property (nonatomic, copy) NSString *ticket_summary;
@property (nonatomic, copy) NSString *ticket_type;
@property (nonatomic, copy) NSString *ticket_use_people;
@property (nonatomic, copy) NSString *ticket_use_times;
@end

/// 套票订单（订单信息）-旧
@interface HomeSeasonTicketOrderTicketInfo : NSObject
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, strong) NSArray *son_list;       //对应张数详情
@property (nonatomic, copy) NSString *ticket_deadline; //门票有效期：0.永久有效;1.当天有效;2.两天有效以此类推, 999.以场次有效期为准
@property (nonatomic, copy) NSString *ticket_deadline_text;     //2017-12-15 当日有效 日期信息
@property (nonatomic, copy) NSString *ticket_id;                // 票封面
@property (nonatomic, copy) NSString *ticket_image;             // 票价格
@property (nonatomic, strong) NSArray *ticket_intro_content;    // 购买须知
@property (nonatomic, copy) NSString *ticket_isown;             //是否独立销售  1是2否
@property (nonatomic, copy) NSString *ticket_name;              //
@property (nonatomic, copy) NSString *ticket_num;
@property (nonatomic, copy) NSString *ticket_price;
@property (nonatomic, copy) NSString *ticket_print;
@property (nonatomic, copy) NSString *ticket_status;
@property (nonatomic, assign) NSInteger ticket_store_isopen; // 库存是否开启1:是；2:否
@property (nonatomic, assign) NSInteger ticket_store_num;    //当前库存数
@property (nonatomic, copy) NSString *ticket_summary;        //简介
@property (nonatomic, copy) NSString *ticket_type;           //1:非套票2：是套票
@property (nonatomic, copy) NSString *ticket_use_people;     //最多可使用人数
@property (nonatomic, copy) NSString *ticket_use_times;      //0:不限使用次数
@property (nonatomic, assign) CGFloat totalPrice;            // 模型总价
@property (nonatomic, assign) NSInteger totalCount;             // 模型数量
@property (nonatomic, copy) NSString *date;
@end

//
@interface HomeSeasonTicketOrderTicketList : NSObject
@property (nonatomic, copy) NSString *supplier_ticket_id;//票种id
@property (nonatomic, copy) NSString *ticket_name;
@property (nonatomic, copy) NSString *ticket_sale_price;//原价
@property (nonatomic, copy) NSString *ticket_image;
@property (nonatomic, copy) NSString *ticket_remain_num;//库存
@property (nonatomic, copy) NSString *pt_ticket_price;//售价
@property (nonatomic, copy) NSString *pt_ticket_num;//套票数量
@property (nonatomic, copy) NSString *biz_pt_id;
@property (nonatomic, copy) NSString *biz_ticket_id;//可售票id

@end

/// 套票订单
@interface HomeSeasonTicketOrderPackage : NSObject
@property (nonatomic, copy) NSString *need_pay;
@property (nonatomic, strong) NSArray *ticket_list;
//@property (nonatomic, strong) HomeSeasonTicketOrderTicketInfo *ticket_info;
@property (nonatomic, strong) HomeMuseumUserVisitor *visitor_info;//联系人信息
@end

/// 商品
@interface HomeGoods : NSObject
@property (nonatomic, copy) NSString *wlbm;                     // 商品编码
@property (nonatomic, copy) NSString *wlmc;                     // 物料名称
@property (nonatomic, copy) NSString *zwm;                      // 中文名
@property (nonatomic, copy) NSString *zjldw;                    // 主计量单位
@property (nonatomic, copy) NSString *fjldw;                    // 辅计量单位
@property (nonatomic, copy) NSString *bm;                       // 物料别名
@property (nonatomic, copy) NSString *ggxh;                     // 规格型号
@property (nonatomic, copy) NSString *djbm;                     // 等级编码
@property (nonatomic, copy) NSString *chlx;                     // 存货类型
@property (nonatomic, copy) NSString *wlfl;                     // 物料分类：原材料ycl、产品cp、半成品bcp
@property (nonatomic, copy) NSString *tm;                       // 条码
@property (nonatomic, copy) NSString *zjldwsl;                  // 主计量单位数量
@property (nonatomic, copy) NSString *fjldwsl;                  // 辅计量单位数量
@property (nonatomic, copy) NSString *slv;                      // 税率
@end


/// 酒店信息
@interface HomeHotelInfo : NSObject
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, copy) NSString *hotel_image;
@property (nonatomic, copy) NSString *hotel_name;
@property (nonatomic, copy) NSString *hotel_address;
@property (nonatomic, copy) NSString *hotel_phone;
@end

/// 房间信息
@interface HomeHotelRoomInfo : NSObject
@property (nonatomic, copy) NSString *room_id;       //
@property (nonatomic, copy) NSString *room_name;     //名称
@property (nonatomic, copy) NSString *home_image;    //图片
@property (nonatomic, copy) NSString *price;         //价格
@property (nonatomic, copy) NSString *replay;        //1:不支持退款，2：支持退款
@property (nonatomic, copy) NSString *wifi;          //无线情况
@property (nonatomic, copy) NSString *breakfast;     //1包早  2不包早
@property (nonatomic, copy) NSString *window;        //窗子情况
@end

@interface HomeHotelRoomPriceDetail : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *price;
@end
/// 下单房间信息
@interface HomeHotelRoomOrderInfo : NSObject
@property (nonatomic, copy) NSString *area;         //面积
@property (nonatomic, copy) NSString *bathroom;     //卫浴情况
@property (nonatomic, copy) NSString *bed;          //床数量
@property (nonatomic, copy) NSString *bed_size;     //床型
@property (nonatomic, copy) NSString *breakfast;    //是否含早1包早  2不包早
@property (nonatomic, copy) NSString *create_time;  //无线情况
@property (nonatomic, copy) NSString *floor;        //楼层
@property (nonatomic, copy) NSString *home_image;   //图
@property (nonatomic, copy) NSString *hotel_id;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign)NSInteger number;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *replay;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, copy) NSString *room_number;
@property (nonatomic, copy) NSString *room_price;
@property (nonatomic, strong) NSArray *room_price_detail;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *wifi;
@property (nonatomic, copy) NSString *window;
@property (nonatomic, copy) NSString *checkTime; //入住时间
@property (nonatomic, copy) NSString *checkoutTime;//离店时间
@property (nonatomic, copy) NSString *totalPrice;
@end

/// 酒店下单数据
@interface HomeHotelRoomOrderConfirm : NSObject
@property (nonatomic, strong) NSArray *room_list;
@property (nonatomic, copy) NSString *ticket_link_list;
@property (nonatomic, copy) NSString *ticket_list;
@property (nonatomic, strong) HomeMuseumUserVisitor *user_visitor;
@end

@interface HomeTicketPayOrderInfo : NSObject
@property (nonatomic, copy) NSString *biz_activity_discount;
@property (nonatomic, copy) NSString *channel_pot_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *order_linkcard;
@property (nonatomic, copy) NSString *order_linkman;
@property (nonatomic, copy) NSString *order_linktel;
@property (nonatomic, copy) NSString *order_pay_price;
@property (nonatomic, copy) NSString *order_sale_price;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *order_use_type;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *biz_order_id;
@end

@interface HomeTicketPayInfo : NSObject
@property (nonatomic, copy) NSString *need_pay;
@property (nonatomic, copy) NSString *pay_info;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *nonce_str;
@property (nonatomic, strong) HomeTicketPayOrderInfo *order_info;
@end

@interface HomeNotice : NSObject
@property (nonatomic, copy) NSString *app_notify_id;
@property (nonatomic, copy) NSString *notify_title;
@property (nonatomic, copy) NSString *notify_etime;
@property (nonatomic, copy) NSString *create_time;
@end

@interface HomeNoticeList : NSObject
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) NSInteger total;
@end

//支付请求返回值
@interface AlipayInfo : NSObject
@property (nonatomic, copy)NSString *pay_type;
@property (nonatomic, copy)NSString *pay_info;
@end


@interface HomeSearchInfo : NSObject
@property (nonatomic, strong)NSArray *ticket;
@property (nonatomic, strong)NSArray *tickets;
@property (nonatomic, strong)NSArray *note;
@end
