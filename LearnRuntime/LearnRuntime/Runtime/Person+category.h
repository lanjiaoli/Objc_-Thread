//
//  Person+category.h
//  LearnRuntime
//
//  Created by L on 2019/3/9.
//  Copyright © 2019 L. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (category)
@property (nonatomic, copy) NSString *address;
@end

NS_ASSUME_NONNULL_END
