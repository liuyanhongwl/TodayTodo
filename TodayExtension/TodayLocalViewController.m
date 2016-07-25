//
//  TodayLocalViewController.m
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "TodayLocalViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayLocalViewController ()<NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TodayLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = self.view.bounds;
    [self.addButton setTitle:@"点击添加事件" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    [self loadContentsFromLocal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.bounds;
    self.addButton.frame = self.view.bounds;
}

#pragma mark - Helper

- (void)loadContentsFromLocal
{
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wlnana17.today"];
    self.dataArray = [groupDefaults objectForKey:@"today-snapshot"];
    
    if (self.dataArray.count) {
        [self showTableView];
    }else{
        [self showEmptyPlaceholder];
    }
}

- (void)showEmptyPlaceholder
{
    self.tableView.hidden = YES;
    self.addButton.hidden = NO;
    
    self.preferredContentSize = CGSizeMake(0, 44);
}

- (void)showTableView
{
    self.tableView.hidden = NO;
    self.addButton.hidden = YES;
    [self.tableView reloadData];
    
    self.preferredContentSize  = CGSizeMake(0, self.dataArray.count * 44);
}

#pragma mark - Action

- (void)addButtonAction:(UIButton *)button
{
    [self.extensionContext openURL:[NSURL URLWithString:@"todaytodo://new_item"] completionHandler:nil];
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"todaytodo://select_item?item=%@", [self.dataArray objectAtIndex:indexPath.row]]] completionHandler:nil];
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
