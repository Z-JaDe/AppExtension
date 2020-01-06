//
//  DelegateHooker.h
//  List
//
//  Created by Apple on 2019/12/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DelegateHooker<__covariant T> : NSProxy

@property(nonatomic, strong) NSArray<T>* otherHooker;

@property(nonatomic, weak) T defaultTarget;
- (instancetype)initWithDefaultTarget:(T)defaultTarget;
+ (instancetype)hookerWithDefaultTarget:(T)defaultTarget;

@property(nonatomic, weak, readonly) id target;
-(void)transformToObject:(id __nullable)target;

@end

NS_ASSUME_NONNULL_END
