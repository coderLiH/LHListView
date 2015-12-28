//
//  LHListView.h
//  LHListView
//
//  Created by 李允 on 15/12/26.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const LHListViewCellEnterEditNotification;
UIKIT_EXTERN NSString *const LHListViewCellEndEditNotification;

struct LHIndex {
    NSInteger row;
    NSInteger section;
};

typedef struct LHIndex LHIndex;

CG_INLINE LHIndex
LHIndexMake(NSInteger row, NSInteger section)
{
    LHIndex index; index.row = row; index.section = section; return index;
}


@class LHListView,LHListViewCell;


@protocol LHListViewDelegate <NSObject>
@optional
- (CGFloat)listView:(LHListView *)listView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)listView:(LHListView *)listView heightForSectionTopMarginForSection:(NSInteger)section;

- (CGFloat)listView:(LHListView *)listView heightForSectionBottomMarginForSection:(NSInteger)section;

- (CGFloat)listView:(LHListView *)listView heightForRowSpaceForSection:(NSInteger)section;

- (void)listView:(LHListView *)listView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/** these two method don't need to be implemented together, but if implement "editClassAtIndexPath", be sure it's before "shouldEditRowAtIndexPath" */
- (Class)listView:(LHListView *)listView editClassAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)listView:(LHListView *)listView shouldEditRowAtIndexPath:(NSIndexPath *)indexPath;

/** default to be 60 */
- (CGFloat)listView:(LHListView *)listView widthForEditViewAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)listView:(LHListView *)listView heightForSectionHeaderAtSection:(NSInteger)section;

- (CGFloat)listView:(LHListView *)listView heightForSectionFooterAtSection:(NSInteger)section;
@end



@protocol LHListViewDatasource <NSObject>
@required
- (NSInteger)listView:(LHListView *)listView numberOfRowsInSection:(NSInteger)section;

- (LHListViewCell *)listView:(LHListView *)listView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInListView:(LHListView *)listView;

- (UICollectionReusableView *)listView:(LHListView *)listView sectionHeaderFooterViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end



@interface LHListView : UICollectionView

@property (nonatomic, weak) id <LHListViewDelegate> listDelegate;
@property (nonatomic, weak) id <LHListViewDatasource> listDataSource;

+ (instancetype)listViewWithDisplayWidth:(CGFloat)displayWidth;

@property (nonatomic, assign) BOOL adsorbHeader;
@property (nonatomic, assign) BOOL adsorbFooter;
@end



@interface LHListViewCell : UICollectionViewCell
@property (nonatomic, assign) CGFloat editWidth;
@property (nonatomic, assign) Class editClass;
@property (nonatomic, assign) BOOL editing;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) LHIndex index;
@end



@interface LHListViewCellEditView : UIView
@property (nonatomic, assign) LHIndex index;
@end