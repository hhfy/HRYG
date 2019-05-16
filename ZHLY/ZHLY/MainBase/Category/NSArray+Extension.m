//
//  NSArray+Estension.m
//
//  Created by LTWL on 2017/6/22.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)
+ (NSArray *)arrayFromatFromJsonDataString:(NSString *)string {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(objectAtIndex:)
                               bySwizzledSelector:@selector(lai_objectAtIndex:)];
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
