//
//  ViewController.m
//  NSRunLoop
//
//  Created by L on 2019/3/2.
//  Copyright © 2019 L. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// NSRunLoop :从字面量解释  run 跑,loop 循环，依旧是循环跑圈的意思，在循环中处理各种事件，如selector事件、触摸事件、NSTimer 等,它保持程序持续运行，该做事，做事，该休息休息
    
    //一般来讲，一个线程只能执行一个任务，当任务执行完成后线程就会推出，如果我们需要一个机制，随时让线程来执行任务，而不让线程退出，就要通过runloop来实现，
    ///其实runloop内部就是一个do...while循环
    
    
    //
    /**
     runloop与线程的关系
     Apple不允许直接创建NSRunLoop,它只提供了2个方法
     RunLoop与线程是一一对应的，主线程是默认开启的，子线程需要手动获取，因为子线程创建时并没有runloop，如果你不回去它永远都不会有
     销毁则在线程结束销毁
     
     runloop对象中含有多个mode，每个model包含不同的source,observer,timer；
     
     每次调用runloop的主函数时，只能指定其中的一个mode，切换mode,需要重新指定一个mode，主要是为了隔开不同的source、timer、observer,让它们互补影响
     
     */
    //当前的RunLoop
    [NSRunLoop currentRunLoop];
    CFRunLoopGetCurrent();
    
    //主线程的runloop
    [NSRunLoop mainRunLoop];
    CFRunLoopGetMain();
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSTimer *time = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"time");
    }];
    [runLoop addTimer:time forMode:NSDefaultRunLoopMode];
    
    ///source0 非基于port只包含了,用户主动触发
    //source1 包含了一个mach_port和一个回调（函数指针）,被用于内核与其他线程之间通信

    NSInteger number = 0;
    CGFloat f = 0.0;
    NSLog(@"%ld",sizeof(number));
    NSLog(@"%ld",sizeof(f));
    
//    UIButton -> UIControl -> UIView -> UIResponder->NSObject
}



@end
