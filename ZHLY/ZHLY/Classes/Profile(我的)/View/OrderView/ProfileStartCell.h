//
//  ProfileStartCell.h
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/6.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StarBlock)(CGFloat currentScore);

@interface ProfileStartCell : UITableViewCell
@property (nonatomic, copy) StarBlock starBlock;
@property (nonatomic, copy) NSString *currentScore;
@end
