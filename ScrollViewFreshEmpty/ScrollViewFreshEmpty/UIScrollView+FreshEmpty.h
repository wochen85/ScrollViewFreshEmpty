//
//  UIScrollView+FreshEmpty.h
//  iOSQandA
//
//  Created by 陈海涛 on 2017/4/20.
//  Copyright © 2017年 陈海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FreshEmpty)

//刷新以及空页面
-(void) configFresh:(UIImage*)emptyImg FreshTip:(NSString*)freshTip FreshTipColor:(UIColor*)freshTipColor EmptyTip:(NSString*)emptyTip EmptyTipColor:(UIColor*)emptyTipColor TaskBlock:(void(^)(void))taskBlock;
-(void) configFresh:(void(^)(void))taskBlock;
-(void) beginFresh;
-(void) endFresh;
-(void) endFresh:(BOOL) noMoreData;
-(void) resetNoMoreData;

//加载更多
-(void) configLoadMore:(NSString*) idleTip PullingTip:(NSString*)pullingTip FreshingTip:(NSString*) freshingTip TipColor:(UIColor*)tipColor TaskBlock:(void(^)(void))taskBlock;
-(void) configLoadMore:(void(^)(void))taskBlock;
-(void) endLoadMore:(BOOL) noMoreData;

@property (nonatomic, strong) UIImage* emptyImg;
@property (nonatomic, copy) NSString* emptyTip; //空提示，默认为“暂无数据”
@property (nonatomic, strong) UIColor* emptyTipColor;
@property (nonatomic) NSNumber* haveReload;
@end
