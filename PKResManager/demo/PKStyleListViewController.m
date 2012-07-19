//
//  PKStyleListViewController.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKStyleListViewController.h"

@interface PKStyleListViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
- (void)refreshDataSource;
@end

@implementation PKStyleListViewController
@synthesize 
tableView = _tableView,
dataArray = _dataArray;


- (void)dealloc
{
    self.tableView = nil;
    self.dataArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    [self refreshDataSource];
    
    UIButton *addCustomStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 300, 60, 30)];
    addCustomStyleBtn.backgroundColor = [UIColor blueColor];
    [addCustomStyleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addCustomStyleBtn setTitle:@"Add" forState:UIControlStateNormal];
    [addCustomStyleBtn addTarget:self 
                          action:@selector(addCustomStyleAction:) 
                forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:addCustomStyleBtn];
    
    
    UIButton *delCustomStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 300, 60, 30)];
    [delCustomStyleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
    delCustomStyleBtn.backgroundColor = [UIColor redColor];
    [delCustomStyleBtn setTitle:@"Del" forState:UIControlStateNormal];
    [delCustomStyleBtn addTarget:self 
                          action:@selector(delCustomStyleAction:) 
                forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:delCustomStyleBtn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark - Private
- (void)refreshDataSource
{
    NSMutableArray *allStyleArray = [PKResManager getInstance].allStyleArray;
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:allStyleArray.count];
    }
    [_dataArray removeAllObjects];
    [allStyleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aStyleDict = (NSDictionary*)obj;
        NSString *styleName = [aStyleDict objectForKey:kStyleName];
        //NSString *styleVersion = [aStyleDict objectForKey:kStyleVersion];
        [_dataArray addObject:styleName];
        if (stop) {
            [self.tableView reloadData];
        }
    }];
    
    
}
- (void)addCustomStyleAction:(id)sender
{
    // test save custom style
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"testSave" ofType:@"bundle"]];    
    [[PKResManager getInstance] saveStyle:CUSTOM_STYLE withBundle:bundle];
    [self refreshDataSource];
}
- (void)delCustomStyleAction:(id)sender
{
    [[PKResManager getInstance] deleteStyle:CUSTOM_STYLE];
    [self refreshDataSource];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count > 0) {
        return self.dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"styleListId";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *styleName = [self.dataArray objectAtIndex:indexPath.row];
    [[PKResManager getInstance] swithToStyle:styleName];
}

@end
