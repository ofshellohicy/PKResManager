//
//  PKDemoViewController.m
//  PKResManager
//
//  Created by zhong sheng on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PKDemoViewController.h"
#import "PKAllStyleViewController.h"

@interface PKDemoViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) PKAllStyleViewController *allStyleController;
@end

@implementation PKDemoViewController
@synthesize 
tableView = _tableView,
dataArray,
allStyleController = _allStyleController;
- (void)dealloc
{
    self.allStyleController = nil;
    self.dataArray = nil;
    self.tableView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Demo";
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"All",@"Custom",@"Reset", nil];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    NSLog(@"demo count:%d",self.retainCount);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    NSString *demoId = @"demoId";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:demoId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:demoId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    // 
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dataStr = [self.dataArray objectAtIndex:indexPath.row];
    if ([dataStr isEqualToString:@"All"]) {
//        if (!_allStyleController) {
//            _allStyleController = [[PKAllStyleViewController alloc] init];   
//        }
//        [self.navigationController pushViewController:_allStyleController animated:YES];
        
        PKAllStyleViewController *viewController = [[PKAllStyleViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
    }else if([dataStr isEqualToString:@"Custom"]){
        
    }else if([dataStr isEqualToString:@"Reset"]){
        [[PKResManager getInstance] resetStyle];
    }
}

@end
