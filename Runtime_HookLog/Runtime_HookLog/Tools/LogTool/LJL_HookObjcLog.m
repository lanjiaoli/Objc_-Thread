//
//  LJL_HookObjcLog.m
//  CustomKVO
//
//  Created by L on 2019/3/31.
//  Copyright © 2019 L. All rights reserved.
//

#import "LJL_HookObjcLog.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation LJL_HookObjcLog
+ (LJL_HookObjcLog *)logManage{
    static LJL_HookObjcLog * objLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objLog = [[LJL_HookObjcLog alloc]init];
    });
    return objLog;
}
- (void)ljl_exchangeMethodWithClass:(Class)cls
                        originalSEL:(SEL)originalSEL
                          changeSEL:(SEL)changeSEL{
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method changeMethod = class_getInstanceMethod(cls, changeSEL);
    method_exchangeImplementations(originalMethod, changeMethod);
}

- (void)recordHookClass:(Class)cls identifier:(NSString *)identifier{
    NSLog(@"当前类名:%@",NSStringFromClass(cls));
    NSLog(@"标识符:%@",identifier);
}

- (void)recordLogActionHookClass:(Class)cls
                          action:(SEL)action
                      identifier:(NSString *)identifier{
    NSLog(@"当前类名:%@",NSStringFromClass(cls));
    NSLog(@"标识符:%@",identifier);
    NSLog(@"当前点击的方法:%@",NSStringFromSelector(action));
}
@end
