//
//  ThreadViewController.m
//  GCD
//
//  Created by L on 2019/3/2.
//  Copyright © 2019 L. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //主线程
//    [NSThread mainThread];
//
//    //当前线程
//    [NSThread currentThread];
//
//    //判断当前是否是多线程
//    [NSThread isMultiThreaded];
//
//    //线程休眠
//    [NSThread sleepForTimeInterval:1];
//
//    //在指定时间休眠
//    [NSThread sleepUntilDate:[NSDate date]];
//
//    //退出线程
//
//    [NSThread exit];
//    //取消操作,并不会直接取消，而是给线程对象添加了一个cancelled表示
//    [[NSThread currentThread]cancel];
    
}

- (IBAction)openThreadAction:(id)sender {
    //NSThread开启多线程的三种方法
    
    ///直接用block构建
    NSThread *therad = [[NSThread alloc]initWithBlock:^{
        for (int i = 0; i < 3; i++) {
            //模拟耗时操作
            [NSThread sleepForTimeInterval:1];
            NSLog(@"%@",[NSThread currentThread]);

        }
    }];
    [therad start];
    
    //通过target构建
    NSThread *anotherThread = [[NSThread alloc]initWithTarget:self selector:@selector(anotherThreadAction) object:nil];
    [anotherThread start];
    
    //隐式创建
    [self performSelectorInBackground:@selector(background:) withObject:@"threadBackgroud"];
    
    
    
}

- (void)anotherThreadAction{
    for (int i = 0; i < 3; i++) {
        //模拟耗时操作
        [NSThread sleepForTimeInterval:1];
        NSLog(@"另一个线程：%@",[NSThread currentThread]);

    }
}
- (void)background:(NSObject *)obj{
    NSLog(@"%@",obj);
    for (int i = 0; i < 3; i++) {
        //模拟耗时操作
        [NSThread sleepForTimeInterval:1];
        NSLog(@"background：%@",[NSThread currentThread]);
        
    }
}


- (IBAction)mainThreadAction:(id)sender {
    [self performSelectorOnMainThread:@selector(mainThreadActionSEL) withObject:nil waitUntilDone:false];
    
    
}
- (void)mainThreadActionSEL{
    NSLog(@"主线程：%@",[NSThread currentThread]);
}
@end
