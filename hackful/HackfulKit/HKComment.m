//
//  HKComment.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKComment.h"
#import "NSDate+RailsDate.h"

@interface HKComment()
+ (NSArray*)proccessChildren:(id)json withDepth:(int)depth;
+ (HKComment*)commentFromJSON:(id)json withDepth:(int)depth;
@end

@implementation HKComment

@synthesize comments = _comments;
@synthesize depth = _depth;

+ (HKComment*)commentFromJSON:(id)json {
    return [self commentFromJSON:json withDepth:0];
}

+ (HKComment*)commentFromJSON:(id)json withDepth:(int)depth {
    NSDate *posted = [NSDate dateForRailsDateString:[json objectForKey:@"created_at"]];
    NSInteger objectId = [[json objectForKey:@"id"] intValue];
    NSString *text = [json objectForKey:@"text"];
    NSInteger votes = [[json objectForKey:@"up_votes"] intValue];
    HKUser *user = [HKUser userFromJSON:[json objectForKey:@"user"]];
    
    HKComment *comment = [[HKComment alloc] initWithObjectId:objectId posted:posted votes:votes text:text andUser:user];
    comment.depth = depth;
    [comment setComments:[[self class] proccessChildren:[json objectForKey:@"children"] withDepth:(depth+1)]];
    return comment;
}

+ (NSArray*)proccessChildren:(id)json withDepth:(int)depth {
    NSMutableArray *children = [[NSMutableArray alloc] init];
    for (id child in json) {
        HKComment *comment = [self commentFromJSON:child withDepth:depth];
        [children addObject:comment];
    }
    return [children copy];
}

@end
