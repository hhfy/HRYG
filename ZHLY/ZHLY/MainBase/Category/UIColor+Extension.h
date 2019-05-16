//
//  UIColor+Extension.h
//
//  Created by LTWL on 2017/5/16.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *) colorWithHex:(NSString *)hexColor;
+ (UIColor *) colorWithHex:(NSString *)hexColor alpha:(float)opacity;
@end
