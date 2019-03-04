//
//  Person.m
//  LearnRuntime
//
//  Created by L on 2019/3/4.
//  Copyright © 2019 L. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
@implementation Person
/**
 Runtime :简称运行时，OC就是运行时的机制，
 */
+ (void)load{
    //动态交换2个方法
    SEL runSelector = NSSelectorFromString(@"run");
    SEL eatSelector = NSSelectorFromString(@"eat");

    Method m = class_getInstanceMethod(self.class, runSelector);
    Method m1 = class_getInstanceMethod(self.class, eatSelector);
    method_exchangeImplementations(m, m1);
}

- (void)getAllProperty{
    //获取类的成员变量
    unsigned int size  = 0;
    Ivar *ivars = class_copyIvarList(self.class, &size);
    
    for (int i = 0 ; i < size; i++) {
        Ivar ivar = ivars[i];
        //当前成员变量的名称
       const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"成员变量：%s",name);
        NSLog(@"type:%s",type);
    }
    
    
}


-(void)run{
    NSLog(@"跑");
}
-(void)eat{
    NSLog(@"吃");
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel  == @selector(aaa)) {
        //动态添加方法  转发到指定的方法
        Method m = class_getInstanceMethod([self class], @selector(run));
        const char *type = method_getTypeEncoding(m);
        Method m1 = class_getInstanceMethod([self class], @selector(addSelect));
        IMP imp = method_getImplementation(m1);
        class_addMethod(self.class, sel, imp, type);
        return YES;
    }else{
        return [super resolveInstanceMethod:sel];

    }
}

- (void)addSelect{
    NSLog(@"新添加的方法");
}
@end
