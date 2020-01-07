//
//  DelegateHooker.h
//  List
//
//  Created by Apple on 2019/12/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///执行顺序 target(defaultTarget) - addTarget - plugins
@interface DelegateHooker<__covariant T> : NSProxy
/// ZJaDe: 插件 只是监听方法 不替换结果
@property(nonatomic, strong) NSArray<T>* plugins;
/// ZJaDe: 监听方法 而且会替换结果
@property(nonatomic, weak) id addTarget;

/// ZJaDe: 默认的实现
@property(nonatomic, weak) T defaultTarget;
- (instancetype)initWithDefaultTarget:(T)defaultTarget;
+ (instancetype)hookerWithDefaultTarget:(T)defaultTarget;

/// ZJaDe: 替换默认实现
@property(nonatomic, weak, readonly) id target;
/// ZJaDe: 替换默认实现
-(void)transformToObject:(id __nullable)target;


@end

NS_ASSUME_NONNULL_END
