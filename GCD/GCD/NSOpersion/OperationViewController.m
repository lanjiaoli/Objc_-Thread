//
//  OperationViewController.m
//  GCD
//
//  Created by L on 2019/3/1.
//  Copyright © 2019 L. All rights reserved.
//

#import "OperationViewController.h"
#import "JLInvoOperation.h"

@interface OperationViewController ()
{
    NSOperationQueue *queue ;

}
@end

@implementation OperationViewController
/**
 NSOperation 是对GCD的更高一层的封装，完全面向对象，比GCD更加简单，代码可读性更高
 优点：
 1.可以取消未执行的operation
 2.可以通过kvo监听当前线程的状态
 3.重用operation：operation只可以被执行一次，不可以执行多次
 4.可以设定相同或不同队列的依赖关系
 5.指定操作的优先级
 
 
 **/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation";
    //主队列
    [NSOperationQueue mainQueue];
//    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(firstInvocationAction) object:nil];
    //创建一个队列
    queue = [[NSOperationQueue alloc]init];
//    //设置最大并发量
//    //设置最大并发数 实现串行的效果
//    queue.maxConcurrentOperationCount = 2;
//
//    //添加任务到队列
//    [queue addOperation:op];
//    [queue addOperationWithBlock:^{
//        NSLog(@"任务2:当前线程%@ \
//              \n",[NSThread currentThread]);
//    }];
//
//    [queue addOperationWithBlock:^{
//        NSLog(@"任务3:当前线程%@ \
//              \n",[NSThread currentThread]);
//    }];
//    [op start];
}
- (void)firstInvocationAction{
    NSLog(@"当前线程%@ \
          \n",[NSThread currentThread]);
    
}
- (void)creatOperation{
    //创建一个队列
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(testQueue:) object:@"queue"];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(testQueue2:) object:@"queue2"];
    //设置优先级
    //如果有依赖关系 优先依赖关系
    //如果有
//    [op2 addDependency:op];
    [queue addOperation:op];
    [queue addOperation:op2];
    [queue addOperationWithBlock:^{
        NSLog(@"第三个当前线程：%@",[NSThread currentThread]);
        
    }];
    op2.queuePriority = NSOperationQueuePriorityHigh;
    //添加依赖关系
    
}

- (void)testQueue:(id)obj{
    NSLog(@"%@:当前线程：%@",obj,[NSThread currentThread]);
}

- (void)testQueue2:(id)obj{
    NSLog(@"%@:当前线程：%@",obj,[NSThread currentThread]);
}
- (IBAction)button:(id)sender {
    [self creatOperation];
}
- (IBAction)customAction:(id)sender {
    NSLog(@"自定义");
    
    JLInvoOperation *jlOp = [[JLInvoOperation alloc]init];
    JLInvoOperation *jlOp1 = [[JLInvoOperation alloc]init];
    queue.maxConcurrentOperationCount = 3;
    [queue addOperation:jlOp];

    [queue addOperation:jlOp1];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [queue cancelAllOperations];
}
@end
