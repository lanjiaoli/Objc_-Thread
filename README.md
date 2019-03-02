# Objc_-Thread
iOS 多线程
# 进程 与线程的区别
进程：资源分配的最小单位，进程中包含了某些资源的内存区域，一个正在运行的应用程序就相当于一个进程
线程：是进程的一个最小执行单元，CPU独立运行和调度的基本基本单元。
一个程序至少有一个进程，一个进程至少有一个线程。
### 多线程
通俗的讲：在一个进程中，同时开辟多条线程，完成不同的任务

### 优点：
1.为了更好的利用cpu的资源，如果只有一个线程，则第二个线程必须等待第一个结束之后才能进行，如果使用多线程则在主线程执行任务的同时可以执行其他任务，而不需要等待

2.进程之间不可以相互通信，而线程之间可以。

3.可以将耗时的操作放在其他线程，主线程负责页面刷新使得应用程序更加流畅，用户体验更好

### 缺点
1.新建线程会占用更多的内存和cpu，线程太多会降低系统的总体性能，每个线程都需要在系统内核和程序的内存空间上申请内存，
2.共享资源的抢夺

### 生命周期
1.新建 New ：实例化线程对象。

2.就绪Runanable: 向线程发送start消息，线程对象被加入线程池等待cpu进行调度。

3.运行Running:cpu负责调度执行，线程执行完成之前，状态可能会在就绪运行之间来回切换。就绪与运行时由cpu负责，程序员不能干预

4.堵塞 block：死锁:线程等待另一个线程执行结束，使得所有线程都在等待状态。

5.死亡 death: 正常死亡,线程执行完毕， 非正常死亡，当满足某个条件后，在线程内部终止执行/在主线程终止线程对象

线程的exit 和cancel  exit：强行终止线程，后续所有代码都会会执行
cancel:取消某个线程，并不会直接取消线程，只是给线程对象添加isCancelled标记
