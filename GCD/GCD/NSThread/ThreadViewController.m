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
    // Do any additional setup after loading the view.
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
