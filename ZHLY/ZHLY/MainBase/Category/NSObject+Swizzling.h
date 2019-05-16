//
//  NSObject+Swizzling.h
//  ZHDJ
//
//  Created by LTWL on 2017/9/15.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)
/// runtime替换动态方法封装
+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;
@end
