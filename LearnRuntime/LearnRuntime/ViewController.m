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
    
}


@end
