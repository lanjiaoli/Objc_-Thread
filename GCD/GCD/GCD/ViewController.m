//
//  ViewController.m
//  GCD
//
//  Created by L on 2019/3/1.
//  Copyright © 2019 L. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
     进程:资源分配的最小单元，一个正在运行的应用程序就是一个进程
     线程：cpu独立运行和独立调度的最小单元
     多线程：在一个进程中开启多条线程 同时完成不同的任务，可以提高CPU的执行效率
     主线程是默认开启的，子线程需要手动开启
     */
    
    //OC中有三种方法
    //主线程
    [NSThread mainThread];
    
    //获取当前线程
    [NSThread currentThread];
    //创建一个子线程
    NSThread *thread1 = [[NSThread alloc]initWithBlock:^{
         NSLog(@"当前线程%@",[NSThread currentThread]);
    }];
    
    NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(threadSelect) object:nil];
//    [self performSelector:@selector(threadSelect) onThread:thread1 withObject:nil waitUntilDone:false];
//    //手动开启
//    [thread1 start];
    
//    [thread2 start];
   
    /*
     GCD:
     同步sync:按顺序进行
     异步async:同时进行
     队列：
     主队列：
     并行：同时进行
     串行：按顺序进行
     */
    
    
}
- (void)threadSelect{
    NSLog(@"当前线程%@",[NSThread currentThread]);
    //取消操作
    [[NSThread currentThread] cancel];
}
#pragma mark - GCD Group
- (IBAction)threadAction:(id)sender {
    NSLog(@"GCD Group");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queuqe = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务1");
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务2");
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
    });
    ///监听任务的完成状态，
    dispatch_group_notify(group, queuqe, ^{
        NSLog(@"任务完成 回调");
    });
}
/**
 GCD Group
 */
- (IBAction)GCDGroupSequeceAction:(id)sender {
    NSLog(@"按顺序执行");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queuqe = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //标志一个任务添加到group，执行一次相当于group的任务+1;
    dispatch_group_enter(group);
    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务1");
        dispatch_async(queuqe, ^{
            NSLog(@"追加任务 :当前线程%@",[NSThread currentThread]);
            //标志一个任务离开了group，执行一次相当于group的任务-1;
            dispatch_group_leave(group);

        });
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务2");
        dispatch_async(queuqe, ^{
            NSLog(@"追加任务2 :当前线程%@",[NSThread currentThread]);
            dispatch_group_leave(group);
            
        })  ;
    });
    //暂停当前线程 等待指定Group任务完成执行完成，才可以往下执行
    
//    当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group_wait 所有都完成了");
    
    //监听group任务完成状态。
    dispatch_group_notify(group, queuqe, ^{
        NSLog(@"任务完成 回调");
    });
}
#pragma mark - GCD Sync 同步
- (IBAction)GCDsyncSerial:(id)sender {
    NSLog(@"同步串行");
    /*
     同步串行 :在同一线程下按顺序进行 FIFO
     */
    dispatch_queue_t queuqe = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);

    });
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch2 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch3 :当前线程%@",[NSThread currentThread]);
        
    });
    
}
- (IBAction)GCDsyncConcurrent:(id)sender {
    NSLog(@"同步并发");
    /*
     同步并行 :在同一线程下按顺序进行 FIFO
     */
    dispatch_queue_t queuqe = dispatch_queue_create("syncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch2 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_sync(queuqe, ^{
        NSLog(@"disatch3 :当前线程%@",[NSThread currentThread]);
        
    });
}
#pragma mark - 异步 async
- (IBAction)GCDAsyncSerialQueue:(id)sender {
    NSLog(@"异步串行");
    /*
     异步串行：
     开启新的线程，在同一线程下按顺序执行 FIFO 先进先出
     */
    dispatch_queue_t queuqe = dispatch_queue_create("asyncConcurrentQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queuqe, ^{
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch2 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch3 :当前线程%@",[NSThread currentThread]);
        
    });
}
- (IBAction)GCDAsyncConcurrent:(id)sender {
    NSLog(@"异步并发");
    /*
     异步并行：
     开启多条线程，同时执行，顺序不一致
     可提高cpu的执行效率
     */
    dispatch_queue_t queuqe = dispatch_queue_create("aasyncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queuqe, ^{
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch2 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch3 :当前线程%@",[NSThread currentThread]);
        
    });

}


#pragma mark - 线程间的通信
- (IBAction)GCDCommunicationAction:(id)sender {
    NSLog(@"线程间的通信");
     dispatch_queue_t queuqe = dispatch_queue_create("aasyncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queuqe, ^{
         NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"主线程 :当前线程%@",[NSThread currentThread]);

        });
    });
}
#pragma mark - GCD栅栏

- (IBAction)GCDBarrierAction:(id)sender {
    NSLog(@"栅栏");
    /**
     执行完barrier前面的操作之后，才执行操作
     */
    dispatch_queue_t queuqe = dispatch_queue_create("aasyncConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queuqe, ^{
        NSLog(@"disatch1 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch2 :当前线程%@",[NSThread currentThread]);
        
    });
    dispatch_barrier_sync(queuqe, ^{
        NSLog(@"栅栏");
    });
    dispatch_async(queuqe, ^{
        NSLog(@"disatch3 :当前线程%@",[NSThread currentThread]);
        
    });
}

#pragma mark - GCD 信号量 semaphore_t

- (IBAction)semaphoreAction:(id)sender {
//    GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
    ///创建信号量
    NSLog(@"信号量");
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queuqe = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //发送一个信号量  加1
    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务1");

        dispatch_async(queuqe, ^{
            NSLog(@"追加任务 :当前线程%@",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
    });
    //可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"任务1完成了");

    dispatch_group_async(group, queuqe, ^{
        NSLog(@"当前任务2");
        dispatch_async(queuqe, ^{
            NSLog(@"追加任务2 :当前线程%@",[NSThread currentThread]);
            //发送一个信号量  -1
            dispatch_semaphore_signal(semaphore);

        })  ;
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"当前任务2完成了");
    //    当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。

    
    //监听group任务完成状态。
    dispatch_group_notify(group, queuqe, ^{
        NSLog(@"任务完成 回调");
    });
}


@end
