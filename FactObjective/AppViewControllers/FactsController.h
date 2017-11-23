//
//  FactsController.h
//  FactObjective
//
//  Created by Nilesh Prajapati on 23/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FactsControllerDeleagte;

@protocol FactsControllerDeleagte
@optional
- (void)connectionDidReceiveFailure:(NSString *)error;
- (void)connectionDidFinishLoading:(NSDictionary *)dictResponseInfo;
@end

@interface FactsController : NSObject
@property(strong, nonatomic) NSArray *arrFacts;
@property(assign, nonatomic) id<FactsControllerDeleagte> delegate;
- (void)fetchDataFromJSONFile;
@end


