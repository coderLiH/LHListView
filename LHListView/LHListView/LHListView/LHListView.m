//
//  LHListView.m
//  LHListView
//
//  Created by 李允 on 15/12/26.
//  Copyright © 2015年 liyun. All rights reserved.
//

#import "LHListView.h"
#import "LHReachability.h"


NSString *const LHListViewCellEnterEditNotification = @"LHListViewCellEnterEditNotification";
NSString *const LHListViewCellEndEditNotification = @"LHListViewCellEndEditNotification";


@interface LHListView () <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LHListView

+ (instancetype)listViewWithDisplayWidth:(CGFloat)displayWidth {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    LHListView *listView = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    listView.displayWidth = displayWidth;
    listView.delegate = listView;
    listView.dataSource = listView;
    listView.layout = layout;    
    return listView;
}

- (void)reloadData {
    [super reloadData];
    [self contentMaker];
}

- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [super reloadItemsAtIndexPaths:indexPaths];
    [self contentMaker];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [super reloadSections:sections];
    [self contentMaker];
}

- (NSInteger)totalRows {
    NSInteger totalRows = 0;
    NSInteger sections = [self numberOfSections];
    for (NSInteger i = 0; i < sections; i++) {
        NSInteger rows = [self numberOfItemsInSection:i];
        totalRows += rows;
    }
    return totalRows;
}

- (void)contentMaker {
    NSInteger totalRows = [self totalRows];
    
    if (totalRows == 0) {
        self.imageView.hidden = NO;
        [self bringSubviewToFront:self.imageView];
        
        [self.imageView.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer * obj, NSUInteger idx, BOOL * stop) {
            [self.imageView removeGestureRecognizer:obj];
        }];
        
        [[LHReachability sharedInstance] reachable:^{
            self.imageView.image = self.reachImage;
            self.imageView.frame = CGRectMake((self.displayWidth-self.reachImage.size.width)/2, _imageViewY, self.reachImage.size.width, self.reachImage.size.height);
            UITapGestureRecognizer *reachTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reachTap)];
            [self.imageView addGestureRecognizer:reachTap];
        } or:^{
            UITapGestureRecognizer *unreachTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unreachTap)];
            [self.imageView addGestureRecognizer:unreachTap];
            self.imageView.image = self.unReachImage;
            self.imageView.frame = CGRectMake((self.displayWidth-self.unReachImage.size.width)/2, _imageViewY, self.unReachImage.size.width, self.unReachImage.size.height);
        }];
    } else {
        self.imageView.hidden = YES;
    }
}

- (void)reachTap {
    if ([self.listDelegate respondsToSelector:@selector(listViewDidTapReachImage:)]) {
        [self.listDelegate listViewDidTapReachImage:self];
    }
}

- (void)unreachTap {
    if ([self.listDelegate respondsToSelector:@selector(listViewDidTapUnreachImage:)]) {
        [self.listDelegate listViewDidTapUnreachImage:self];
    }
}

- (void)setAdsorbHeader:(BOOL)adsorbHeader {
    _adsorbHeader = adsorbHeader;
    
    self.layout.sectionHeadersPinToVisibleBounds = adsorbHeader;
}

- (void)setAdsorbFooter:(BOOL)adsorbFooter {
    _adsorbFooter = adsorbFooter;
    
    self.layout.sectionFootersPinToVisibleBounds = adsorbFooter;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.listDataSource respondsToSelector:@selector(numberOfSectionsInListView:)]) {
        return [self.listDataSource numberOfSectionsInListView:self];
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.listDataSource listView:self numberOfRowsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LHListViewCell *cell = [self.listDataSource listView:self cellForRowAtIndexPath:indexPath];
//    cell.scrollView = self;
    [cell setValue:self forKey:@"scrollView"];
    
    if ([self.listDelegate respondsToSelector:@selector(listView:shouldEditRowAtIndexPath:)]) {
        if ([self.listDelegate respondsToSelector:@selector(listView:widthForEditViewAtIndexPath:)]) {
            [cell setValue:@([self.listDelegate listView:self widthForEditViewAtIndexPath:indexPath]) forKey:@"editWidth"];
//            cell.editWidth = [self.listDelegate listView:self widthForEditViewAtIndexPath:indexPath];
        } else {
            [cell setValue:@(60) forKey:@"editWidth"];
//            cell.editWidth = 60;
        }
        if ([self.listDelegate respondsToSelector:@selector(listView:editClassAtIndexPath:)]) {
            Class class = [self.listDelegate listView:self editClassAtIndexPath:indexPath];
            if ([class isSubclassOfClass:NSClassFromString(@"LHListViewCellEditView")]) {
//                cell.editClass = class;
                [cell setValue:class forKey:@"editClass"];
            } else {
                NSString *classString = [NSString stringWithFormat:@"%@ is not subClass of LHListViewCellEditView", NSStringFromClass(class)];
                NSAssert(nil, classString);
            }
        } else {
            [cell setValue:NSClassFromString(@"LHListViewCellEditView") forKey:@"editClass"];
//            cell.editClass = NSClassFromString(@"LHListViewCellEditView");
        }
        [cell setValue:@([self.listDelegate listView:self shouldEditRowAtIndexPath:indexPath]) forKey:@"editing"];
//        cell.editing = [self.listDelegate listView:self shouldEditRowAtIndexPath:indexPath];
    } else {
        [cell setValue:@(NO) forKey:@"editing"];
//        cell.editing = NO;
    }
    cell.index = LHIndexMake(indexPath.row, indexPath.section);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.listDataSource respondsToSelector:@selector(listView:sectionHeaderFooterViewOfKind:atIndexPath:)]) {
        return [self.listDataSource listView:self sectionHeaderFooterViewOfKind:kind atIndexPath:indexPath];
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForRowAtIndexPath:)]) {
        return CGSizeMake(self.displayWidth, [self.listDelegate listView:self heightForRowAtIndexPath:indexPath]);
    } else {
        return CGSizeMake(self.displayWidth, 44);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat topMargin = 0;
    CGFloat bottomMargin = 0;
    
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForSectionTopMarginForSection:)]) {
        topMargin = [self.listDelegate listView:self heightForSectionTopMarginForSection:section];
    }
    
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForSectionBottomMarginForSection:)]) {
        bottomMargin = [self.listDelegate listView:self heightForSectionBottomMarginForSection:section];
    }
    
    return UIEdgeInsetsMake(topMargin, 0, bottomMargin, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForRowSpaceForSection:)]) {
        return [self.listDelegate listView:self heightForRowSpaceForSection:section];
    } else {
        return 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.listDelegate respondsToSelector:@selector(listView:didSelectRowAtIndexPath:)]) {
        [self.listDelegate listView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForSectionHeaderAtSection:)]) {
        return CGSizeMake(self.displayWidth, [self.listDelegate listView:self heightForSectionHeaderAtSection:section]);
    } else {
        return CGSizeMake(0, 0);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.listDelegate respondsToSelector:@selector(listView:heightForSectionFooterAtSection:)]) {
        return CGSizeMake(self.displayWidth, [self.listDelegate listView:self heightForSectionFooterAtSection:section]);
    } else {
        return CGSizeMake(0, 0);
    }
}

#pragma mark lazy
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
@end





@interface LHListViewCellEditView ()
@property (nonatomic, strong) UITapGestureRecognizer *rootTap;
@end

@implementation LHListViewCellEditView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        _rootTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:_rootTap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(editView:didTapWithTap:)]) {
        [self.delegate editView:self didTapWithTap:tap];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LHListViewCellEndEditNotification object:nil userInfo:@{@"unanimate":@(YES)}];
}
@end









@interface LHListViewCell () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) Class editClass;
@property (nonatomic, assign) CGFloat editWidth;
@property (nonatomic, assign) BOOL editing;

@property (nonatomic, weak)   UIScrollView *scrollView;
@property (nonatomic, strong) LHListViewCellEditView *editView;
@property (nonatomic, strong) UIPanGestureRecognizer *editGesture;
@property (nonatomic, strong) UIView *cancelEditView;
@end

@implementation LHListViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.hidden = YES;
        self.contentContainer.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterEdit) name:LHListViewCellEnterEditNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEdit:) name:LHListViewCellEndEditNotification object:nil];
    }
    return self;
}

- (void)enterEdit {
    self.cancelEditView.hidden = NO;
    [self.contentContainer bringSubviewToFront:self.cancelEditView];
}

- (void)endEdit:(NSNotification *)noti {
    BOOL animate = ![noti.userInfo[@"unanimate"] boolValue];
    [self animateBackNeedAnimation:animate];
    self.cancelEditView.hidden = YES;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    if (editing) {
        self.editView.hidden = NO;
    } else {
        self.editView.hidden = YES;
    }
    
    [self decideWhetherNeedEditGesture:editing];
}

- (void)decideWhetherNeedEditGesture:(BOOL)editing {
    if (editing) {
        if (![self.gestureRecognizers containsObject:self.editGesture]) {
            [self addGestureRecognizer:self.editGesture];
        }
    } else {
        if ([self.gestureRecognizers containsObject:self.editGesture]) {
            [self removeGestureRecognizer:self.editGesture];
        }
    }
}

- (void)editGestureRealize:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
        {
            if (!self.scrollView.dragging) {
                CGPoint move = [pan translationInView:self];
                self.scrollView.scrollEnabled = NO;
                if (self.contentContainer.frame.origin.x >= -self.editWidth && self.contentContainer.frame.origin.x <= 0) {
                    self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x+move.x, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
                } else {
                    if (self.contentContainer.frame.origin.x > 20) {
                        self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x+move.x/40.0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
                    } else {
                        self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x+move.x/20.0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
                    }
                }
            } else {
                //                if (self.contentContainer.frame.origin.x != 0) {}
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            self.scrollView.scrollEnabled = YES;
            if (self.contentContainer.frame.origin.x >= -self.editWidth/2) {
                [self animateBackNeedAnimation:YES];
            } else {
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.contentContainer.frame = CGRectMake(-self.editWidth, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
                } completion:^(BOOL finished) {
                    if ([self.gestureRecognizers containsObject:self.editGesture]) {
                        [self removeGestureRecognizer:self.editGesture];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:LHListViewCellEnterEditNotification object:nil];
                }];
            }
        }
            break;
        default:
            self.scrollView.scrollEnabled = YES;
            break;
    }
    [pan setTranslation:CGPointZero inView:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)animateBackNeedAnimation:(BOOL)need {
    if (need) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentContainer.frame = self.bounds;
        } completion:^(BOOL finished) {
            [self decideWhetherNeedEditGesture:self.editing];
        }];
    } else {
        self.contentContainer.frame = self.bounds;
        [self decideWhetherNeedEditGesture:self.editing];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self animateBackNeedAnimation:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.editView.frame = CGRectMake(self.bounds.size.width-self.editWidth, 0, self.editWidth, self.bounds.size.height);
    _contentContainer.frame = CGRectMake(_contentContainer.frame.origin.x, _contentContainer.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.cancelEditView.frame = self.contentContainer.bounds;
}

- (void)cancelEdit {
    [[NSNotificationCenter defaultCenter] postNotificationName:LHListViewCellEndEditNotification object:nil];
}

- (void)setIndex:(LHIndex)index {
    _index = index;
    
    self.editView.index = index;
}

#pragma mark lazy
- (UIView *)contentContainer {
    if (!_contentContainer) {
        _contentContainer = [[UIView alloc] init];
        [self addSubview:_contentContainer];
    }
    return _contentContainer;
}
- (UIPanGestureRecognizer *)editGesture {
    if (!_editGesture) {
        _editGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureRealize:)];
        _editGesture.delegate = self;
        //        [_editGesture requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
        //        [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:_editGesture];
    }
    return _editGesture;
}
- (LHListViewCellEditView *)editView {
    if (!_editView) {
        _editView = [[self.editClass alloc] init];
        [self addSubview:_editView];
        [self sendSubviewToBack:_editView];
        _editView.hidden = YES;
        _editView.delegate = self;
    }
    return _editView;
}

- (UIView *)cancelEditView {
    if (!_cancelEditView) {
        _cancelEditView = [[UIView alloc] init];
        [self.contentContainer addSubview:_cancelEditView];
        _cancelEditView.backgroundColor = [UIColor clearColor];
        _cancelEditView.hidden = YES;
        
        UILongPressGestureRecognizer *cancelL = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
        [_editGesture requireGestureRecognizerToFail:cancelL];
        [_cancelEditView addGestureRecognizer:cancelL];
        UIPanGestureRecognizer *cancelP = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
        [_editGesture requireGestureRecognizerToFail:cancelP];
        [_cancelEditView addGestureRecognizer:cancelP];
        UITapGestureRecognizer *cancelT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
        [_editGesture requireGestureRecognizerToFail:cancelT];
        [_cancelEditView addGestureRecognizer:cancelT];
        UIPinchGestureRecognizer *cancelPi = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
        [_editGesture requireGestureRecognizerToFail:cancelPi];
        [_cancelEditView addGestureRecognizer:cancelPi];
        UISwipeGestureRecognizer *cancelS = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEdit)];
        [_editGesture requireGestureRecognizerToFail:cancelS];
        [_cancelEditView addGestureRecognizer:cancelS];
    }
    return _cancelEditView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end