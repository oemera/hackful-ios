//
//  HKPost.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKPost.h"
#import "NSDate+RailsDate.h"

@implementation HKPost

@synthesize link = _link;
@synthesize title = _title;
@synthesize commentCount = _commentCount;
@synthesize comments = _comments;

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

+ (HKPost*)postFromJSON:(id)json {
    NSInteger commentCount = [[json objectForKey:@"comment_count"] intValue];
    NSString *createdAt = [json objectForKey:@"created_at"];
    NSInteger objectId = [[json objectForKey:@"id"] intValue];
    NSString *link = [json objectForKey:@"link"];
    NSString *text = [json objectForKey:@"text"];
    NSString *title = [json objectForKey:@"title"];
    NSInteger upvotes = [[json objectForKey:@"up_votes"] intValue];
    NSDate *posted = [NSDate dateForRailsDateString:createdAt];
    HKUser *user = [HKUser userFromJSON:[json objectForKey:@"user"]];
    
    HKPost *post = [[HKPost alloc] initWithObjectId:objectId 
                                               link:link 
                                              title:title 
                                       commentCount:commentCount 
                                             posted:posted 
                                              votes:upvotes 
                                               text:text 
                                            andUser:user];
    return post;
}

@end
