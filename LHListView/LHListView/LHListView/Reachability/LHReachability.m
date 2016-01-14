//
//  LHReachability.m
//  toy
//
//  Created by 李允 on 15/7/7.
//  Copyright (c) 2015年 liyun. All rights reserved.
//

#import "LHReachability.h"

@implementation LHReachability
IMPLEMENT_SHARED_INSTANCE(LHReachability)
- (void)reachable:(void(^)())reachBlock or:(void(^)())unReachBlock {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 5.;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.description && unReachBlock) {
                unReachBlock();
            } else if (reachBlock) {
                reachBlock();
            }
        });
    }] resume];
}

@end
