//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIScrollView+LHExtension.h"

@implementation UIScrollView (LHExtension)

- (void)setInsetT:(CGFloat)insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetT;
    self.contentInset = inset;
}

- (CGFloat)insetT
{
    return self.contentInset.top;
}

- (void)setInsetB:(CGFloat)insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetB;
    self.contentInset = inset;
}

- (CGFloat)insetB
{
    return self.contentInset.bottom;
}

- (void)setInsetL:(CGFloat)insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = insetL;
    self.contentInset = inset;
}

- (CGFloat)insetL
{
    return self.contentInset.left;
}

- (void)setInsetR:(CGFloat)insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = insetR;
    self.contentInset = inset;
}

- (CGFloat)insetR
{
    return self.contentInset.right;
}

- (void)setOffsetX:(CGFloat)offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = offsetX;
    self.contentOffset = offset;
}

- (CGFloat)offsetX
{
    return self.contentOffset.x;
}

- (void)setOffsetY:(CGFloat)offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

- (void)setContentSizeW:(CGFloat)contentSizeW
{
    CGSize size = self.contentSize;
    size.width = contentSizeW;
    self.contentSize = size;
}

- (CGFloat)contentSizeW
{
    return self.contentSize.width;
}

- (void)setContentSizeH:(CGFloat)contentSizeH
{
    CGSize size = self.contentSize;
    size.height = contentSizeH;
    self.contentSize = size;
}

- (CGFloat)contentSizeH
{
    return self.contentSize.height;
}
@end
