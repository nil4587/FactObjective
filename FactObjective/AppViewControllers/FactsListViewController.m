//
//  FactsListViewController.m
//  FactObjective
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import "FactsListViewController.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "TableViewDataSource.h"
#import "TableViewDelegate.h"
#import "FactsController.h"

//-- Private declaration properties
@interface FactsListViewController ()
@property(strong, nonatomic) UIRefreshControl *refreshControler;
@property(strong, nonatomic) TableViewDataSource *tableviewDatasource; //-- Tableview datasource
@property(strong, nonatomic) TableViewDelegate *tableviewDelegate; //-- Tableview delegate
@property(strong, nonatomic) FactsController *factController; //-- Controller to handle the actions
@end

@implementation FactsListViewController
@synthesize refreshControler = _refreshControler;
@synthesize factController = _factController;
@synthesize tableviewDatasource = _tableviewDatasource;
@synthesize tableviewDelegate = _tableviewDelegate;

#pragma mark - ==================================
#pragma mark View Life-cycle
#pragma mark ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //-- Change status bar style
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //-- NavigationBar right bar item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];

    //-- Tableview's row height & estimated row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
        self.tableView.estimatedRowHeight = 110.0;
    } else {
        self.tableView.estimatedRowHeight = 65.0;
    }
    self.tableView.tableFooterView = [UIView new];
    
    //-- Tableview's pull to refresh control
    _refreshControler = [[UIRefreshControl alloc] init];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = _refreshControler;
    } else {
        [self.tableView addSubview:_refreshControler];
    }
    [_refreshControler addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    //-- Intiate the controller
    FactsController *obj_factController = [[FactsController alloc] init];
    obj_factController.delegate = (id)self;
    self.factController = obj_factController; //-- Assign a controller
    obj_factController = nil;
    
    //-- Initiate the datasource for table view & integrate datesource methods with the help of FactController
    _tableviewDatasource = [[TableViewDataSource alloc] initTableView:self.tableView withViewController:self.factController];
    //-- Initiate the delegate for table view & integrate delegate methods with the help of FactController
    _tableviewDelegate = [[TableViewDelegate alloc] initTableView:self.tableView withViewController:self.factController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    _refreshControler = nil;
}

#pragma mark - ==================================
#pragma mark FactController Delegate methods
#pragma mark ==================================

//-- A delegate method called after the un-successful execution by FactController
- (void)connectionDidReceiveFailure:(NSString *)error {
    self.title = @"";
    [appDelegate displayAnAlertWith:@"Alert !!" andMessage:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
    });
}

//-- A delegate method called after the successful execution by FactController
- (void)connectionDidFinishLoading:(NSDictionary *)dictResponseInfo {
    self.title = dictResponseInfo[@"title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
        if (self.factController.arrFacts != nil && self.factController.arrFacts.count > 0) {
            self.tableView.hidden = NO;
        } else {
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
    });
}

#pragma mark - ==================================
#pragma mark Controls click events
#pragma mark ==================================

//-- Click event for top right bar button item
- (IBAction)btnRefreshClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [_refreshControler endRefreshing];
    [self.factController fetchDataFromJSONFile];
}

//-- Pull to refresh event by pulling down the tableview
- (IBAction)pullToRefresh:(id)sender {
    [_refreshControler beginRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [self.factController fetchDataFromJSONFile];
}

@end
