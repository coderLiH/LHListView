//
//  LHListViewController.m
//  LHListView
//
//  Created by 李允 on 15/12/29.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "LHListViewController.h"
#import "LHListView.h"

@interface LHListViewController () <LHListViewDatasource, LHListViewDelegate>
@property (nonatomic, strong) LHListView *listView;
@end

@implementation LHListViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view = self.collectionView = self.listView = [LHListView listViewWithDisplayWidth:[UIScreen mainScreen].bounds.size.width];
        self.listView.listDelegate = self;
        self.listView.listDataSource = self;
        self.listView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.view = self.collectionView = self.listView = [LHListView listViewWithDisplayWidth:[UIScreen mainScreen].bounds.size.width];
        self.listView.listDelegate = self;
        self.listView.listDataSource = self;
        self.listView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)listView:(LHListView *)listView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (LHListViewCell *)listView:(LHListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
@end
