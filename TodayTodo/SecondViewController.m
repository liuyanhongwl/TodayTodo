//
//  SecondViewController.m
//  Today Todo
//
//  Created by Hong on 16/7/20.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "SecondViewController.h"
#import "PostCell.h"
#import "Post.h"

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)loadData
{
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wlnana17.today"];
    NSArray *jsonList = [groupDefaults objectForKey:@"today-second"];
    if (jsonList && jsonList.count) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSString *jsonString in jsonList) {
            Post *post = [Post yy_modelWithJSON:jsonString];
            if (post) {
                [items addObject:post];
            }
        }
        self.dataArray = items;
    }else{
        
        __weak SecondViewController *weakSelf = self;
        
        [Post getPostCompletion:^(NSArray *posts, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataArray = posts;
            });
            
            [weakSelf saveData:posts];
        }];
    }
}

- (void)saveData:(NSArray <Post *>*)posts
{
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wlnana17.today"];
    NSMutableArray *items = [NSMutableArray array];
    for (Post *post in posts) {
        NSString *string = [post yy_modelToJSONString];
        if (string) {
            [items addObject:string];
        }
    }
    [groupDefaults setObject:items forKey:@"today-second"];
    [groupDefaults synchronize];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
