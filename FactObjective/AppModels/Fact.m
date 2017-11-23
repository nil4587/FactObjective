//
//  Fact.m
//  FactObjective
//
//  Created by Nilesh Prajapati on 23/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import "Fact.h"

@implementation Fact
@synthesize title = _title;
@synthesize descr = _descr;
@synthesize imageHref = _imageHref;

- (id)initObjectWithDictionary:(NSDictionary *)dictInfo {
    if (self == [super init]) {
        _title = dictInfo[@"title"];
        _descr = dictInfo[@"description"];
        _imageHref = dictInfo[@"imageHref"];
    }
    return self;
}

- (void)dealloc {
    _title = nil;
    _descr = nil;
    _imageHref = nil;
}
@end
