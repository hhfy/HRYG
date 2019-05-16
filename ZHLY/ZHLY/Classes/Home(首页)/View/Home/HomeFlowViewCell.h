//
//  HomeFlowViewCell.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/2/8.
//  Copyright © 2018年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeFlowViewCellBlock)(NSArray *imgArr);

@interface HomeFlowViewCell : UITableViewCell
@property(nonatomic,strong)NSArray *sceneArr;
@property (nonatomic, copy) HomeFlowViewCellBlock imgTapBack;
@end


