//
//  Profile.h
//  ZHLY
//
//  Created by LTWL on 2017/12/7.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileFeedbackType : NSObject
@property (nonatomic, copy) NSString *sys_fd_type_id;
@property (nonatomic, copy) NSString *sys_fd_type_title;
@end


@interface ProfileInfo : NSObject
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *member_type;
@property (nonatomic, copy) NSString *member_account;
@property (nonatomic, copy) NSString *member_phone;
@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *member_profile_image;
@property (nonatomic, assign) NSInteger member_sex;
@property (nonatomic, copy) NSString *member_birthday;
@property (nonatomic, copy) NSString *member_card;
@property (nonatomic, copy) NSString *member_level;
@property (nonatomic, copy) NSString *member_coins;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *update_time;
@end

//订单列表
@interface ProfileOrderTicketList : NSObject
@property (nonatomic, copy) NSString *ticket_name;
@property (nonatomic, copy) NSString *ticket_image;
@property (nonatomic, copy) NSString *ticket_pay_price;
@property (nonatomic, copy) NSString *ticket_count;
@property (nonatomic, copy) NSString *supplier_ticket_id;
@property (nonatomic, copy) NSString *site_name;
@property (nonatomic, copy) NSString *ticket_starttime;
@property (nonatomic, copy) NSString *ticket_endtime;
@property (nonatomic, copy) NSString *biz_ticket_id;
@end
@interface ProfileOrderIndex : NSObject
@property (nonatomic, copy) NSString *biz_order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *order_sale_price;
@property (nonatomic, copy) NSString *biz_activity_discount;
@property (nonatomic, copy) NSString *order_pay_price;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, assign) NSInteger order_status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *pay_type_name;
@property (nonatomic, copy) NSString *order_status_name;
@property (nonatomic, strong) NSArray *ticket_list;
@end
@interface ProfileOrderModel : NSObject
@property (nonatomic, strong) NSMutableArray *list;
@end

//订单详情
@interface ProfileOrderInfo : NSObject
@property (nonatomic, copy) NSString *biz_order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *order_sale_price; //订单金额
@property (nonatomic, copy) NSString *biz_activity_discount;//优惠金额
@property (nonatomic, copy) NSString *biz_check_code;//验证码
@property (nonatomic, copy) NSString *order_pay_price;//应付金额
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *order_linkman;
@property (nonatomic, copy) NSString *order_linktel; //游客联系方式
@property (nonatomic, copy) NSString *order_linkcard;//游客证件照
@property (nonatomic, copy) NSString *pay_time;
@property (nonatomic, copy) NSString *invoice_type;//发票类型
@property (nonatomic, copy) NSString *invoice_title;//发票抬头
@property (nonatomic, copy) NSString *invoice_taxno;//发票税号
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *refund_type;//退款类型
@property (nonatomic, copy) NSString *refund_reason;//退款原因
@property (nonatomic, copy) NSString *refund_rreason;//退款拒绝原因
@property (nonatomic, copy) NSString *refund_status;//退款状态
@property (nonatomic, copy) NSString *order_status_name;//订单状态
@property (nonatomic, copy) NSString *pay_type_status;//支付类型
@end
@interface ProfileOrderDetail : NSObject
@property (nonatomic, strong) NSMutableArray *ticket_list;
@property (nonatomic, strong) ProfileOrderInfo *order_info;
@end

/// 我的反馈
@interface ProfileMyFeedBackMsg : NSObject
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *sys_fd_content;
@property (nonatomic, copy) NSString *sys_fd_id;
@property (nonatomic, copy) NSString *sys_fd_reply;
@property (nonatomic, copy) NSString *sys_fd_reply_time;
@property (nonatomic, copy) NSString *sys_fd_type_title;
@property (nonatomic, assign) NSInteger sys_fd_status;  //1已回复  2未回复
@end

@interface ImagesArray : NSObject
@property (nonatomic, strong) NSArray *photosArr;
@end
@interface ProfileReviews : NSObject
@property (nonatomic, strong) NSMutableArray *scoreArr;
@property (nonatomic, strong) NSMutableArray *textArr;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@end

/// 优惠券
@interface ProfileCoupon : NSObject
@property (nonatomic, copy) NSString *biz_pt_id;
@property (nonatomic, copy) NSString *pt_name;
@property (nonatomic, copy) NSString *pt_stime;//开始时间
@property (nonatomic, copy) NSString *pt_etime;//结束时间
@property (nonatomic, copy) NSString *pt_num;//最多参与次数
@property (nonatomic, copy) NSString *pt_limit;//订单金额限制,单位元
@property (nonatomic, copy) NSString *pt_discount;//优惠金额或折扣
@property (nonatomic, copy) NSString *pt_coupon_no;//优惠券数量
@property (nonatomic, assign) NSInteger pt_range;//参与活动产品范围：0全部产品；1.部分产品
@property (nonatomic, copy) NSString *pt_image;//
@property (nonatomic, copy) NSString *pt_intro;//简介
@property (nonatomic, copy) NSString *pt_article;//图文说明
@property (nonatomic, assign) NSInteger is_get;//1可参与，2代表已达到最大参与次数
@property (nonatomic, assign) NSInteger status;//状态  1未开始  2进行中  3已结束
@property (nonatomic, assign) NSInteger surplus_num;//剩余数量
@property (nonatomic, copy) NSString *pt_buy_intro;//购买须知
@property (nonatomic, copy) NSString *pt_use_intro;//使用须知
@end



