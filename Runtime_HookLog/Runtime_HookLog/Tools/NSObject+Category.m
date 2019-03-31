//
//  NSObject+Category.m
//  Runtime_HookLog
//
//  Created by L on 2019/3/31.
//  Copyright © 2019 L. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "LJL_HookObjcLog.h"


@implementation NSObject (Category)

@end
///MARK: -- UITableView --
@implementation UITableView(Log_Category)
+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSEL = @selector(setDelegate:);
        SEL changeSEL = @selector(hook_setDelegate:);
        [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:self originalSEL:originalSEL changeSEL:changeSEL];
        
    });
    
}

- (void)hook_setDelegate:(id<UITableViewDelegate>)delegate{
    [self hook_setDelegate:delegate];
    Method didSelectmethod = class_getInstanceMethod(delegate.class, @selector(tableView:didSelectRowAtIndexPath:));
    IMP hookIMP = class_getMethodImplementation(self.class, @selector(hook_tableView:didSelectRowAtIndexPath:));
    
    char const* type = method_getTypeEncoding(didSelectmethod);
    class_addMethod(delegate.class, @selector(hook_tableView:didSelectRowAtIndexPath:), hookIMP, type);
    Method hookMethod = class_getInstanceMethod(delegate.class, @selector(hook_tableView:didSelectRowAtIndexPath:));
    method_exchangeImplementations(didSelectmethod, hookMethod);
    
}

- (void)hook_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[LJL_HookObjcLog logManage] recordHookClass:self.class identifier:[NSString stringWithFormat:@"%ld,%ld",indexPath.row,indexPath.section]];
    [self hook_tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end

///MARK: -- UIViewController --
@implementation UIViewController(Hook_Categore)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///获取
        SEL willAppear = @selector(viewWillAppear:);
        SEL hook_willAppear = @selector(hook_viewWillAppear:);
        [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:self originalSEL:willAppear changeSEL:hook_willAppear];
        
        
        SEL disappear = @selector(viewDidDisappear:);
        SEL hook_disappear = @selector(hook_viewDidDisappear:);
        [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:self originalSEL:disappear changeSEL:hook_disappear];
        
    });
}

- (void)hook_viewWillAppear:(BOOL)animated{
    [[LJL_HookObjcLog logManage] recordHookClass:self.class identifier:@"进入"];
    [self hook_viewWillAppear:animated];
}

- (void)hook_viewDidDisappear:(BOOL)animated{
    [[LJL_HookObjcLog logManage] recordHookClass:self.class identifier:@"离开"];
    [self hook_viewDidDisappear:animated];
}

@end
///MARK: -- UIButton --
@implementation UIControl(log_Category)


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///获取
        
        SEL originalSEL = @selector(sendAction:to:forEvent:);
        SEL changeSEL = @selector(hook_sendAction:to:forEvent:);
        [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:self originalSEL:originalSEL changeSEL:changeSEL];
    });
}

///MAKR:
- (void)hook_sendAction:(SEL)action
                     to:(nullable id)target
               forEvent:(nullable UIEvent *)event{
    [self hook_sendAction:action to:target forEvent:event];
    ///点击事件结束记录
    if ([[event.allTouches anyObject]phase] == UITouchPhaseEnded) {
        [[LJL_HookObjcLog logManage] recordLogActionHookClass:[target class] action:action identifier:@"UIButton"];
    }
}
@end
@implementation UIGestureRecognizer (Log_Category)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///获取
        
        SEL originalSEL = @selector(initWithTarget:action:);
        SEL changeSEL = @selector(hook_initWithTarget:action:);
        [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:self originalSEL:originalSEL changeSEL:changeSEL];
    });
}

- (instancetype)hook_initWithTarget:(nullable id)target action:(nullable SEL)action{
    UIGestureRecognizer *gestureRecognizer = [self hook_initWithTarget:target action:action];
    SEL changeSEL = @selector(hook_gestureAction:);
    IMP hookIMP = class_getMethodImplementation(self.class, changeSEL);
    const char *type = method_getTypeEncoding(class_getInstanceMethod([target class], action));
    class_addMethod([target class], changeSEL, hookIMP, type);
    
    [[LJL_HookObjcLog logManage]ljl_exchangeMethodWithClass:[target class] originalSEL:action changeSEL:changeSEL];
    
    
    return gestureRecognizer;
}

- (void)hook_gestureAction:(id)sender{
    [self hook_gestureAction:sender];
    [[LJL_HookObjcLog logManage] recordLogActionHookClass:self.view.classForCoder action:@selector(hook_gestureAction:) identifier:@"手势"];
    
}

@end
