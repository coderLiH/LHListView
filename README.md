# LHListView
implement UITableView with UICollectionView


## Introduction
why did I write this framework？</br>
- [too many times for heightForRowAtIndexpath’s implementation](http://www.csdn.net/article/2015-05-19/2824709-cell-height-calculation)</br>
- [inconvenient for section margin](http://blog.csdn.net/xumingwei12345/article/details/9664773)</br>



## Features
- as easy as tableView
- maybe more scalable than tableView
- simple to learn


## Usage

+  +(instancetype)listViewWithDisplayWidth:(CGFloat)displayWidth;</br>
`displayWidth need to be same with listView's width`
+   listView.listDelegate = self;</br>
    listView.listDataSource = self;</br>
`just like tableView and collectionView`</br>
`include the methods need to be implemented`
+   -(CGFloat)listView:(LHListView *)listView heightForSectionTopMarginForSection:(NSInteger)section;</br>
`margin between sectionHeader and first row`</br>
+   -(CGFloat)listView:(LHListView *)listView heightForRowSpaceForSection:(NSInteger)section;</br>
`margin between two rows`</br>
+   -(BOOL)listView:(LHListView *)listView shouldEditRowAtIndexPath:(NSIndexPath *)indexPath;</br>
`if need editStyle, just return YES`</br>
+   -(Class)listView:(LHListView *)listView editClassAtIndexPath:(NSIndexPath *)indexPath;</br>
`return a custom editView, this class must be subClass of  LHListViewCellEditView`</br>
+   -(CGFloat)listView:(LHListView *)listView widthForEditViewAtIndexPath:(NSIndexPath *)indexPath;</br>
`editView's width`</br>

+ others includes sectionHeader、sectionFooter、adsorbHeader\adsorbFooter</br>
Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).


## Wish
hope u will join me to build this framework better
