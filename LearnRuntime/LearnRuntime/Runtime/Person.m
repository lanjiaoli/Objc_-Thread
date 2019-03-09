//
//  Person.m
//  LearnRuntime
//
//  Created by L on 2019/3/4.
//  Copyright © 2019 L. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Person+category.h"
#import "ViewController.h"
#import <objc/message.h>

@interface Person()
@property (nonatomic, strong) NSMutableArray *selArray;
@end
@implementation Person
{
    NSString *name;
}
/**
 Runtime :简称运行时，OC就是运行时的机制，
 */
-(NSMutableArray *)selArray{
    if (!_selArray) {
        _selArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _selArray;
}
- (void)creatNewClass{

    const char * classChar = "JLNSNotify_Person";
    
    const char * ivar = "age";

    Class newClass = objc_allocateClassPair(self.class, classChar, 0);
    BOOL flag =  class_addIvar(newClass, ivar, sizeof(NSInteger), 0, "@");
    flag ? NSLog(@"成功"):NSLog(@"失败");
    class_addMethod(newClass, @selector(newClassMethod), (IMP)newClassMethod, "");
    
    class_addMethod([self class], @selector(test:), (IMP)test, "");

    objc_registerClassPair(newClass);
    
    //isa swizling 改变isa指针
    object_setClass(self, newClass);

    [self getAllPropertyWithClass:newClass];
    [self getAllMethodWithClass:newClass];
}
void test(id self,SEL _cmd,NSString *name){
    Class cls = [self class];
    object_setClass(cls, class_getSuperclass([self class]));
    objc_msgSend();
    object_setClass(self, cls);
    
}
static void newClassMethod(){
    NSLog(@"成功");
}

+ (void)load{
    //动态交换2个方法
    SEL runSelector = NSSelectorFromString(@"run");
    SEL eatSelector = NSSelectorFromString(@"eat");

    Method m = class_getInstanceMethod(self.class, runSelector);
    Method m1 = class_getInstanceMethod(self.class, eatSelector);
    method_exchangeImplementations(m, m1);
}

- (void)getAllPropertyWithClass:(Class)cls{
    //获取类的成员变量
    unsigned int size  = 0;
    Ivar *ivars = class_copyIvarList(cls, &size);
    
    for (int i = 0 ; i < size; i++) {
        Ivar ivar = ivars[i];
        //当前成员变量的名称
       const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"成员变量：%s",name);
        NSLog(@"type:%s",type);
    }
    
    
}

- (void)getAllMethodWithClass:(Class)cls{
    
    unsigned int  count = 0;
    
    Method  *methodlist = class_copyMethodList(cls, &count);
    for (int i = 0;  i < count; i++) {
        Method m = methodlist[i];
        SEL sel = method_getName(m);
        [self.selArray addObject:NSStringFromSelector(sel)];
        NSLog(@"方法列表:%@",NSStringFromSelector(sel));
    }
}

- (void)exchangeModelWithDic:(NSDictionary *)dic{
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
        NSString *key = [[NSString stringWithFormat:@"%s",name] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *value = dic[key];
        [self setValue:value forKey:key];
    }
    
}
-(void)run{
    NSLog(@"跑");
}
-(void)eat{
    NSLog(@"吃");
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    //筛选出当前类的方法
    Person *p = [[Person alloc]init];
    [p getAllMethodWithClass:Person.class];
    
//    如果当前类没有此方法 做容错处理
    if (![p.selArray containsObject:NSStringFromSelector(sel)]) {
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

-(NSString *)description{
    NSLog(@"name :%@ \n age : %ld \n address: %@",self.name , self.age ,self.address);
    return @"";
}


+(BOOL)accessInstanceVariablesDirectly{
    return false;
}
@end
