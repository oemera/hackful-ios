//
//  HKComment.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
    BOOL voted = [[json objectForKey:@"voted"] boolValue];
    HKUser *user = [HKUser userFromJSON:[json objectForKey:@"user"]];
    
    HKComment *comment = [[HKComment alloc] initWithObjectId:objectId posted:posted votes:votes text:text voted:voted andUser:user];
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
