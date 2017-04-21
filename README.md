# ScrollViewFreshEmpty
一行代码搞定下拉刷新组件和UIScrollView空页面展现。
整合UIScrollView的下拉刷新、空页面显示，简化MJRefresh和DZNEmptyDataSet的使用。

## Requirements

* iOS 6.0+
* ARC

## Installation

**ScrollViewFreshEmpty** can be installed using CocoaPods

### CocoaPods

Add the following to your **podfile**
```
pod 'ScrollViewFreshEmpty'
```
## Usage 

Using **ScrollViewFreshEmpty** in your app is very simple.

### Example

```
#import "UIScrollView+FreshEmpty.h"

[self.tableView configFresh:[UIImage imageNamed:@"empty"] FreshTip:nil FreshTipColor:nil EmptyTip:@"暂无数据，请稍后重试" EmptyTipColor:nil TaskBlock:^{
        NSLog(@"刷新数据");
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView endFresh];
        });
    }];
    [self.tableView beginFresh];
    
[self.tableView configLoadMore:@"向上拉加载更多" PullingTip:@"松开即可加载" FreshingTip:@"加载中，请稍候.." TipColor:nil TaskBlock:^{
      NSLog(@"加载更多...");

      dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
      dispatch_after(delayTime, dispatch_get_main_queue(), ^{
          [self.tableView endLoadMore:NO];
      });
  }];
```
### Screenshots

<img src="http://bmob-cdn-10798.b0.upaiyun.com/2017/04/21/d8ce6a0540247c238093695b6c976afe.png" width="320" height="568">
<img src="http://bmob-cdn-10798.b0.upaiyun.com/2017/04/21/d581b97140045c8980651f59253ea08f.png" width="320" height="568">
