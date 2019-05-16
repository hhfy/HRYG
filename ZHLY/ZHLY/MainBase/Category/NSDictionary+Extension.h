//
//  NSDictionary+Extension.h
//  ZHLY
//
//  Created by LTWL on 2017/12/25.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
/// 根据实例对象转成字典
+ (NSDictionary *)createDictionayFromModelPropertiesWithObj:(id)obj;
@end
