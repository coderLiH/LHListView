//
//  LHCollectionRoot.h
//  toy
//
//  Created by 李允 on 16/1/29.
//  Copyright © 2016年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define List_Refresh_Height         80
#define List_Refresh_Width          ([[UIScreen mainScreen] bounds].size.width)


@class LHCollectionRoot;
@protocol LHListViewRefresher <NSObject>

@required
- (void)listViewDidBeginRefresh:(LHCollectionRoot *)listView;
@optional
- (void)listView:(LHCollectionRoot *)listView refreshProgress:(CGFloat)progress;
- (UIView *)listViewRefreshPullingView;
- (UIView *)listViewRefreshPreparingView;
- (UIView *)listViewRefreshRefreshingView;

@end

@interface LHCollectionRoot : UICollectionView

@property (nonatomic, assign) CGFloat displayWidth;

@property (nonatomic, weak) id <LHListViewRefresher> listRefresher;

- (void)endRefreshing;

- (BOOL)isRefreshing;

@end
