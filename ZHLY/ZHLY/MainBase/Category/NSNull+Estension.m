//
//  NSNull+Estension.m
//  94.runtime机制的使用
//
//  Created by LTWL on 2017/9/14.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "NSNull+Estension.h"

#define NullObjects @[@"",@0,@{},@[]]
@implementation NSNull (Estension)
//必须返回一个方法签名不能为空
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature != nil) return signature;
    for (NSObject *object in NullObjects) {
        signature = [object methodSignatureForSelector:selector];
        if (signature) {
            //strcmp比较两个字符串，相同返回0
            //这里 @ 是指返回值为对象 id
            if (strcmp(signature.methodReturnType, "@") == 0) {
                signature = [[NSNull null] methodSignatureForSelector:@selector(lai_nil)];
            }
            break;
        }
    }
    return signature;
}
//消息转发的最后一步
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0) {
        anInvocation.selector = @selector(lai_nil);
        [anInvocation invokeWithTarget:self];
        return;
    }
     //遍历 查看 @"",@0,@{},@[]  那个响应了selector，然后丢给它去执行
    for (NSObject *object in NullObjects) {
        if ([object respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    //抛出异常
    [self doesNotRecognizeSelector:anInvocation.selector];
}

- (id)lai_nil {
    return nil;
}
@end
