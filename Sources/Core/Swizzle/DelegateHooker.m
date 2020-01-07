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
    id target;
    if ([self.addTarget respondsToSelector:sel]) {
        target = self.addTarget;
    } else if ([self.target respondsToSelector:sel]) {
        target = self.target;
    } else {
        target = self.defaultTarget;
    }
    return [target methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
    NSUInteger length = [[invocation methodSignature] methodReturnLength];
    void* buffer = nil;
    if (length > 0) {
        buffer = (void *)malloc(length);
    }
    BOOL isRespondsSelector = false;
    {
        id target;
        if ([self.target respondsToSelector:invocation.selector]) {
            target = self.target;
        } else if ([self.defaultTarget respondsToSelector:invocation.selector]) {
            target = self.defaultTarget;
        }
        if (target) {
            [invocation invokeWithTarget:target];
            isRespondsSelector = true;
            if (length > 0) { [invocation getReturnValue:buffer]; }
        }
    }
    if (self.addTarget && [self.addTarget respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.addTarget];
        isRespondsSelector = true;
        if (length > 0) { [invocation getReturnValue:buffer]; }
    }
    [self.plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:obj];
        }
    }];
    if (length > 0 && isRespondsSelector) {
        [invocation setReturnValue:buffer];
        free(buffer);
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.defaultTarget respondsToSelector:aSelector]) {
        return true;
    } else {
        return [self.target respondsToSelector:aSelector];
    }
}

-(NSArray *)plugins {
    if (!_plugins) {
        _plugins = [NSArray array];
    }
    return _plugins;
}

@end
