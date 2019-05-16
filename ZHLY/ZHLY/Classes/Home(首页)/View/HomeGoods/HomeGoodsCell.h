//
//  HomeGoodsCellTableViewCell.h
//  ZHLY
//
//  Created by LTWL on 2017/12/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeGoods;
@interface HomeGoodsCell : UITableViewCell
@property (nonatomic, strong) HomeGoods *goods;
@end


@interface HomeGoodsPriceLabel : UILabel

@end
