//
//  NSMutableArray+Estension.m
//  ZHDJ
//
//  Created by LTWL on 2017/9/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NSMutableArray+Estension.h"

@implementation NSMutableArray (Estension)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(lai_objectAtIndex:));
        method_exchangeImplementations(fromMethod, toMethod);
    });
}

- (void)lai_objectAtIndex:(NSUInteger)index {
    if (self.count - 1 < index) {
        @try {
            return [self lai_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"%s%@", __func__, exception.reason);
        }
        @finally {
            
        }
    }else {
        return [self lai_objectAtIndex:index];
    }
}

@end
