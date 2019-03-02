//
//  JLInvoOperation.m
//  GCD
//
//  Created by L on 2019/3/1.
//  Copyright © 2019 L. All rights reserved.
//

#import "JLInvoOperation.h"

@implementation JLInvoOperation
- (void)main{
    if (!self.isCancelled) {
        for (int i = 0; i< 2; i++) {
            NSLog(@"当前线程(%d)%@",i,[NSThread currentThread]);
            [NSThread sleepForTimeInterval:3];
        }
    }
}
@end
