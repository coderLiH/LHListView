//
//  DeleteView.m
//  LHListView
//
//  Created by 李允 on 15/12/28.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "DeleteView.h"

@implementation DeleteView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap {
    NSLog(@"%ld",self.index.row);
}
@end
