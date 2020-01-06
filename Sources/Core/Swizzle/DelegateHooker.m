//
//  DelegateHooker.m
//  List
//
//  Created by Apple on 2019/12/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

#import "DelegateHooker.h"

@interface DelegateHooker ()

@end
@implementation DelegateHooker

-(instancetype)initWithDefaultTarget:(id)defaultTarget {
    _defaultTarget = defaultTarget;
    return self;
}
+ (instancetype)hookerWithDefaultTarget:(id)defaultTarget {
    return [[self alloc] initWithDefaultTarget:defaultTarget];
}

-(void)transformToObject:(id __nullable)target {
    _target = target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([self.target respondsToSelector:sel]) {
        return [self.target methodSignatureForSelector:sel];
    } else {
        return [self.defaultTarget methodSignatureForSelector:sel];
    }
}

-(void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.target];
    } else {
        [invocation invokeWithTarget:self.defaultTarget];
    }
    [self.otherHooker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:obj];
        }
    }];
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.defaultTarget respondsToSelector:aSelector]) {
        return true;
    } else {
        return [self.target respondsToSelector:aSelector];
    }
}

-(NSArray *)otherHooker {
    if (!_otherHooker) {
        _otherHooker = [NSArray array];
    }
    return _otherHooker;
}

@end
