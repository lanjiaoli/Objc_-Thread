//
//  Person+category.m
//  LearnRuntime
//
//  Created by L on 2019/3/9.
//  Copyright © 2019 L. All rights reserved.
//

#import "Person+category.h"
#import <objc/runtime.h>

@implementation Person (category)
- (void)setAddress:(NSString *)address{
    objc_setAssociatedObject(self, &"address", address, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)address{
    return  objc_getAssociatedObject(self, "address");
}
@end
