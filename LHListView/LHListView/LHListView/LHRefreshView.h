//
//  LHRefreshView.h
//  toy
//
//  Created by 李允 on 16/1/23.
//  Copyright © 2016年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHListView.h"

typedef NS_ENUM(NSInteger, LHRefreshViewState) {
    LHRefreshViewStateAnimating,
    LHRefreshViewStatePreparing,
    LHRefreshViewStateRefreshing
};

@protocol LHRefreshViewDelegate <NSObject>

@required
- (void)refreshDidBeginRefresh;

@optional
- (void)refreshViewWithProgress:(CGFloat)progress;

- (UIView *)refreshViewPullingView;

- (UIView *)refreshViewPreparingView;

- (UIView *)refreshViewRefreshingView;
@end

@class LHDefaultRefreshingView, LHDefaultPreparingView, LHDefaultPullingView;

@interface LHRefreshView : UIView

@property (nonatomic, weak) LHListView *listView;

@property (nonatomic, assign) LHRefreshViewState state;

@property (nonatomic, weak) id <LHRefreshViewDelegate> delegate;

- (void)endRefreshing;

- (void)listViewContentOffsetDidChange:(NSDictionary *)change;

- (void)listViewPanStateDidChange:(NSDictionary *)change;

@end





@interface LHDefaultPullingView : UIView
@end
@interface LHDefaultPreparingView : UIView
@end
@interface LHDefaultRefreshingView : UIView
@end






