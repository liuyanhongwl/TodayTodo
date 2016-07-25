//
//  TodayNetworkViewController.m
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "TodayNetworkViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NetworkConstant.h"
#import "PostCell.h"
#import "Post.h"

@interface TodayNetworkViewController ()<NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *launchButton;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TodayNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NetworkConstant defaultConstant];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    _launchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.launchButton setTitle:@"去看看" forState:UIControlStateNormal];
    [self.launchButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.launchButton];
    
    __weak TodayNetworkViewController *weakSelf = self;
    
    [Post loadDataCompletion:^(NSArray<Post *> *posts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataArray = posts;
            if (weakSelf.dataArray.count) {
                [weakSelf showTableView];
            }else{
                [weakSelf showEmptyPlaceholder];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.bounds;
    [self.launchButton sizeToFit];
    self.launchButton.center = self.view.center;
}

#pragma mark - Helper

- (void)showEmptyPlaceholder
{
    self.tableView.hidden = YES;
    self.launchButton.hidden = NO;
    
    self.preferredContentSize = CGSizeMake(0, 44);
}

- (void)showTableView
{
    self.tableView.hidden = NO;
    self.launchButton.hidden = YES;
    [self.tableView reloadData];
    
    self.preferredContentSize  = CGSizeMake(0, self.dataArray.count * [PostCell cellHeight]);
}

#pragma mark - Action

- (void)addButtonAction:(UIButton *)button
{
    [self.extensionContext openURL:[NSURL URLWithString:@"todaytodo://launch_app"] completionHandler:nil];
}


#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PostCell class])];
    if (!cell) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PostCell class])];
    }
    cell.post = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PostCell cellHeight];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
