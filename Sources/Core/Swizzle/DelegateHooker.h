//
//  DelegateHooker.h
//  List
//
//  Created by Apple on 2019/12/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 defaultTarget 默认实现
 target 实现了对应方法后，替换原有实现，defaultTarget不再执行对应方法
 addTarget 实现了对应方法后，最终返回的是addTarget的返回的结果，但是本来的实现还是要执行
 plugins 单纯的在方法执行后，执行一遍plugins里面的方法
 如果 defaultTarget、target、addTarget都没实现，则使用plugins中最后一个的实现的返回值
 */


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
