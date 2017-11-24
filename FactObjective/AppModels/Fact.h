//
//  Fact.h
//  FactObjective
//
//  Created by Nilesh Prajapati on 23/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fact : NSObject
@property(copy, nonatomic) NSString *title; //-- Contains the 'title' of a record.
@property(copy, nonatomic) NSString *descr; //-- Contains the 'description' of a record.
@property(copy, nonatomic) NSString *imageHref; //-- Contains the 'image'url of a record.
- (id)initObjectWithDictionary:(NSDictionary *)dictInfo; //-- A method to convert the JSON/dictionary value to object model.
@end
