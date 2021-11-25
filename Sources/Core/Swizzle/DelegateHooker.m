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
-(NSArray *)plugins {
    if (!_plugins) {
        _plugins = [NSArray array];
    }
    return _plugins;
}
// MARK: -
-(void)forwardInvocation:(NSInvocation *)invocation {
    NSUInteger length = [[invocation methodSignature] methodReturnLength];
    void* buffer = nil;
    if (length > 0) {
        buffer = (void *)malloc(length);
    }
    BOOL isRespondsSelector = false;
    @try {
        ///如果target已经实现 则不再执行 defaultTarget
        id target;
        if ([self.target respondsToSelector:invocation.selector]) {
            target = self.target;
        } else if ([self.defaultTarget respondsToSelector:invocation.selector]) {
            target = self.defaultTarget;
        }
        if (target) {
            [invocation invokeWithTarget:target];
            isRespondsSelector = true;
        }
        /// 如果addTarget实现了方法，则执行并替换原有实现
        if (self.addTarget && [self.addTarget respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:self.addTarget];
            isRespondsSelector = true;
        }
        /// 记录下返回的值
        if (length > 0 && isRespondsSelector) {
            [invocation getReturnValue:buffer];
        }
        
        [self.plugins enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:invocation.selector]) {
                [invocation invokeWithTarget:obj];
            }
        }];
        /// 重设刚才记录的返回值
        if (length > 0 && isRespondsSelector) {
            [invocation setReturnValue:buffer];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        if (length > 0) {
            free(buffer);
        }
    }
}
// MARK: -
///如果返回nil表示  该方法 没有实现
-(id)bestTarget:(SEL)sel {
    if ([self.addTarget respondsToSelector:sel]) return self.addTarget;
    if ([self.target respondsToSelector:sel]) return self.target;
    if ([self.defaultTarget respondsToSelector:sel]) return self.defaultTarget;
    for (id plugin in [[self.plugins reverseObjectEnumerator] allObjects]) {
        if ([plugin respondsToSelector:sel]) return plugin;
    }
    return nil;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [[self bestTarget:sel] methodSignatureForSelector:sel];
}
-(BOOL)respondsToSelector:(SEL)aSelector {
    return [self bestTarget:aSelector] != nil;
}

@end
