//
//  LHReachability.h
//  toy
//
//  Created by 李允 on 15/7/7.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DECLARE_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance;

#define IMPLEMENT_SHARED_INSTANCE(className)  \
+ (className *)sharedInstance \
{ \
static dispatch_once_t onceToken; \
static className *sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[self alloc] init]; \
}); \
return sharedInstance; \
}
@interface LHReachability : NSObject
DECLARE_SHARED_INSTANCE(LHReachability)
- (void)reachable:(void(^)())reachBlock or:(void(^)())unReachBlock;
@end
