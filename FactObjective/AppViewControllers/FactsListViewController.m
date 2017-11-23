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
@property(strong, nonatomic) TableViewDataSource *tableviewDatasource;
@property(strong, nonatomic) TableViewDelegate *tableviewDelegate;
@property(strong, nonatomic) FactsController *factController;
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

- (void)connectionDidReceiveFailure:(NSString *)error {
    self.title = @"";
    [appDelegate displayAnAlertWith:@"Alert !!" andMessage:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
    });
}

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
/*
#pragma mark - ==================================
#pragma mark User-defined methods
#pragma mark ==================================

- (void)resetProperties {
    //-- Remove the old data prior making a web-service call
    _data = nil;
    //-- Remove the old response prior making a web-service call
    _response = nil;
    //-- Cancel the previous operation prior starting a new operation
    if (_connection) {
        [_connection cancel];
        //-- Un-Schedule the run loop for connection
        [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _connection = nil;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    CGSize size = image.size;
    
    CGFloat widthRatio  = newSize.width  / image.size.width;
    CGFloat heightRatio = newSize.height / image.size.height;
    
    // Figure out what our orientation is, and use that to form the rectangle
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio);
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio);
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
*/

#pragma mark - ==================================
#pragma mark Controls click events
#pragma mark ==================================

- (IBAction)btnRefreshClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [_refreshControler endRefreshing];
    [self.factController fetchDataFromJSONFile];
}

- (IBAction)pullToRefresh:(id)sender {
    [_refreshControler beginRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [self.factController fetchDataFromJSONFile];
}
/*
#pragma mark - ==================================
#pragma mark Web-service call
#pragma mark ==================================

- (void)fetchDataFromJSONFile {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To show the network indicator until the process is running.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    
    //-- Search Query preparation
    NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [JSON_FILE_URL stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
    
    //-- Preparing a url from predefined link string.
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //-- A url request to fetch data in asynchronous manner.
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
 
    //-- To reset the web-service related values
    [self resetProperties];
    
    //-- To initiate the connection object.
    _connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    //-- Schedule the run loop for connection
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //-- Start after initiation
    [_connection start];
}

#pragma mark - ==================================
#pragma mark NSURLConnection delegate functions
#pragma mark ==================================

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.title = @"";
    [appDelegate displayAnAlertWith:@"Alert !!" andMessage:[error localizedDescription]];
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
    });
    //-- To reset the web-service related values
    [self resetProperties];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //-- Create mutable data once the response received.
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    //-- Cache the response object for later use in ConnectionDidFinishLoading.
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //-- Append the data received from server.
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_response && ((NSHTTPURLResponse *)_response).statusCode == 200) {
        //-- As becuase downaloded data contains special characters first of all we have to conver it into String format.
        NSString *latinString = [[NSString alloc] initWithData:_data encoding:NSISOLatin1StringEncoding];
        
        //-- Now create a data from String content with the help of UTF8Encoding
        NSData *jsonData = [latinString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (latinString != nil && jsonData != nil) {
            NSError *error = nil;
            //-- Fetch key-value pair object from a JSON data
            NSDictionary *dictInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            //-- Display an error if you get at the time of converting a JSON data to an object.
            if (error != nil) {
                self.title = @"";
                [appDelegate displayAnAlertWith:@"Alert !!" andMessage:[NSString stringWithFormat:@"JSON Parsing Error due to : %@", [error localizedDescription]]];
            } else {
                NSLog(@"%@", [dictInfo description]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = dictInfo[@"title"];
                    if (_arrFacts) {
                        _arrFacts = nil;
                    }
                    _arrFacts = [NSArray arrayWithArray:dictInfo[@"rows"]];
                    if (_arrFacts != nil) {
                        self.tableView.hidden = NO;
                    } else {
                        self.tableView.hidden = YES;
                    }
                    [self.tableView reloadData];
                });
            }
        } else {
            self.title = @"";
            [appDelegate displayAnAlertWith:@"Alert !!" andMessage:@"An error while manipulating data or string conents."];
        }
        _data = nil;
    } else {
        self.title = @"";
        if (_data) {
            //-- As becuase downaloded data, first of all, we have to convert it into String format.
            NSString *errorMessage = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
            [appDelegate displayAnAlertWith:@"Alert !!" andMessage:errorMessage];
        } else {
            [appDelegate displayAnAlertWith:@"Alert !!" andMessage:@"No data available to download or an error while downloading a data."];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //-- To hide the network indicator once the response is availble.
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
    });
    //-- To reset the web-service related values
    [self resetProperties];
}

#pragma mark - ==================================
#pragma mark Table view data source
#pragma mark ==================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arrFacts) {
        return _arrFacts.count;
    } else {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
        return 110.0;
    } else {
        return 65.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //-- Reuse the cell with the identifier.
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        //-- Configure the cell if not available
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
            cell.detailTextLabel.font = [UIFont fontWithName:cell.detailTextLabel.font.familyName size:cell.detailTextLabel.font.pointSize + 8.0];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.familyName size:cell.textLabel.font.pointSize + 8.0];
        }
    }
    @try {
        if (_arrFacts) {
            //-- To fetch the object based on index
            NSDictionary *dictFactInfo = [_arrFacts objectAtIndex:indexPath.row];
            
            //-- To display the title text
            NSString *title = [NSString stringWithFormat:@"%@",dictFactInfo[@"title"]];
            if ([[title trim] length] > 0) {
                cell.textLabel.text = title;
            } else {
                cell.textLabel.text = @"No title available for this row.";
            }
            
            //-- To display the description text
            NSString *description = [NSString stringWithFormat:@"%@",dictFactInfo[@"description"]];
            if ([[description trim] length] > 0) {
                cell.detailTextLabel.text = description;
            } else {
                cell.detailTextLabel.text = @"No description available for this row.";
            }
            
            //-- To display the image in asynchronously manner to avoid the user interaction conflict.
            NSString *imagurlstring = [NSString stringWithFormat:@"%@",dictFactInfo[@"imageHref"]];
            if ([[imagurlstring trim] length] > 0) {
                NSURL *imageurl = [NSURL URLWithString:[imagurlstring trim]];
                __unsafe_unretained __typeof(cell)weakCell = cell;
                [cell.imageView sd_setImageWithURL:imageurl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image) {
                        //-- Resize the image and display it in the row.
                        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
                            weakCell.imageView.image = [self imageWithImage:image scaledToSize:CGSizeMake(100.0, 100.0)];
                        } else {
                            weakCell.imageView.image = [self imageWithImage:image scaledToSize:CGSizeMake(60.0, 60.0)];
                        }
                    } else {
                        weakCell.imageView.image = nil;
                    }
                    [weakCell layoutSubviews];
                    [weakCell setNeedsLayout];
                }];
            } else {
                cell.imageView.image = nil;
            }
        } else {
            cell.detailTextLabel.text = @"Click on Refresh icon or \"Pull to Refresh\" to fetch the data from server.";
        }
    } @catch (NSException *exception) {
        NSLog(@"An exception occurred due to %@", exception.reason);
    } @finally {
        return cell;
    }
}
*/
@end
