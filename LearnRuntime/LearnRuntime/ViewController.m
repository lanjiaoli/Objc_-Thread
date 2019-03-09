//
//  ViewController.m
//  LearnRuntime
//
//  Created by L on 2019/3/4.
//  Copyright © 2019 L. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *p = [[Person alloc]init];
    //获取当前某个类的类名
    
    [p performSelector:@selector(aaa)];
    const char *className = object_getClassName(p);
    NSLog(@"class Name:%s",className);
    
    [p performSelector:@selector(run)];
    [p performSelector:@selector(getAllProperty)];
    
    
    [p performSelector:@selector(selector)];
    
    
    [p addObserver:self forKeyPath:@"age" options:(NSKeyValueObservingOptionNew) context:nil];
    p.age = 1;
    [p setValue:@"我是通过KVC" forKey:@"name"];
    [p description];
}

- (void)creatNewClass1{
    NSLog(@"转发过来的");
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"发生了改变");
    
}

@end
