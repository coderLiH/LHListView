//
//  LHCollectionRoot.m
//  toy
//
//  Created by 李允 on 16/1/29.
//  Copyright © 2016年 liyun. All rights reserved.
//

#import "LHCollectionRoot.h"
#import "LHRefreshView.h"

@interface LHCollectionRoot () <LHRefreshViewDelegate>
@property (nonatomic, strong) LHRefreshView *refreshView;
@end

@implementation LHCollectionRoot

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundView = [[UIView alloc] init];
    }
    return self;
}

#pragma mark refresh

- (void)setListRefresher:(id<LHListViewRefresher>)listRefresher {
    _listRefresher = listRefresher;
    
    if (listRefresher) {
        self.refreshView.hidden = NO;
        [self addObservers];
    } else {
        self.refreshView.hidden = YES;
        [self removeObservers];
    }
}

- (void)endRefreshing {
    [self.refreshView endRefreshing];
}

- (BOOL)isRefreshing {
    return self.refreshView.state == LHRefreshViewStateRefreshing;
}

- (void)refreshDidBeginRefresh {
    if ([self.listRefresher respondsToSelector:@selector(listViewDidBeginRefresh:)]) {
        [self.listRefresher listViewDidBeginRefresh:self];
    }
}

- (void)refreshViewWithProgress:(CGFloat)progress {
    if ([self.listRefresher respondsToSelector:@selector(listView:refreshProgress:)]) {
        [self.listRefresher listView:self refreshProgress:progress];
    }
}

- (UIView *)refreshViewPullingView {
    if ([self.listRefresher respondsToSelector:@selector(listViewRefreshPullingView)]) {
        return [self.listRefresher listViewRefreshPullingView];
    } else {
        return nil;
    }
}

- (UIView *)refreshViewPreparingView {
    if ([self.listRefresher respondsToSelector:@selector(listViewRefreshPreparingView)]) {
        return [self.listRefresher listViewRefreshPreparingView];
    } else {
        return nil;
    }
}

- (UIView *)refreshViewRefreshingView {
    if ([self.listRefresher respondsToSelector:@selector(listViewRefreshRefreshingView)]) {
        return [self.listRefresher listViewRefreshRefreshingView];
    } else {
        return nil;
    }
}

- (void)removeObservers {
    @try{
        [self.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }@catch(id anException){}
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [self.panGestureRecognizer addObserver:self forKeyPath:@"state" options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (!self.refreshView.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self.refreshView listViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:@"state"]) {
        [self.refreshView listViewPanStateDidChange:change];
    }
}

#pragma mark lazy
- (LHRefreshView *)refreshView {
    if (!_refreshView) {
        _refreshView = [[LHRefreshView alloc] init];
        [self.backgroundView addSubview:_refreshView];
        _refreshView.listView = self;
        _refreshView.delegate = self;
        _refreshView.frame = CGRectMake(0, 0, self.displayWidth, List_Refresh_Height);
        _refreshView.hidden = YES;
    }
    return _refreshView;
}

- (void)dealloc {
    [self removeObservers];
}

@end
