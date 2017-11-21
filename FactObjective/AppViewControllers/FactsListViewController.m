//
//  FactsListViewController.m
//  FactObjective
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import "FactsListViewController.h"
#import "AppConstant.h"
#import "NSString+Additions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

//-- Private declaration properties
@interface FactsListViewController ()
@property(strong, nonatomic) UIRefreshControl *refreshControler;
@property(strong, nonatomic) NSArray *arrFacts;
@end

@implementation FactsListViewController
@synthesize refreshControler = _refreshControler;
@synthesize arrFacts = _arrFacts;

#pragma mark - ==================================
#pragma mark View Life-cycle
#pragma mark ==================================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //-- Tableview's row height & estimated row height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    //-- Tableview's pull to refresh control
    _refreshControler = [[UIRefreshControl alloc] init];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = _refreshControler;
    } else {
        [self.tableView addSubview:_refreshControler];
    }
    [_refreshControler addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    //-- NavigationBar right bar item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClicked:)];
    
    //-- Set title for very first time on each launch until data downloaded.
    self.title = @"Loading...";
    
    //-- Fetch JSON data from url
    [self fetchDataFromJSONFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ==================================
#pragma mark Controls click events
#pragma mark ==================================

- (IBAction)btnRefreshClicked:(id)sender {
    [_refreshControler endRefreshing];
    [self fetchDataFromJSONFile];
}

- (IBAction)pullToRefresh:(id)sender {
    [_refreshControler beginRefreshing];
    [self fetchDataFromJSONFile];
}

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
    
    //-- Make a web-service call to fetch a data from predefined url request.
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //-- To hide the network indicator once the response is availble.
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [_refreshControler endRefreshing];
        });
        
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data != nil) {
                //-- As becuase downaloded data contains special characters first of all we have to conver it into String format.
                NSString *latinString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                
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
                            _arrFacts = [NSArray arrayWithArray:dictInfo[@"rows"]];
                            if (_arrFacts != nil) {
                                self.tableView.hidden = NO;
                                [self.tableView reloadData];
                            } else {
                                self.tableView.hidden = YES;
                            }
                        });
                    }
                } else {
                    self.title = @"";
                    [appDelegate displayAnAlertWith:@"Alert !!" andMessage:@"An error while encoding data or string conents."];
                }
            } else {
                self.title = @"";
                [appDelegate displayAnAlertWith:@"Alert !!" andMessage:@"No data available to download or an error while downloading a data."];
            }
        } else {
            self.title = @"";
            [appDelegate displayAnAlertWith:@"Alert !!" andMessage:[connectionError localizedDescription]];
        }
    }];
}

#pragma mark - ==================================
#pragma mark Table view data source
#pragma mark ==================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arrFacts != nil) {
        return _arrFacts.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //-- Reuse the cell with the identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        //-- Configure the cell if not available
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    @try {
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
        NSString *imagurl = [NSString stringWithFormat:@"%@",dictFactInfo[@"imageHref"]];
        if ([[imagurl trim] length] > 0) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagurl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image != nil) {
                    //-- Resize the image and display it in the row.
                    cell.imageView.image = [self imageWithImage:image scaledToSize:CGSizeMake(60.0, 60.0)];
                } else {
                    cell.imageView.image = nil;
                }
            }];
        } else {
            cell.imageView.image = nil;
        }
    } @catch (NSException *exception) {
        NSLog(@"An exception occurred due to %@", exception.reason);
    } @finally {
        return cell;
    }
}

#pragma mark - ==================================
#pragma mark User-defined methods
#pragma mark ==================================

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
