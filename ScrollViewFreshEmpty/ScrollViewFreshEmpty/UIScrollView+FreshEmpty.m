//
//  UIScrollView+FreshEmpty.m
//  iOSQandA
//
//  Created by 陈海涛 on 2017/4/20.
//  Copyright © 2017年 陈海涛. All rights reserved.
//

#import "UIScrollView+FreshEmpty.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"

@implementation UIScrollView (FreshEmpty)

-(void) configFresh:(UIImage*)emptyImg FreshTip:(NSString*)freshTip FreshTipColor:(UIColor*)freshTipColor EmptyTip:(NSString*)emptyTip EmptyTipColor:(UIColor*)emptyTipColor TaskBlock:(void(^)(void))taskBlock
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
    self.emptyTip = emptyTip?:@"暂无数据";
    self.emptyTipColor = emptyTipColor;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        class_addProtocol([self class], @protocol(DZNEmptyDataSetSource));
        class_addProtocol([self class], @protocol(DZNEmptyDataSetDelegate));
        self.emptyDataSetSource = (id<DZNEmptyDataSetSource>)self;
        self.emptyDataSetDelegate = (id<DZNEmptyDataSetDelegate>)self;
    });
}

-(void) configFresh:(void(^)(void))taskBlock
{
    [self configFresh:nil FreshTip:nil FreshTipColor:nil EmptyTip:@"无可用数据" EmptyTipColor:nil TaskBlock:taskBlock];
}

-(void) beginFresh
{
    if (self.mj_header)
    {
        //滚动比较多时，刷新时滚动到头顶
        if ([self isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView*)self;
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            if ([tableView numberOfSections] > 0 && [tableView numberOfRowsInSection:0] > 0) {
                [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
        [self.mj_header beginRefreshing];
    }
}

-(void) configLoadMore:(NSString*) idleTip PullingTip:(NSString*)pullingTip FreshingTip:(NSString*) freshingTip TipColor:(UIColor*)tipColor TaskBlock:(void(^)(void))taskBlock
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

-(void) configLoadMore:(void(^)(void))taskBlock
{
    [self configLoadMore:nil PullingTip:nil FreshingTip:nil TipColor:nil TaskBlock:taskBlock];
}

-(void) endFresh
{
    [self.mj_header endRefreshing];
    [self tryReload];
}

-(void) tryReload
{
    SEL selector = NSSelectorFromString(@"reloadData");
    if ([self respondsToSelector:selector])
    {
        ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    }
}

-(void) endFresh:(BOOL) noMoreData
{
    [self endFresh];
    if (noMoreData)
        [self.mj_footer endRefreshingWithNoMoreData];
    else
        [self resetNoMoreData];
}

-(void) resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}

-(void) endLoadMore:(BOOL) noMoreData
{
    [self tryReload];
    if (noMoreData)
        [self.mj_footer endRefreshingWithNoMoreData];
    else
        [self.mj_footer endRefreshing];
}

-(void) setEmptyImg:(UIImage *)emptyImg
{
    objc_setAssociatedObject(self, @selector(emptyImg), emptyImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)emptyImg
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void) setEmptyTip:(NSString *)emptyTip
{
    objc_setAssociatedObject(self, @selector(emptyTip), emptyTip, OBJC_ASSOCIATION_COPY);
}

-(NSString*) emptyTip
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void) setEmptyTipColor:(UIColor *)emptyTipColor
{
    objc_setAssociatedObject(self, @selector(emptyTipColor), emptyTipColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIColor*) emptyTipColor
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void) setHaveReload:(NSNumber*)haveReload
{
    objc_setAssociatedObject(self, @selector(haveReload), haveReload, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber*) haveReload
{
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
//    if (!self.haveReload)
//    {
//        self.haveReload = @1;
//        return nil;
//    }
    return self.emptyImg;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
//    if (!self.haveReload || nil == self.emptyTip)
//    {
//        self.haveReload = @1;
//        return nil;
//    }
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
