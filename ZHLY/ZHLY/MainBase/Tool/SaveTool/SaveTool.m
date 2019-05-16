//
//  SaveTool.m
//
//  Created by LTWL on 2016/11/24.
//  Copyright © 2016年 赖同学. All rights reserved.
//

#import "SaveTool.h"

#define UserDefault [NSUserDefaults standardUserDefaults]
@implementation SaveTool

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    if (!value) return;
    [UserDefault setObject:value forKey:defaultName];
    [UserDefault synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [UserDefault setBool:value forKey:defaultName];
    [UserDefault synchronize];
}

+ (id)objectForKey:(NSString *)defaultName
{
    return (defaultName) ? [UserDefault objectForKey:defaultName] : nil;
}

+ (void)removeObjectForKey:(NSString *)defaultName {
    [UserDefault removeObjectForKey:defaultName];
}

@end
