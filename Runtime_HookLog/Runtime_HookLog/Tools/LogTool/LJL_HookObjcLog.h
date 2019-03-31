//
//  LJL_HookObjcLog.h
//  CustomKVO
//
//  Created by L on 2019/3/31.
//  Copyright © 2019 L. All rights reserved.
//

#import <Foundation/Foundation.h>
//extern NSString  const *recordHookIentifier = @""
NS_ASSUME_NONNULL_BEGIN

@interface LJL_HookObjcLog : NSObject
+(LJL_HookObjcLog *)logManage;

/**
 记录hook的方法

 @param cls 当前类
 @param identifier 标识符
 */
- (void)recordHookClass:(Class)cls
             identifier:(NSString *)identifier;
/**
 记录Buton点击的方法
 
 @param cls 当前类
 @param identifier 标识符
 */
- (void)recordLogActionHookClass:(Class)cls
                             action:(SEL)action
             identifier:(NSString *)identifier;

/**
 交换方法

 @param cls 类名
 @param originalSEL 原方法
 @param changeSEL 需要替换的方法
 */
- (void)ljl_exchangeMethodWithClass:(Class)cls
                        originalSEL:(SEL)originalSEL
                          changeSEL:(SEL)changeSEL;

@end

NS_ASSUME_NONNULL_END
