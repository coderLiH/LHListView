//
//  ViewController.m
//  LHListView
//
//  Created by 李允 on 15/12/26.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "ViewController.h"
#import "LHListView.h"
#import "LHListViewController.h"

@interface ViewController () <LHListViewDatasource, LHListViewDelegate, LHListViewRefresher>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view, typically from a nib.
    LHListView *listView = [LHListView listViewWithDisplayWidth:self.view.bounds.size.width];
    [self.view addSubview:listView];
    listView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    listView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    listView.listDelegate = self;
    listView.listDataSource = self;
    [listView registerClass:[LHListViewCell class] forCellWithReuseIdentifier:@"a"];
    [listView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"h"];
    [listView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"f"];
    listView.listRefresher = self;
    
}
- (NSInteger)numberOfSectionsInListView:(LHListView *)listView {
    return 1;
}

- (NSInteger)listView:(LHListView *)listView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (LHListViewCell *)listView:(LHListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHListViewCell *cell = [listView dequeueReusableCellWithReuseIdentifier:@"a" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)listView:(LHListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)listView:(LHListView *)listView heightForSectionTopMarginForSection:(NSInteger)section {
    return 30;
}

- (CGFloat)listView:(LHListView *)listView heightForSectionBottomMarginForSection:(NSInteger)section {
    return 50;
}

- (CGFloat)listView:(LHListView *)listView heightForRowSpaceForSection:(NSInteger)section {
    return 10;
}

- (void)listView:(LHListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}

- (BOOL)listView:(LHListView *)listView shouldEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (Class)listView:(LHListView *)listView editClassAtIndexPath:(NSIndexPath *)indexPath {
    return NSClassFromString(@"DeleteView");
}
- (CGFloat)listView:(LHListView *)listView widthForEditViewAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UICollectionReusableView *)listView:(LHListView *)listView sectionHeaderFooterViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [listView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"h" forIndexPath:indexPath];
    header.backgroundColor = [UIColor greenColor];
    UICollectionReusableView *footer = [listView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"f" forIndexPath:indexPath];
    footer.backgroundColor = [UIColor redColor];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return header;
    } else {
        return footer;
    }

}

- (CGFloat)listView:(LHListView *)listView heightForSectionHeaderAtSection:(NSInteger)section {
    return 50;
}
- (CGFloat)listView:(LHListView *)listView heightForSectionFooterAtSection:(NSInteger)section {
    return 100;
}

- (void)listViewDidBeginRefresh:(LHListView *)listView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [listView endRefreshing];
    });
}
@end
