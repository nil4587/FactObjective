//
//  Fact.h
//  FactObjective
//
//  Created by Nilesh Prajapati on 23/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fact : NSObject
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *descr;
@property(copy, nonatomic) NSString *imageHref;
- (id)initObjectWithDictionary:(NSDictionary *)dictInfo;
@end
