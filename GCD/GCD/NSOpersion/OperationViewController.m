//
//  OperationViewController.m
//  GCD
//
//  Created by L on 2019/3/1.
//  Copyright © 2019 L. All rights reserved.
//

#import "OperationViewController.h"

@interface OperationViewController ()

@end

@implementation OperationViewController
/**
 NSOperation 是对GCD的更高一层的封装，完全面向对象，比GCD更加简单，代码可读性更高
 优点：
 
 
 **/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
    //主队列
    [NSOperationQueue mainQueue];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(firstInvocationAction) object:nil];
    //创建一个队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //设置最大并发量
    //设置最大并发数 实现串行的效果
    queue.maxConcurrentOperationCount = 2;
    
    //添加任务到队列
    [queue addOperation:op];
    [queue addOperationWithBlock:^{
        NSLog(@"任务2:当前线程%@ \
              \n",[NSThread currentThread]);
    }];
    
    [queue addOperationWithBlock:^{
        NSLog(@"任务3:当前线程%@ \
              \n",[NSThread currentThread]);
    }];
//    [op start];
}
- (void)firstInvocationAction{
    NSLog(@"当前线程%@ \
          \n",[NSThread currentThread]);
    
}

@end
