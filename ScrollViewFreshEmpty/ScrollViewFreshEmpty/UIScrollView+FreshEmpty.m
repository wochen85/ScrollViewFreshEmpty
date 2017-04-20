//
//  UIScrollView+FreshEmpty.m
//  iOSQandA
//
//  Created by 陈海涛 on 2017/4/20.
//  Copyright © 2017年 陈海涛. All rights reserved.
//

#import "UIScrollView+FreshEmpty.h"
#import "MJRefresh/MJRefresh.h"
#import "DZNEmptyDataSet/UIScrollView+EmptyDataSet.h"

@implementation UIScrollView (FreshEmpty)

static const char emptyImgKey = 'i';
static const char emptyTipKey = 't';
static const char emptyTipColorKey = 'c';

-(void) configFresh:(UIImage*)emptyImg FreshTip:(NSString*)freshTip FreshTipColor:(UIColor*)freshTipColor EmptyTip:(NSString*)emptyTip EmptyTipColor:(UIColor*)emptyTipColor TaskBlock:(void(^)())taskBlock
{
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:taskBlock];
    header.lastUpdatedTimeLabel.hidden = YES;
    if (freshTip)
    {
        [header setTitle:freshTip forState:MJRefreshStateRefreshing];
    }
    if (freshTipColor)
    {
        header.stateLabel.textColor = freshTipColor;
    }
    self.mj_header = header;
    
    self.emptyImg = emptyImg;
    self.emptyTip = emptyTip;
    self.emptyTipColor = emptyTipColor;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        class_addProtocol([self class], @protocol(DZNEmptyDataSetSource));
        class_addProtocol([self class], @protocol(DZNEmptyDataSetDelegate));
        self.emptyDataSetSource = (id<DZNEmptyDataSetSource>)self;
        self.emptyDataSetDelegate = (id<DZNEmptyDataSetDelegate>)self;
    });
}

-(void) configFresh:(void(^)())taskBlock
{
    [self configFresh:nil FreshTip:nil FreshTipColor:nil EmptyTip:nil EmptyTipColor:nil TaskBlock:taskBlock];
}

-(void) beginFresh
{
    if (self.mj_header)
    {
        [self.mj_header beginRefreshing];
    }
}

-(void) configLoadMore:(NSString*) idleTip PullingTip:(NSString*)pullingTip FreshingTip:(NSString*) freshingTip TipColor:(UIColor*)tipColor TaskBlock:(void(^)())taskBlock
{
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:taskBlock];
    [footer setTitle:idleTip?:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:pullingTip?:@"松开加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:freshingTip?:@"加载中..." forState:MJRefreshStateRefreshing];
    if (tipColor)
    {
        footer.stateLabel.textColor = tipColor;
    }
    self.mj_footer = footer;
}

-(void) configLoadMore:(void(^)())taskBlock
{
    [self configLoadMore:nil PullingTip:nil FreshingTip:nil TipColor:nil TaskBlock:taskBlock];
}

-(void) endFresh
{
    [self.mj_header endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isKindOfClass:[UITableView class]])
        {
            [((UITableView*)self) reloadData];
        }
        else if ([self isKindOfClass:[UICollectionView class]])
        {
            [((UICollectionView*)self) reloadData];
        }
    });
}

-(void) endLoadMore:(BOOL) noMoreData
{
    if (noMoreData)
        [self.mj_footer endRefreshingWithNoMoreData];
    else
        [self.mj_footer endRefreshing];
}

-(void) setEmptyImg:(UIImage *)emptyImg
{
    objc_setAssociatedObject(self, &emptyImgKey, emptyImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)emptyImg
{
    return objc_getAssociatedObject(self, &emptyImgKey);
}

-(void) setEmptyTip:(NSString *)emptyTip
{
    objc_setAssociatedObject(self, &emptyTipKey, emptyTip, OBJC_ASSOCIATION_COPY);
}

-(NSString*) emptyTip
{
    return objc_getAssociatedObject(self, &emptyTipKey);
}

-(void) setEmptyTipColor:(UIColor *)emptyTipColor
{
    objc_setAssociatedObject(self, &emptyTipColorKey, emptyTipColor, OBJC_ASSOCIATION_COPY);
}

-(UIColor*) emptyTipColor
{
    return objc_getAssociatedObject(self, &emptyTipColorKey);
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.mj_header.isRefreshing)
        return nil;
    return self.emptyImg;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.mj_header.isRefreshing || nil == self.emptyTip)
        return nil;
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = nil;
    if (self.emptyTipColor)
    {
        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.f],
                       NSForegroundColorAttributeName: self.emptyTipColor,
                       NSParagraphStyleAttributeName: paragraph};
    }
    else
    {
        attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.f],
          NSForegroundColorAttributeName: [UIColor lightGrayColor],
          NSParagraphStyleAttributeName: paragraph};
    }
    
    return [[NSAttributedString alloc] initWithString:self.emptyTip attributes:attributes];
}

@end
