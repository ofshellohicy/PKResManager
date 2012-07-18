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
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"Light",@"Night",@"Custom" ,nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    NSString *dataStr = [self.dataArray objectAtIndex:indexPath.row];
    if ([dataStr isEqualToString:@"Light"]) {        
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_LIGHT];
    }else if([dataStr isEqualToString:@"Night"]){
        [[PKResManager getInstance] swithToStyle:SYSTEM_STYLE_NIGHT];        
    }else if([dataStr isEqualToString:@"Custom"]){
        [[PKResManager getInstance] swithToStyle:CUSTOM_STYLE];                
    }
}
@end
