# Runtime

Runtime 是运行时，它是指数据类型的确定由编译期推迟到运行时，是一套底层的C语言API，
平时我们开发用的objective-c代码，在程序运行时，会转化成runtime的C语言代码，runtime是oc的幕后工作者，OC需要runtime创建类跟对象，进行消息发送与转发。

# 作用
1.可以为系统的创建category，为其添加方法,添加属性

class是个结构体 结构体中有个instance_size字段，

在objc_registerClassPair前就已经确定了所占的内存大小。所有不能添加成员变量

可以通过分类添加属性，用runtime进行关联
```
- (void)setAddress:(NSString *)address{
    objc_setAssociatedObject(self, "address", address, OBJC_ASSOCIATION_COPY);
}

-(NSString *)address{
    return  objc_getAssociatedObject(self, "address");
}
```

2.可以通过runtime获取对象的所有方法，及属性，私有属性
```
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
```


3.字典转模型

注意：分类添加的属性是关联上的，不是真正的成员变量。


```
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
```

4.动态交换2个方法
```
+ (void)load{
    //动态交换2个方法
    SEL runSelector = NSSelectorFromString(@"run");
    SEL eatSelector = NSSelectorFromString(@"eat");

    Method m = class_getInstanceMethod(self.class, runSelector);
    Method m1 = class_getInstanceMethod(self.class, eatSelector);
    method_exchangeImplementations(m, m1);
}
```




5.消息转发

消息转发流程图https://upload-images.jianshu.io/upload_images/6082051-434d82bcea61a394.png?imageMogr2/auto-orient/
```
//动态添加方法 来
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
- (id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    ViewController *vc = [ViewController new];
    [anInvocation invokeWithTarget:vc];
    
}
```
可以防止未实现方法 而导致崩溃 
可以这样做
```
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

```





6.KVO、KVC、归档,block，类的检测等等




