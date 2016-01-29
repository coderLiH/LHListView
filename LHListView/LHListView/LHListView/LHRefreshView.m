//
//  LHRefreshView.m
//  toy
//
//  Created by 李允 on 16/1/23.
//  Copyright © 2016年 liyun. All rights reserved.
//

#import "LHRefreshView.h"
#import "UIScrollView+LHExtension.h"

@interface LHRefreshView ()
@property (nonatomic, assign) UIEdgeInsets originInset;
@property (nonatomic, weak) UIView *pullingView;
@property (nonatomic, weak) UIView *preparingView;
@property (nonatomic, weak) UIView *refreshingView;

@property (nonatomic, strong) LHDefaultPullingView *defaultPullingView;
@property (nonatomic, strong) LHDefaultPreparingView *defaultPreparingView;
@property (nonatomic, strong) LHDefaultRefreshingView *defaultRefreshingView;

@end

@implementation LHRefreshView

- (instancetype)init {
    if (self = [super init]) {
        _state = LHRefreshViewStateAnimating;
    }
    return self;
}

- (void)listViewContentOffsetDidChange:(NSDictionary *)change {
    if (self.listView.offsetY <= -List_Refresh_Height && _state == LHRefreshViewStateAnimating) {
        self.state = LHRefreshViewStatePreparing;
    }
    if (self.listView.offsetY > -List_Refresh_Height && _state == LHRefreshViewStatePreparing) {
        self.state = LHRefreshViewStateAnimating;
    }
    
    
    if (_state == LHRefreshViewStateAnimating && self.listView.offsetY < 0) {
        CGFloat progress = ABS(self.listView.offsetY)/List_Refresh_Height;
        if ([self.delegate respondsToSelector:@selector(refreshViewWithProgress:)]) {
            [self.delegate refreshViewWithProgress:progress];
        }
    }
    
    if (_state == LHRefreshViewStateAnimating) {
        if (self.listView.offsetY < 0) {
            self.pullingView.alpha = 1.0;
        } else {
            self.pullingView.alpha = 0.0;
        }
    }
}

- (void)listViewPanStateDidChange:(NSDictionary *)change {
    
    UIGestureRecognizerState state = [change[@"new"] integerValue];
    
    if (state == UIGestureRecognizerStateEnded) {
        if (_state == LHRefreshViewStatePreparing) {
            self.state = LHRefreshViewStateRefreshing;
        }
    }
}

- (void)endRefreshing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.state == LHRefreshViewStateRefreshing) {
            [UIView animateWithDuration:0.4 animations:^{
                self.listView.contentInset = _originInset;
            } completion:^(BOOL finished) {
                self.state = LHRefreshViewStateAnimating;
            }];
        }
    });
}

- (void)setState:(LHRefreshViewState)state {
    _state = state;
    
    if (state == LHRefreshViewStateRefreshing) {
        _originInset = self.listView.contentInset;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.listView.contentInset = UIEdgeInsetsMake(_originInset.top + List_Refresh_Height, _originInset.left, _originInset.bottom, _originInset.right);
        } completion:^(BOOL finished) {
            
        }];
        
        if ([self.delegate respondsToSelector:@selector(refreshDidBeginRefresh)]) {
            [self.delegate refreshDidBeginRefresh];
        }
        
        self.refreshingView.alpha = 1.0;
        self.preparingView.alpha = 0.0;
        self.pullingView.alpha = 0.0;
    } else if (state == LHRefreshViewStatePreparing) {
        self.refreshingView.alpha = 0.0;
        self.preparingView.alpha = 1.0;
        self.pullingView.alpha = 0.0;
    } else {
        self.refreshingView.alpha = 0.0;
        self.preparingView.alpha = 0.0;
    }
}

- (UIView *)pullingView {
    if (!_pullingView) {
        UIView *view;
        if ([self.delegate respondsToSelector:@selector(refreshViewPullingView)]) {
            view = [self.delegate refreshViewPullingView];
        }
        
        if (!view) {
            view = self.defaultPullingView;
        }
        
        [self addSubview:view];
        
        _pullingView = view;
        
        _pullingView.frame = CGRectMake(0, 0, List_Refresh_Width, List_Refresh_Height);
        _pullingView.alpha = 0.0;
    }
    return _pullingView;
}

- (UIView *)refreshingView {
    if (!_refreshingView) {
        UIView *view;
        if ([self.delegate respondsToSelector:@selector(refreshViewRefreshingView)]) {
            view = [self.delegate refreshViewRefreshingView];
        }
        
        if (!view) {
            view = self.defaultRefreshingView;
        }
        
        [self addSubview:view];
        
        _refreshingView = view;

        _refreshingView.frame = CGRectMake(0, 0, List_Refresh_Width, List_Refresh_Height);
        _refreshingView.alpha = 0.0;
    }
    return _refreshingView;
}

- (UIView *)preparingView {
    if (!_preparingView) {
        UIView *view;
        if ([self.delegate respondsToSelector:@selector(refreshViewPreparingView)]) {
            view = [self.delegate refreshViewPreparingView];
        }
        
        if (!view) {
            view = self.defaultPreparingView;
        }
        
        [self addSubview:view];
        
        _preparingView = view;
        
        _preparingView.frame = CGRectMake(0, 0, List_Refresh_Width, List_Refresh_Height);
        _preparingView.alpha = 0.0;
    }
    return _preparingView;
}

- (LHDefaultPullingView *)defaultPullingView {
    if (!_defaultPullingView) {
        _defaultPullingView = [[LHDefaultPullingView alloc] init];
    }
    return _defaultPullingView;
}
- (LHDefaultPreparingView *)defaultPreparingView {
    if (!_defaultPreparingView) {
        _defaultPreparingView = [[LHDefaultPreparingView alloc] init];
    }
    return _defaultPreparingView;
}
- (LHDefaultRefreshingView *)defaultRefreshingView {
    if (!_defaultRefreshingView) {
        _defaultRefreshingView = [[LHDefaultRefreshingView alloc] init];
    }
    return _defaultRefreshingView;
}
@end



@implementation LHDefaultPullingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        [self addSubview:title];
        title.text = @"下拉刷新";
        [title sizeToFit];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.subviews.firstObject.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end


@implementation LHDefaultPreparingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        [self addSubview:title];
        title.text = @"松手刷新";
        [title sizeToFit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.subviews.firstObject.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}
@end

@interface LHDefaultRefreshingView ()
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end
@implementation LHDefaultRefreshingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activity];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _activity.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    
    if (alpha == 1.0) {
        [_activity startAnimating];
    } else {
        [_activity stopAnimating];
    }
}
@end

