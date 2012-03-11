//
//  HKPost.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKPost.h"

@implementation HKPost

@synthesize link = _link;
@synthesize title = _title;
@synthesize commentCount = _commentCount;

- (id)initWithObjectId:(NSInteger)objectId 
                  link:(NSString*)link
                 title:(NSString*)title 
          commentCount:(NSInteger)commentCount
                posted:(NSDate*)posted 
                 votes:(NSInteger)votes
                  text:(NSString*)text 
                  andUser:(HKUser*)user {
    
    self = [super initWithObjectId:objectId 
                            posted:posted 
                             votes:votes 
                              text:text 
                           andUser:user];
    if (self) {
        _link = link;
        _title = title;
        _commentCount = commentCount;
    }
    
    return self;
}

@end
