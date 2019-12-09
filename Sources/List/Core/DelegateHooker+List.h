//
//  DelegateHooker+List.h
//  ProjectBasic
//
//  Created by Apple on 2019/12/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateHooker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DelegateHooker (List) <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@end

NS_ASSUME_NONNULL_END
