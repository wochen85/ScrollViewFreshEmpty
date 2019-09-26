//
//  MyTableViewController.m
//  ScrollViewFreshEmpty
//
//  Created by 陈海涛 on 2017/4/20.
//  Copyright © 2017年 陈海涛. All rights reserved.
//

#import "MyTableViewController.h"
#import "UIScrollView+FreshEmpty.h"

@interface MyTableViewController ()
@property (nonatomic, strong)NSMutableArray<NSString*>* dataArr;
@end

@implementation MyTableViewController
{
    int loadTime;
}

-(NSMutableArray<NSString*>*)dataArr
{
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    loadTime = 0;

    [self.tableView configFresh:[UIImage imageNamed:@"empty"] FreshTip:nil FreshTipColor:nil EmptyTip:@"暂无数据，请稍后重试" EmptyTipColor:nil TaskBlock:^{
        NSLog(@"刷新数据");
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView endFresh];
            [self.tableView resetNoMoreData];
            if (0 !=loadTime++)
            {
                [self.dataArr removeAllObjects];
                for (int i=0; i<10; i++)
                {
                    [self.dataArr addObject:@"item"];
                }
            }
            [self.tableView reloadData];
        });
    }];
    [self.tableView beginFresh];
    
    [self.tableView configLoadMore:@"向上拉加载更多" PullingTip:@"松开即可加载" FreshingTip:@"加载中，请稍候.." TipColor:nil TaskBlock:^{
        NSLog(@"加载更多...");
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView endLoadMore:self.dataArr.count>=30?YES:NO];
            for (int i=0; i<10; i++)
            {
                [self.dataArr addObject:@"item"];
            }
            [self.tableView reloadData];
        });
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
}

-(void)refresh
{
    [self.tableView beginFresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fuck"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fuck"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
