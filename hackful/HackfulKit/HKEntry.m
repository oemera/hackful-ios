//
//  HKEntry.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKEntry.h"

@implementation HKEntry

@synthesize objectId = _objectId;
@synthesize posted = _posted;
@synthesize votes = _votes;
@synthesize text = _text;
@synthesize voted = _voted;
@synthesize user = _user;

- (id)initWithObjectId:(NSInteger)objectId
                posted:(NSDate*)posted 
                 votes:(NSInteger)votes
                  text:(NSString*)text
                 voted:(BOOL)voted
               andUser:(HKUser*)user {
    
    if (self = [super init]) {
        _objectId = objectId;
        _posted = posted;
        _votes = votes;
        _text = text;
        _voted = voted;
        _user = user;
    }
    
    return self;
}

@end
